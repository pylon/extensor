/****************************************************************************
 *
 * MODULE:  tf.cpp
 * PURPOSE: nifs for tensorflow inference
 *
 ***************************************************************************/
/*-------------------[       Pre Include Defines       ]-------------------*/
/*-------------------[      Library Include Files      ]-------------------*/
#include <tensorflow/c/c_api.h>
/*-------------------[      Project Include Files      ]-------------------*/
#include "extensor.hpp"
/*-------------------[      Macros/Constants/Types     ]-------------------*/
typedef struct tagResource {
   TF_Session* session;
   TF_Graph*   graph;
} RESOURCE;
/*-------------------[        Global Variables         ]-------------------*/
/*-------------------[        Global Prototypes        ]-------------------*/
/*-------------------[        Module Variables         ]-------------------*/
static ErlNifResourceType* g_resource_type = NULL;
/*-------------------[        Module Prototypes        ]-------------------*/
static void nif_free_session (
   ErlNifEnv*          env,
   void*               object);
static void erl2tf_inputs(
   ErlNifEnv*          env,
   const ERL_NIF_TERM& tensor_map,
   TF_Graph*           graph,
   TF_Output*          inputs,
   TF_Tensor**         tensors,
   int                 count);
static void erl2tf_input(
   ErlNifEnv*          env,
   const ERL_NIF_TERM& key,
   const ERL_NIF_TERM& value,
   TF_Graph*           graph,
   TF_Output*          config,
   TF_Tensor**         tensors,
   int                 index);
static void erl2tf_outputs(
   ErlNifEnv*          env,
   const ERL_NIF_TERM& tensor_names,
   TF_Graph*           graph,
   TF_Output*          config,
   TF_Operation**      ops,
   int                 count,
   int*                opcount);
static ERL_NIF_TERM tf2erl_outputs(
   ErlNifEnv*          env,
   const ERL_NIF_TERM& name_list,
   TF_Tensor**         tensors,
   int                 count);
static void tf_check_status(
   TF_Status*          status);
static int tf_tensor_index(
   char*               name);
static void tf_free_tensors(
   TF_Tensor**         tensors,
   int                 count);
static void tf_noop_free(
   void*               data,
   size_t              len,
   void*               arg);
/*-------------------[         Implementation          ]-------------------*/
/*-----------< FUNCTION: nif_tf_init >---------------------------------------
// Purpose:    tensorflow module initialization
// Parameters: env - erlang environment
// Returns:    1 if successful
//             0 otherwise
---------------------------------------------------------------------------*/
int nif_tf_init (ErlNifEnv* env)
{
   // register the model resource type,
   // which holds running tensorflow sessions
   ErlNifResourceFlags flags = ERL_NIF_RT_CREATE;
   g_resource_type = enif_open_resource_type(
      env,
      NULL,
      "tf_session",
      &nif_free_session,
      flags,
      &flags);
   if (!g_resource_type)
      return 0;
   return 1;
}
/*-----------< FUNCTION: nif_tf_parse_frozen_graph >-------------------------
// Purpose:    reads a tensorflow graph_def and attaches it to a new session
//             . uses TF_GraphImportGraphDef to load the graph definition
//             . https://www.tensorflow.org/extend/tool_developers/#graphdef
// Parameters: graph_def - binary protobuf containing the graph def
//             config    - binary protobuf containing session config
// Returns:    reference to the new tensorflow session
---------------------------------------------------------------------------*/
ERL_NIF_TERM nif_tf_parse_frozen_graph (
   ErlNifEnv*         env,
   int                argc,
   const ERL_NIF_TERM argv[])
{
   // validate parameters
   if (!enif_is_binary(env, argv[0]))
      return enif_make_badarg(env);
   if (!enif_is_binary(env, argv[1]))
      return enif_make_badarg(env);
   // read the frozen graph and attach it to a new session
   TF_Status* status = NULL;
   TF_Graph* graph = NULL;
   TF_ImportGraphDefOptions* graph_options = NULL;
   TF_SessionOptions* session_options = NULL;
   TF_Session* session = NULL;
   ERL_NIF_TERM result;
   try {
      // allocate configuration/graph objects
      status          = CHECKALLOC(TF_NewStatus());
      graph           = CHECKALLOC(TF_NewGraph());
      graph_options   = CHECKALLOC(TF_NewImportGraphDefOptions());
      session_options = CHECKALLOC(TF_NewSessionOptions());
      // build the graph from the graphdef protobuf
      ErlNifBinary graph_bin; memset(&graph_bin, 0, sizeof(graph_bin));
      TF_Buffer    graph_pb;  memset(&graph_pb, 0, sizeof(graph_pb));
      CHECK(enif_inspect_binary(env, argv[0], &graph_bin), "invalid_graph");
      graph_pb.data   = graph_bin.data;
      graph_pb.length = graph_bin.size;
      TF_GraphImportGraphDef(graph, &graph_pb, graph_options, status);
      tf_check_status(status);
      // build the session config from the config protobuf
      ErlNifBinary config_bin;
      CHECK(enif_inspect_binary(env, argv[1], &config_bin), "invalid_config");
      TF_SetConfig(
         session_options,
         config_bin.data,
         config_bin.size,
         status);
      tf_check_status(status);
      // create the tensorflow session
      session = CHECKALLOC(TF_NewSession(graph, session_options, status));
      tf_check_status(status);
      // create the erlang resource to wrap the session
      RESOURCE* resource = CHECKALLOC((RESOURCE*)enif_alloc_resource(
         g_resource_type,
         sizeof(RESOURCE)));
      resource->session = session;
      resource->graph   = graph;
      session = NULL;
      graph   = NULL;
      // relinquish the model resource to erlang
      result = enif_make_resource(env, resource);
      enif_release_resource(resource);
   } catch (NifError& e) {
      result = e.to_term(env);
   }
   // cleanup
   if (session != NULL)
      TF_DeleteSession(session, status);
   if (status != NULL)
      TF_DeleteStatus(status);
   if (graph != NULL)
      TF_DeleteGraph(graph);
   if (graph_options != NULL)
      TF_DeleteImportGraphDefOptions(graph_options);
   if (session_options != NULL)
      TF_DeleteSessionOptions(session_options);
   return result;
}
/*-----------< FUNCTION: nif_tf_load_saved_model >---------------------------
// Purpose:    loads a tensorflow saved_model from a path
//             . uses TF_LoadSessionFromSavedModel to load the saved_model
//             . https://www.tensorflow.org/programmers_guide/saved_model
// Parameters: path   - path to the saved_model directory
//             tag    - saved_model tag to load
//             config - binary protobuf containing session config
// Returns:    reference to the new tensorflow session
---------------------------------------------------------------------------*/
ERL_NIF_TERM nif_tf_load_saved_model (
   ErlNifEnv*         env,
   int                argc,
   const ERL_NIF_TERM argv[])
{
   // validate parameters
   if (!enif_is_binary(env, argv[0]))
      return enif_make_badarg(env);
   if (!enif_is_binary(env, argv[1]))
      return enif_make_badarg(env);
   if (!enif_is_binary(env, argv[2]))
      return enif_make_badarg(env);
   // load the saved_model into a new session
   TF_Status* status = NULL;
   TF_Graph* graph = NULL;
   TF_SessionOptions* session_options = NULL;
   TF_Session* session = NULL;
   ERL_NIF_TERM result;
   try {
      // allocate configuration/graph objects
      status          = CHECKALLOC(TF_NewStatus());
      graph           = CHECKALLOC(TF_NewGraph());
      session_options = CHECKALLOC(TF_NewSessionOptions());
      // retrieve the model path
      ErlNifBinary path_bin; memset(&path_bin, 0, sizeof(path_bin));
      CHECK(enif_inspect_binary(env, argv[0], &path_bin), "invalid_path");
      char path_str[path_bin.size + 1]; memset(path_str, 0, sizeof(path_str));
      memcpy(path_str, path_bin.data, path_bin.size);
      // retrieve the inference tag name
      ErlNifBinary tag_bin; memset(&tag_bin, 0, sizeof(tag_bin));
      CHECK(enif_inspect_binary(env, argv[1], &tag_bin), "invalid_tag");
      char tag_str[path_bin.size + 1]; memset(tag_str, 0, sizeof(tag_str));
      char* tag_strs[] = { tag_str };
      memcpy(tag_str, tag_bin.data, tag_bin.size);
      // build the session config from the config protobuf
      ErlNifBinary config_bin; memset(&config_bin, 0, sizeof(config_bin));
      CHECK(enif_inspect_binary(env, argv[2], &config_bin), "invalid_config");
      TF_SetConfig(
         session_options,
         config_bin.data,
         config_bin.size,
         status);
      tf_check_status(status);
      // load the model and create the session
      session = TF_LoadSessionFromSavedModel(
         session_options,
         NULL,
         path_str,
         tag_strs,
         1,
         graph,
         NULL,
         status);
      tf_check_status(status);
      // create the erlang resource to wrap the session
      RESOURCE* resource = (RESOURCE*)CHECKALLOC(enif_alloc_resource(
         g_resource_type,
         sizeof(RESOURCE)));
      resource->session = session;
      resource->graph   = graph;
      session = NULL;
      graph   = NULL;
      // relinquish the model resource to erlang
      result = enif_make_resource(env, resource);
      enif_release_resource(resource);
   } catch (NifError& e) {
      result = e.to_term(env);
   }
   // cleanup
   if (session != NULL)
      TF_DeleteSession(session, status);
   if (status != NULL)
      TF_DeleteStatus(status);
   if (graph != NULL)
      TF_DeleteGraph(graph);
   if (session_options != NULL)
      TF_DeleteSessionOptions(session_options);
   return result;
}
/*-----------< FUNCTION: nif_tf_run_session >--------------------------------
// Purpose:    executes a tensorflow graph in a running session
// Parameters: session       - reference to the session to execute
//             input_tensors - map of name to a tensor tuple for inputs
//             output_names  - list of output tensors to evaluate
// Returns:    map of name to tensor tuple for each requested output
---------------------------------------------------------------------------*/
ERL_NIF_TERM nif_tf_run_session (
   ErlNifEnv*         env,
   int                argc,
   const ERL_NIF_TERM argv[])
{
   // validate parameters
   RESOURCE* resource = NULL;
   if (!enif_get_resource(env, argv[0], g_resource_type, (void**)&resource))
      return enif_make_badarg(env);
   if (!enif_is_map(env, argv[1]))
      return enif_make_badarg(env);
   if (!enif_is_list(env, argv[2]))
      return enif_make_badarg(env);
   // run the session and return its outputs
   TF_Status*  status    = NULL;
   TF_Tensor** i_tensors = NULL;
   TF_Tensor** o_tensors = NULL;
   size_t      i_count   = 0;
   unsigned    o_count   = 0;
   ERL_NIF_TERM result;
   try {
      status = CHECKALLOC(TF_NewStatus());
      // configure input tensors
      CHECK(enif_get_map_size(env, argv[1], &i_count));
      TF_Output  i_config[i_count];  memset(&i_config, 0, sizeof(i_config));
      i_tensors = nif_alloc<TF_Tensor*>(i_count);
      erl2tf_inputs(
         env,
         argv[1],
         resource->graph,
         i_config,
         i_tensors,
         i_count);
      // configure output tensors
      CHECK(enif_get_list_length(env, argv[2], &o_count));
      TF_Output     o_config[o_count]; memset(&o_config, 0, sizeof(o_config));
      TF_Operation* o_ops[o_count];    memset(o_ops, 0, sizeof(o_ops));
      o_tensors = nif_alloc<TF_Tensor*>(o_count);
      int o_opcount = 0;
      erl2tf_outputs(
         env,
         argv[2],
         resource->graph,
         o_config,
         o_ops,
         o_count,
         &o_opcount);
      // execute the session
      TF_SessionRun(
         resource->session,
         NULL,
         i_config, i_tensors, i_count,
         o_config, o_tensors, o_count,
         o_ops, o_opcount,
         NULL,
         status);
      tf_check_status(status);
      // retrieve output tensors
      result = tf2erl_outputs(
         env,
         argv[2],
         o_tensors,
         o_count);
   } catch (NifError& e) {
      result = e.to_term(env);
   }
   // cleanup
   if (status != NULL)
      TF_DeleteStatus(status);
   tf_free_tensors(i_tensors, i_count);
   tf_free_tensors(o_tensors, o_count);
   return result;
}
/*-----------< FUNCTION: nif_free_session >----------------------------------
// Purpose:    frees the memory associated with an extensor session resource
// Parameters: env    - current erlang environment
//             object - session resource reference to free
// Returns:    none
---------------------------------------------------------------------------*/
void nif_free_session (ErlNifEnv* env, void* object)
{
   RESOURCE* resource = (RESOURCE*)object;
   TF_Status* status = TF_NewStatus();
   if (resource->session != NULL)
      TF_DeleteSession(resource->session, status);
   if (resource->graph != NULL)
      TF_DeleteGraph(resource->graph);
   if (status != NULL)
      TF_DeleteStatus(status);
}
/*-----------< FUNCTION: erl2tf_inputs >-------------------------------------
// Purpose:    converts a map of name->tuples to tensorflow tensors
// Parameters: env        - current erlang environment
//             tensor_map - name->tuple tensor map
//             graph      - the current tensorflow graph
//             config     - return tensor input configuration via here
//             tensors    - return input tensors via here
//             count      - the number of input tensors to convert
// Returns:    none
---------------------------------------------------------------------------*/
void erl2tf_inputs(
   ErlNifEnv*          env,
   const ERL_NIF_TERM& tensor_map,
   TF_Graph*           graph,
   TF_Output*          config,
   TF_Tensor**         tensors,
   int                 count)
{
   ErlNifMapIterator iter;
   CHECKALLOC(enif_map_iterator_create(
      env,
      tensor_map,
      &iter,
      ERL_NIF_MAP_ITERATOR_FIRST));
   try {
      for (int i = 0; i < (int)count; i++) {
         ERL_NIF_TERM key;
         ERL_NIF_TERM value;
         CHECK(enif_map_iterator_get_pair(env, &iter, &key, &value));
         erl2tf_input(env, key, value, graph, config, tensors, i);
         enif_map_iterator_next(env, &iter);
      }
      enif_map_iterator_destroy(env, &iter);
   } catch (...) {
      enif_map_iterator_destroy(env, &iter);
      throw;
   }
}
/*-----------< FUNCTION: erl2tf_input >--------------------------------------
// Purpose:    converts a tensor tuple to a tensorflow tensors
// Parameters: env     - current erlang environment
//             key     - name of the tensor to convert
//             value   - tensor tuple
//             graph   - the current tensorflow graph
//             config  - return tensor input configuration via here
//             tensors - return input tensors via here
//             index   - index of the tensor being converted
// Returns:    none
---------------------------------------------------------------------------*/
void erl2tf_input(
   ErlNifEnv*          env,
   const ERL_NIF_TERM& key,
   const ERL_NIF_TERM& value,
   TF_Graph*           graph,
   TF_Output*          config,
   TF_Tensor**         tensors,
   int                 index)
{
   // retrieve the tensor op name and index
   ErlNifBinary key_bin; memset(&key_bin, 0, sizeof(key_bin));
   CHECK(enif_inspect_binary(env, key, &key_bin), "invalid_tensor_name");
   char key_str[key_bin.size + 1]; memset(key_str, 0, sizeof(key_str));
   memcpy(key_str, key_bin.data, key_bin.size);
   int op_index = tf_tensor_index(key_str);
   // retrieve the tensor tuple <type, shape, data>
   int tensor_arity = 0;
   const ERL_NIF_TERM* tensor_tuple = NULL;
   CHECK(
      enif_get_tuple(env, value, &tensor_arity, &tensor_tuple),
      "invalid_tensor_tuple");
   if (tensor_arity != 3)
      throw NifError("invalid_tensor_tuple");
   // retrieve the tensor data type
   int tensor_type = 0;
   CHECK(enif_get_int(env, tensor_tuple[0], &tensor_type));
   // retrieve the tensor shape
   int shape_arity = 0;
   const ERL_NIF_TERM* shape_tuple = NULL;
   CHECK(
      enif_get_tuple(env, tensor_tuple[1], &shape_arity, &shape_tuple),
      "invalid_shape_tuple");
   int64_t tensor_shape[shape_arity];
   for (int j = 0; j < shape_arity; j++) {
      ErlNifSInt64 shape_elem;
      CHECK(enif_get_int64(env, shape_tuple[j], &shape_elem), "invalid_shape");
      tensor_shape[j] = shape_elem;
   }
   // retrieve the tensor data
   ErlNifBinary tensor_bin; memset(&tensor_bin, 0, sizeof(tensor_bin));
   CHECK(
      enif_inspect_binary(env, tensor_tuple[2], &tensor_bin),
      "invalid_tensor_data");
   // create the input tensor
   tensors[index] = TF_NewTensor(
      (TF_DataType)tensor_type,
      tensor_shape,
      shape_arity,
      tensor_bin.data,
      tensor_bin.size,
      tf_noop_free,
      NULL);
   // configure the tensor input
   TF_Operation* op = CHECK(
      TF_GraphOperationByName(graph, key_str),
      "tensor_not_found");
   config[index].oper  = op;
   config[index].index = op_index;
}
/*-----------< FUNCTION: erl2tf_outputs >------------------------------------
// Purpose:    creates a tensorflow output config for a list of tensor names
// Parameters: env          - current erlang environment
//             tensor_names - list of output tensor names
//             graph        - the current tensorflow graph
//             config       - return tensor output configuration via here
//             ops          - return the list of operations to eval via here
//             count        - the number of outputs to convert
//             opcount      - return the number of ops to eval via here
// Returns:    none
---------------------------------------------------------------------------*/
void erl2tf_outputs(
   ErlNifEnv*          env,
   const ERL_NIF_TERM& tensor_names,
   TF_Graph*           graph,
   TF_Output*          config,
   TF_Operation**      ops,
   int                 count,
   int*                opcount)
{
   ERL_NIF_TERM output_list = tensor_names;
   for (int i = 0; i < (int)count; i++) {
      // fetch the next list element
      ERL_NIF_TERM tensor_name;
      CHECK(enif_get_list_cell(env, output_list, &tensor_name, &output_list));
      // retrieve the tensor op name and index
      ErlNifBinary name_bin; memset(&name_bin, 0, sizeof(name_bin));
      CHECK(
         enif_inspect_binary(env, tensor_name, &name_bin),
         "invalid_tensor_name");
      char name_str[name_bin.size + 1]; memset(name_str, 0, sizeof(name_str));
      memcpy(name_str, name_bin.data, name_bin.size);
      int op_index = tf_tensor_index(name_str);
      // configure the tensor output
      TF_Operation* op = CHECK(
         TF_GraphOperationByName(graph, name_str),
         "tensor_not_found");
      config[i].oper  = op;
      config[i].index = op_index;
      // configure the operation to execute
      // include each output op only once, even though it may be
      // referenced by multiple output tensors
      bool found_op = false;
      for (int j = 0; j < *opcount && !found_op; j++)
         if (ops[j] == op)
            found_op = true;
      if (!found_op)
         ops[(*opcount)++] = op;
   }
}
/*-----------< FUNCTION: tf2erl_outputs >------------------------------------
// Purpose:    converts a set of output tensors to an erlang map
// Parameters: env          - current erlang environment
//             tensor_names - list of output tensor names
//             tensors      - output tensors to convert
//             count        - the number of tensors to convert
// Returns:    erlang map containing name->tuple tensors
---------------------------------------------------------------------------*/
ERL_NIF_TERM tf2erl_outputs(
   ErlNifEnv*          env,
   const ERL_NIF_TERM& tensor_names,
   TF_Tensor**         tensors,
   int                 count)
{
   ERL_NIF_TERM name_list = tensor_names;
   ERL_NIF_TERM result = enif_make_new_map(env);
   for (int i = 0; i < count; i++) {
      // fetch the next list element
      ERL_NIF_TERM tensor_name;
      CHECK(enif_get_list_cell(env, name_list, &tensor_name, &name_list));
      // retrieve the tensor data type
      int tensor_type = TF_TensorType(tensors[i]);
      // retrive the tensor shape
      int shape_arity = TF_NumDims(tensors[i]);
      ERL_NIF_TERM tensor_shapes[shape_arity];
      for (int j = 0; j < shape_arity; j++)
         tensor_shapes[j] = enif_make_int64(env, TF_Dim(tensors[i], j));
      // retrieve the tensor data
      ErlNifBinary tensor_bin; memset(&tensor_bin, 0, sizeof(tensor_bin));
      CHECKALLOC(enif_alloc_binary(TF_TensorByteSize(tensors[i]), &tensor_bin));
      memcpy(tensor_bin.data, TF_TensorData(tensors[i]), tensor_bin.size);
      // create the output tuple <type, shape, data>
      ERL_NIF_TERM tensor_tuple = enif_make_tuple3(
         env,
         enif_make_int(env, tensor_type),
         enif_make_tuple_from_array(env, tensor_shapes, shape_arity),
         enif_make_binary(env, &tensor_bin));
      // add the output tuple to the map
      CHECKALLOC(enif_make_map_put(
         env,
         result,
         tensor_name,
         tensor_tuple,
         &result));
   }
   return result;
}
/*-----------< FUNCTION: tf_check_status >-----------------------------------
// Purpose:    checks a tensorflow status object, throwing on error
// Parameters: status - tensorflow status to check
// Returns:    none
---------------------------------------------------------------------------*/
void tf_check_status(TF_Status* status)
{
   if (TF_GetCode(status) != TF_OK) {
      char message[128 + 1];
      snprintf(
         message,
         sizeof(message) - 1,
         "%d: %s",
         TF_GetCode(status),
         TF_Message(status));
      throw NifError("tf_error", message);
   }
}
/*-----------< FUNCTION: tf_tensor_index >-----------------------------------
// Purpose:    extracts a tensor index from a tensor name, and converts
//             the name to an operation name (truncates after :)
// Parameters: name - on input, a tensor or operation name
//                    on output, an operation name
// Returns:    the tensor index within the operation (0 if not specified)
---------------------------------------------------------------------------*/
int tf_tensor_index(char* name) {
   char* index_str = strrchr(name, ':');
   int   index     = 0;
   if (index_str) {
      index = atoi(index_str + 1);
      *index_str = 0;
   }
   return index;
}
/*-----------< FUNCTION: tf_free_tensors >-----------------------------------
// Purpose:    frees an array of tensors and the array
// Parameters: tensors - the array of tensors to free
//             count   - the number of tensors in the array
// Returns:    none
---------------------------------------------------------------------------*/
void tf_free_tensors(
   TF_Tensor** tensors,
   int         count)
{
   if (tensors != NULL) {
      for (int i = 0; i < count; i++)
         if (tensors[i] != NULL)
            TF_DeleteTensor(tensors[i]);
      nif_free(tensors);
   }
}
/*-----------< FUNCTION: tf_noop_free >--------------------------------------
// Purpose:    leaky deallocator for tensorflow tensors that hold shared
//             buffers
// Parameters: data - buffer to free
//             len  - number of bytes to free
//             arg  - parameter passed to TF_NewTensor
// Returns:    none
---------------------------------------------------------------------------*/
void tf_noop_free(void* data, size_t len, void* arg)
{
}

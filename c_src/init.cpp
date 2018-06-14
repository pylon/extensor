/****************************************************************************
 *
 * MODULE:  init.cpp
 * PURPOSE: nif initialization and export
 *
 ***************************************************************************/
/*-------------------[       Pre Include Defines       ]-------------------*/
/*-------------------[      Library Include Files      ]-------------------*/
/*-------------------[      Project Include Files      ]-------------------*/
#include "extensor.hpp"
/*-------------------[      Macros/Constants/Types     ]-------------------*/
#define DECLARE_NIF(name)                                                  \
   extern ERL_NIF_TERM nif_##name (ErlNifEnv*, int, const ERL_NIF_TERM[])
#define EXPORT_NIF(name, args, ...)                                        \
   (ErlNifFunc){ #name, args, nif_##name, __VA_ARGS__ }
/*-------------------[        Global Variables         ]-------------------*/
/*-------------------[        Global Prototypes        ]-------------------*/
extern int nif_tf_init (ErlNifEnv* env);
/*-------------------[        Module Variables         ]-------------------*/
/*-------------------[        Module Prototypes        ]-------------------*/
DECLARE_NIF(tf_parse_frozen_graph);
DECLARE_NIF(tf_load_saved_model);
DECLARE_NIF(tf_run_session);
/*-------------------[         Implementation          ]-------------------*/
// nif function table
static ErlNifFunc nif_map[] = {
   EXPORT_NIF(tf_parse_frozen_graph, 2),
   EXPORT_NIF(tf_load_saved_model, 3),
   EXPORT_NIF(tf_run_session, 3),
};
/*-----------< FUNCTION: nif_loaded >----------------------------------------
// Purpose:    nif onload callback
// Parameters: env       - erlang environment
//             priv_data - return private state via here
//             state     - nif load parameter
// Returns:    1 if successful
//             0 otherwise
---------------------------------------------------------------------------*/
static int nif_loaded (ErlNifEnv* env, void** priv_data, ERL_NIF_TERM state)
{
   *priv_data = NULL;
   if (!nif_tf_init(env))
      return 1;
   return 0;
}
// nif entry point
ERL_NIF_INIT(
   Elixir.Extensor.NIF,
   nif_map,
   &nif_loaded,
   NULL,
   NULL,
   NULL);

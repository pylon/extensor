defmodule Extensor.Session do
  @moduledoc """
  The session module provides functions for loading tensorflow graphs into
  a session and executing operations within the session. Graphs are
  represented by protocol buffers and named tensors are used for all
  inputs/outputs.

  There are two primary methods for serializing models in tensorflow:
  frozen graph_defs and saved_models. A frozen graph_def is just a protocol
  buffer containing a compute graph with no variables (all variables have
  been frozen as consts). A saved_model is a directory containing metadata
  used for tensorflow serving (TFS) as well as weights for graph variables.
  For more information on these formats, see:

    * [graph_def](https://www.tensorflow.org/extend/tool_developers/#graphdef)
    * [saved_model](https://www.tensorflow.org/programmers_guide/saved_model)

  This module can be used to load either type of model.
  `parse/load_frozen_graph` loads a graph_def protocol buffer and imports
  it using `TF_GraphImportGraphDef`, and `load_saved_model` loads a
  saved_model using `TF_LoadSessionFromSavedModel`. Both functions create and
  return a reference to a tensorflow session that can be used to run
  operations, like model inference. A tensorflow ConfigProto can be passed to
  either function, in order to configure the session (GPU options, etc.).

  Once the session has been created, it can be executed any number of times
  using the `run` function. Tensorflow sessions are also thread-safe and
  maintain graph state per call, so they can be executed in parallel. The
  run function accepts a map of named input tensors and a list of output
  tensor names to evaluate.

  ### Example (Pythagorean Triple):
  ```elixir
  iex> session = Extensor.Session.load_saved_model!("test/data/pythagoras")

  iex> input = %{
      "a" => Extensor.Tensor.from_list([5]),
      "b" => Extensor.Tensor.from_list([12])
    }

  iex> output = Extensor.Session.run!(session, input, ["c"])

  iex> Extensor.Tensor.to_list(output["c"])
  [13.0]
  ```

  See the `Tensorflow.ConfigProto` module and
  [documentation](
  https://www.tensorflow.org/versions/r1.0/api_docs/python/tf/ConfigProto)
  for more information on how to pass configuration when creating a new
  session. The tensorflow protocol buffer modules were generated with the
  [protobuf-elixir](https://github.com/tony612/protobuf-elixir) library.
  """

  alias Extensor.{NIF, Tensor}
  alias Tensorflow.{ConfigProto, MetaGraphDef, SignatureDef}

  @type t :: %__MODULE__{
          resource: reference(),
          signatures: %{String.t() => SignatureDef.t()}
        }

  @default_config ConfigProto.new()

  @atom2tft %{
    float: 1,
    double: 2,
    int32: 3,
    uint8: 4,
    int16: 5,
    int8: 6,
    string: 7,
    complex64: 8,
    complex: 8,
    int64: 9,
    bool: 10,
    qint8: 11,
    quint8: 12,
    qint32: 13,
    bfloat16: 14,
    qint16: 15,
    quint16: 16,
    uint16: 17,
    complex128: 18,
    half: 19,
    resource: 20,
    variant: 21,
    uint32: 22,
    uint64: 23
  }

  @tft2atom Map.new(@atom2tft, fn {k, v} -> {v, k} end)
  @signature_default %SignatureDef{inputs: %{}, outputs: %{}}

  defstruct [:resource, signatures: %{}]

  @doc "loads a custom op kernel library"
  @spec load_library(name :: String.t()) :: :ok | {:error, any()}
  def load_library(name) do
    load_library!(name)
    :ok
  rescue
    e -> {:error, e}
  end

  @doc "loads a custom op kernel library"
  @spec load_library!(name :: String.t()) :: :ok
  def load_library!(name) do
    NIF.tf_load_library(name)
  end

  @doc "loads a graph_def from a file path"
  @spec load_frozen_graph(
          path :: String.t(),
          config :: %ConfigProto{}
        ) :: {:ok, t()} | {:error, any()}
  def load_frozen_graph(path, config \\ @default_config) do
    {:ok, load_frozen_graph!(path, config)}
  rescue
    e -> {:error, e}
  end

  @doc "loads a graph_def from a file path"
  @spec load_frozen_graph!(
          path :: String.t(),
          config :: %ConfigProto{}
        ) :: t() | no_return()
  def load_frozen_graph!(path, config \\ @default_config) do
    path
    |> File.read!()
    |> parse_frozen_graph!(config)
  end

  @doc "loads a graph_def from a binary string"
  @spec parse_frozen_graph(
          graph_pb :: binary(),
          config :: %ConfigProto{}
        ) :: {:ok, t()} | {:error, any()}
  def parse_frozen_graph(graph_pb, config \\ @default_config) do
    {:ok, parse_frozen_graph!(graph_pb, config)}
  rescue
    e -> {:error, e}
  end

  @doc "loads a graph_def from a binary string"
  @spec parse_frozen_graph!(
          graph_pb :: binary(),
          config :: %ConfigProto{}
        ) :: t() | no_return()
  def parse_frozen_graph!(graph_pb, config \\ @default_config) do
    resource = NIF.tf_parse_frozen_graph(graph_pb, ConfigProto.encode(config))

    %__MODULE__{
      resource: resource
    }
  end

  @doc "loads a saved_model from a directory path"
  @spec load_saved_model(
          path :: String.t(),
          config :: %ConfigProto{},
          tag :: String.t()
        ) :: {:ok, t()} | {:error, any()}
  def load_saved_model(path, config \\ @default_config, tag \\ "serve") do
    {:ok, load_saved_model!(path, config, tag)}
  rescue
    e -> {:error, e}
  end

  @doc "loads a saved_model from a directory path"
  @spec load_saved_model!(
          path :: String.t(),
          config :: %ConfigProto{},
          tag :: String.t()
        ) :: t() | no_return()
  def load_saved_model!(path, config \\ @default_config, tag \\ "serve") do
    # load the saved model directory from the nif
    {resource, metagraph} =
      NIF.tf_load_saved_model(path, tag, ConfigProto.encode(config))

    # parse the metagraph for signatures
    metagraph = MetaGraphDef.decode(metagraph)

    # return the session
    %__MODULE__{
      resource: resource,
      signatures: metagraph.signature_def
    }
  end

  @doc "executes a tensorflow session"
  @spec run(
          session :: t(),
          input_tensors :: %{String.t() => Tensor.t()},
          output_names :: [String.t(), ...] | nil,
          signature :: String.t()
        ) :: {:ok, %{String.t() => Tensor.t()}} | {:error, any}
  def run(
        session,
        input_tensors,
        output_names \\ nil,
        signature \\ "serving_default"
      ) do
    {:ok, run!(session, input_tensors, output_names, signature)}
  rescue
    e -> {:error, e}
  end

  @doc "executes a tensorflow session"
  @spec run!(
          session :: t(),
          input_tensors :: %{String.t() => Tensor.t()},
          output_names :: [String.t(), ...] | nil,
          signature :: String.t()
        ) :: %{String.t() => Tensor.t()}
  def run!(
        session,
        input_tensors,
        output_names \\ nil,
        signature \\ "serving_default"
      ) do
    # fetch the metadata for the requested signature and
    # default the output tensors to the signature outputs
    signature = session.signatures[signature] || @signature_default
    output_names = output_names || Map.keys(signature.outputs)

    # map the input names through the signaturedef mapping
    # convert the input tensor structs to values accepted by the nif
    input_tensors =
      input_tensors
      |> Map.new(fn {k, v} -> {sig2tensor(k, signature.inputs), ex2tf(v)} end)

    # create a parallel list of mapped tensor names,
    # so that we can invert the mapping on the other side
    result_names =
      output_names
      |> Enum.map(&sig2tensor(&1, signature.outputs))

    # run tensorflow inference
    output_tensors =
      NIF.tf_run_session(
        session.resource,
        input_tensors,
        result_names
      )

    # map the output tensor names through the signaturedef mapping
    # convert the nif tensor values to elixir tensor structs
    Enum.zip(output_names, result_names)
    |> Map.new(fn {s, t} -> {s, tf2ex(output_tensors[t])} end)
  end

  # convert a metagraph signature name to a tensor name
  defp sig2tensor(key, map) do
    case map[key] do
      %{encoding: {:name, key}} -> key
      _ -> key
    end
  end

  # convert an elixir tensor to a tensorflow tensor tuple
  defp ex2tf(tensor) do
    Tensor.validate!(tensor)
    {Map.fetch!(@atom2tft, tensor.type), tensor.shape, tensor.data}
  end

  # convert a tensorflow tensor tuple to an elixir tensor
  defp tf2ex({type, shape, data}) do
    %Tensor{type: Map.fetch!(@tft2atom, type), shape: shape, data: data}
  end
end

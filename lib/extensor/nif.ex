defmodule Extensor.NIF do
  @moduledoc """
  NIF wrapper module for tensorflow adapter functions
  """

  @type tensor_map :: %{String.t() => {integer(), tuple(), binary()}}

  @on_load :init

  @doc "module initialization callback"
  @spec init() :: :ok
  def init do
    path = Path.join(Application.app_dir(:extensor, "priv"), "extensor")

    with {:error, reason} <- :erlang.load_nif(String.to_charlist(path), 0) do
      raise inspect(reason)
    end
  end

  @doc "loads a custom op kernel library"
  @spec tf_load_library(name :: String.t()) :: :ok
  def tf_load_library(_name) do
    :erlang.nif_error(:nif_library_not_loaded)
  end

  @doc "loads a graph_def protobuf into a new tensorflow session"
  @spec tf_parse_frozen_graph(graph_pb :: binary(), config_pb :: binary()) ::
          reference()
  def tf_parse_frozen_graph(_graph_pb, _config_pb) do
    :erlang.nif_error(:nif_library_not_loaded)
  end

  @doc "loads a saved_model from a path into a new tensorflow session"
  @spec tf_load_saved_model(
          path :: String.t(),
          tag :: String.t(),
          config_pb :: binary()
        ) :: {reference(), binary()}
  def tf_load_saved_model(_path, _tag, _config_pb) do
    :erlang.nif_error(:nif_library_not_loaded)
  end

  @doc "executes the graph in a running session"
  @spec tf_run_session(
          session :: reference(),
          input_tensors :: tensor_map(),
          output_names :: [String.t()]
        ) :: tensor_map()
  def tf_run_session(_session, _input_tensors, _output_names) do
    :erlang.nif_error(:nif_library_not_loaded)
  end
end

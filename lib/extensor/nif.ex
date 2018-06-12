defmodule Extensor.NIF do
  @moduledoc """
  NIF wrapper module for tensorflow adapter functions
  """

  @on_load :init

  @doc "module initialization callback"
  @spec init() :: :ok
  def init do
    path = Path.join(Application.app_dir(:extensor, "priv"), "extensor")

    with {:error, reason} <- :erlang.load_nif(String.to_charlist(path), 0) do
      raise inspect(reason)
    end
  end
end

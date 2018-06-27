if Code.ensure_loaded?(Matrex) do
  defmodule Extensor.Matrex do
    @moduledoc """
    Optional `Matrex` integration
    """

    alias Extensor.Tensor

    @doc """
    Convert a `Matrex` matrix to a tensor struct
    """
    @spec to_tensor(matrix :: Matrex.t()) :: Tensor.t()
    def to_tensor(%Matrex{
          data:
            <<rows::unsigned-integer-little-32,
              cols::unsigned-integer-little-32, body::binary>>
        }) do
      %Tensor{
        type: :float,
        shape: {rows, cols},
        data: body
      }
    end

    @doc """
    Convert from an `Tensor` struct to a `Matrex` matrix

    Currently, this only works for two dimensional tensors and the type _must be_
    `:float`.
    """
    @spec from_tensor(tensor :: Tensor.t()) :: Matrex.t()
    def from_tensor(tensor) do
      cond do
        tensor.type != :float ->
          raise ArgumentError, "invalid tensor type: #{tensor.type}"

        tuple_size(tensor.shape) != 2 ->
          raise ArgumentError,
                "invalid tensor shape: #{tuple_size(tensor.shape)}"

        true ->
          {r, c} = tensor.shape

          %Matrex{
            data:
              <<r::unsigned-integer-little-32>> <>
                <<c::unsigned-integer-little-32>> <> tensor.data
          }
      end
    end
  end
end

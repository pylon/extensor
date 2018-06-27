defmodule Extensor.MatrexTest do
  use ExUnit.Case, async: true

  alias Extensor.Matrex, as: ExtensorMatrex
  alias Extensor.Tensor

  describe "matrix conversion" do
    test "to_tensor/1" do
      lol = [[1, 2], [3, 4]]

      # converting to a tensor
      assert Tensor.from_list(lol, :float) ==
               lol |> Matrex.new() |> ExtensorMatrex.to_tensor()
    end

    test "from_tensor/1" do
      lol = [[1, 2], [3, 4]]

      # converting back to a matrix
      assert Matrex.new(lol) ==
               lol |> Tensor.from_list(:float) |> ExtensorMatrex.from_tensor()

      # invalid type
      assert_raise(ArgumentError, fn ->
        lol |> Tensor.from_list(:double) |> ExtensorMatrex.from_tensor()
      end)

      # invalid shape
      assert_raise(ArgumentError, fn ->
        lol
        |> List.first()
        |> Tensor.from_list(:float)
        |> ExtensorMatrex.from_tensor()
      end)
    end
  end
end

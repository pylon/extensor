defmodule Extensor.TensorTest do
  use ExUnit.Case, async: true

  alias Extensor.Tensor

  @types [
    :float,
    :double,
    :int32,
    :uint8,
    :int16,
    :int8,
    :int64,
    :bool,
    :qint8,
    :quint8,
    :qint32,
    :qint16,
    :quint16,
    :uint32,
    :uint64
  ]

  test "list conversion" do
    # empty list
    assert Tensor.from_list([]) === %Tensor{}
    assert Tensor.to_list(%Tensor{}) === []

    # 1D list
    assert Tensor.from_list([1.1, 2.2]) === %Tensor{
             type: :float,
             shape: {2},
             data: <<1.1::native-float-32, 2.2::native-float-32>>
           }

    # 2D list
    assert Tensor.from_list([[1.1, 2.2], [3.3, 4.4]]) === %Tensor{
             type: :float,
             shape: {2, 2},
             data:
               <<1.1::native-float-32, 2.2::native-float-32,
                 3.3::native-float-32, 4.4::native-float-32>>
           }

    # list type serialization
    for t <- @types do
      expect = [1, 2, 3]
      actual = Tensor.from_list(expect, t)

      assert actual.type === t
      assert expect == Tensor.to_list(actual)
    end
  end

  test "validation" do
    # empty list
    assert Tensor.validate(%Tensor{}) === :ok
    Tensor.validate!(%Tensor{})

    # 1D list
    assert Tensor.validate(Tensor.from_list([1.1, 2.2])) === :ok
    Tensor.validate!(Tensor.from_list([1.1, 2.2]))

    # 2D list
    assert Tensor.validate(Tensor.from_list([[1.1, 2.2], [3.3, 4.4]])) === :ok
    Tensor.validate!(Tensor.from_list([[1.1, 2.2], [3.3, 4.4]]))

    # list type validation
    for t <- @types do
      assert Tensor.validate(Tensor.from_list([1, 2, 3], t)) === :ok
      Tensor.validate!(Tensor.from_list([1, 2, 3], t))
    end

    # invalid tensor type
    {:error, _e} = Tensor.validate(%Tensor{type: :invalid})

    assert_raise ArgumentError, fn ->
      Tensor.validate!(%Tensor{type: :invalid})
    end

    # invalid list shape
    {:error, _e} = Tensor.validate(Tensor.from_list([[1, 2], [3]]))

    assert_raise ArgumentError, fn ->
      Tensor.validate!(Tensor.from_list([[1, 2], [3]]))
    end
  end

  describe "matrix conversion" do
    test "from_matrix/1" do
      lol = [[1, 2], [3, 4]]

      # converting from a matrix
      assert Tensor.from_list(lol, :float) ==
               lol |> Matrex.new() |> Tensor.from_matrix()
    end

    test "to_matrix/1" do
      lol = [[1, 2], [3, 4]]

      # round tripping to a matrix
      assert Matrex.new(lol) ==
               lol |> Tensor.from_list(:float) |> Tensor.to_matrix()

      # invalid type
      assert_raise(ArgumentError, fn ->
        lol |> Tensor.from_list(:double) |> Tensor.to_matrix()
      end)

      # invalid shape
      assert_raise(ArgumentError, fn ->
        lol |> List.first() |> Tensor.from_list(:float) |> Tensor.to_matrix()
      end)
    end
  end
end

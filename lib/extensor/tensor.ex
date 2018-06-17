defmodule Extensor.Tensor do
  @moduledoc """
  This is a simple wrapper struct for a tensorflow tensor. It holds the
  data type, shape (dimensions), and binary data buffer for a tensor.

  The layout of the buffer is the same as what is used in tensorflow -
  row-major dimension ordering with native endian byte order. Extensor
  performs very little manipulation of the data buffer, in order to minimize
  the performance impact of using tensorflow from Elixir.

  The following atoms are used to represent the corresponding tensorflow
  data types.

  |atom|tensorflow type|
  |-|-|
  |`:float`|`TF_FLOAT`|
  |`:double`|`TF_DOUBLE`|
  |`:int32`|`TF_INT32`|
  |`:uint8`|`TF_UINT8`|
  |`:int16`|`TF_INT16`|
  |`:int8`|`TF_INT8`|
  |`:string`|`TF_STRING`|
  |`:complex64`|`TF_COMPLEX64`|
  |`:complex`|`TF_COMPLEX`|
  |`:int64`|`TF_INT64`|
  |`:bool`|`TF_BOOL`|
  |`:qint8`|`TF_QINT8`|
  |`:quint8`|`TF_QUINT8`|
  |`:qint32`|`TF_QINT32`|
  |`:bfloat16`|`TF_BFLOAT16`|
  |`:qint16`|`TF_QINT16`|
  |`:quint16`|`TF_QUINT16`|
  |`:uint16`|`TF_UINT16`|
  |`:complex128`|`TF_COMPLEX128`|
  |`:half`|`TF_HALF`|
  |`:resource`|`TF_RESOURCE`|
  |`:variant`|`TF_VARIANT`|
  |`:uint32`|`TF_UINT32`|
  |`:uint64`|`TF_UINT64`|

  For convenience, though, functions are provided for constructing tensors
  from (nested) lists. These functions use binary pattern matching and
  concatenation to convert Elixir data types to/from the tensorflow binary
  standard.

  Example:
  ```elixir
  iex> tensor = Extensor.Tensor.from_list([[1, 2], [3, 4]], :double)
  %Extensor.Tensor{
    type: :double,
    shape: {2, 2},
    data: <<0, 0, 128, 63, 0, 0, 0, 64, 0, 0, 64, 64, 0, 0, 128, 64>>
  }

  iex> Extensor.Tensor.to_list(tensor)
  [[1.0, 2.0], [3.0, 4.0]]
  ```

  This module can also be used to verify that a tensor's shape is consistent
  with its binary size. This can avoid segfaults in tensorflow when
  shape/size don't match.
  """

  @type data_type ::
          :float
          | :double
          | :int32
          | :uint8
          | :int16
          | :int8
          | :string
          | :complex64
          | :complex
          | :int64
          | :bool
          | :qint8
          | :quint8
          | :qint32
          | :bfloat16
          | :qint16
          | :quint16
          | :uint16
          | :complex128
          | :half
          | :resource
          | :variant
          | :uint32
          | :uint64

  @type t :: %__MODULE__{
          type: data_type(),
          shape: tuple(),
          data: binary()
        }

  defstruct type: :float, shape: {0}, data: <<>>

  @type_byte_size %{
    float: 4,
    double: 8,
    int32: 4,
    uint8: 1,
    int16: 2,
    int8: 1,
    string: nil,
    complex64: 16,
    complex: 8,
    int64: 8,
    bool: 1,
    qint8: 1,
    quint8: 1,
    qint32: 4,
    bfloat16: 2,
    qint16: 2,
    quint16: 2,
    uint16: 2,
    complex128: 32,
    half: 16,
    resource: nil,
    variant: nil,
    uint32: 4,
    uint64: 8
  }

  @doc "converts a (nested) list to a tensor structure"
  @spec from_list(list :: list(), type :: data_type()) :: t()
  def from_list(list, type \\ :float) do
    shape = List.to_tuple(list_shape(list))

    data =
      list
      |> List.flatten()
      |> Enum.map(&to_binary(&1, type))
      |> IO.iodata_to_binary()

    %__MODULE__{type: type, shape: shape, data: data}
  end

  defp list_shape([head | _] = list), do: [length(list) | list_shape(head)]
  defp list_shape([]), do: [0]
  defp list_shape(_), do: []

  @doc "converts a tensor to a nested list"
  @spec to_list(tensor :: t()) :: list()
  def to_list(%__MODULE__{data: <<>>} = _tensor) do
    []
  end

  def to_list(tensor) do
    to_list(
      tensor.data,
      tensor.type,
      _offset = 0,
      _size = byte_size(tensor.data),
      Tuple.to_list(tensor.shape)
    )
  end

  defp to_list(data, type, offset, size, [dim | shape]) do
    dim_size = div(size, dim)

    Enum.map(0..(dim - 1), fn i ->
      to_list(data, type, offset + i * dim_size, dim_size, shape)
    end)
  end

  defp to_list(data, type, offset, size, []) do
    from_binary(binary_part(data, offset, size), type)
  end

  defp from_binary(<<v::native-float-32>>, :float), do: v
  defp from_binary(<<v::native-float-64>>, :double), do: v
  defp from_binary(<<v::native-integer-32>>, :int32), do: v
  defp from_binary(<<v::native-unsigned-integer-8>>, :uint8), do: v
  defp from_binary(<<v::native-integer-16>>, :int16), do: v
  defp from_binary(<<v::native-integer-8>>, :int8), do: v
  defp from_binary(<<v::native-integer-64>>, :int64), do: v
  defp from_binary(<<v::native-integer-8>>, :bool), do: v
  defp from_binary(<<v::native-integer-8>>, :qint8), do: v
  defp from_binary(<<v::native-unsigned-integer-8>>, :quint8), do: v
  defp from_binary(<<v::native-integer-32>>, :qint32), do: v
  defp from_binary(<<v::native-integer-16>>, :qint16), do: v
  defp from_binary(<<v::native-unsigned-integer-16>>, :quint16), do: v
  defp from_binary(<<v::native-unsigned-integer-32>>, :uint32), do: v
  defp from_binary(<<v::native-unsigned-integer-64>>, :uint64), do: v

  defp to_binary(v, :float), do: <<v::native-float-32>>
  defp to_binary(v, :double), do: <<v::native-float-64>>
  defp to_binary(v, :int32), do: <<v::native-integer-32>>
  defp to_binary(v, :uint8), do: <<v::native-unsigned-integer-8>>
  defp to_binary(v, :int16), do: <<v::native-integer-16>>
  defp to_binary(v, :int8), do: <<v::native-integer-8>>
  defp to_binary(v, :int64), do: <<v::native-integer-64>>
  defp to_binary(v, :bool), do: <<v::native-integer-8>>
  defp to_binary(v, :qint8), do: <<v::native-integer-8>>
  defp to_binary(v, :quint8), do: <<v::native-unsigned-integer-8>>
  defp to_binary(v, :qint32), do: <<v::native-integer-32>>
  defp to_binary(v, :qint16), do: <<v::native-integer-16>>
  defp to_binary(v, :quint16), do: <<v::native-unsigned-integer-16>>
  defp to_binary(v, :uint32), do: <<v::native-unsigned-integer-32>>
  defp to_binary(v, :uint64), do: <<v::native-unsigned-integer-64>>

  @doc "validates the tensor shape/size"
  @spec validate(tensor :: t()) :: :ok | {:error, any()}
  def validate(tensor) do
    validate!(tensor)
  rescue
    e -> {:error, e}
  end

  @doc "validates the tensor shape/size"
  @spec validate!(tensor :: t()) :: :ok | no_return()
  def validate!(tensor) do
    if !Map.has_key?(@type_byte_size, tensor.type) do
      raise ArgumentError, "invalid tensor type: #{tensor.type}"
    end

    if type_size = Map.fetch!(@type_byte_size, tensor.type) do
      expect =
        tensor.shape
        |> Tuple.to_list()
        |> Enum.reduce(type_size, &(&1 * &2))

      actual = byte_size(tensor.data)

      if expect !== actual do
        raise ArgumentError, "tensor size mismatch: #{actual} != #{expect}"
      end
    end

    :ok
  end
end

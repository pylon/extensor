defmodule Tensorflow.TensorDescription do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          dtype: integer,
          shape: Tensorflow.TensorShapeProto.t(),
          allocation_description: Tensorflow.AllocationDescription.t()
        }
  defstruct [:dtype, :shape, :allocation_description]

  field(:dtype, 1, type: Tensorflow.DataType, enum: true)
  field(:shape, 2, type: Tensorflow.TensorShapeProto)
  field(:allocation_description, 4, type: Tensorflow.AllocationDescription)
end

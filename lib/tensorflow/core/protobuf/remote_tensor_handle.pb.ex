defmodule Tensorflow.Eager.ResourceDtypeAndShape do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          dtype: Tensorflow.DataType.t(),
          shape: Tensorflow.TensorShapeProto.t() | nil
        }
  defstruct [:dtype, :shape]

  field(:dtype, 1, type: Tensorflow.DataType, enum: true)
  field(:shape, 2, type: Tensorflow.TensorShapeProto)
end

defmodule Tensorflow.Eager.RemoteTensorHandle do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          op_id: integer,
          output_num: integer,
          device: String.t(),
          op_device: String.t(),
          dtype: Tensorflow.DataType.t(),
          resource_dtypes_and_shapes: [
            Tensorflow.Eager.ResourceDtypeAndShape.t()
          ]
        }
  defstruct [
    :op_id,
    :output_num,
    :device,
    :op_device,
    :dtype,
    :resource_dtypes_and_shapes
  ]

  field(:op_id, 1, type: :int64)
  field(:output_num, 2, type: :int32)
  field(:device, 3, type: :string)
  field(:op_device, 4, type: :string)
  field(:dtype, 5, type: Tensorflow.DataType, enum: true)

  field(:resource_dtypes_and_shapes, 6,
    repeated: true,
    type: Tensorflow.Eager.ResourceDtypeAndShape
  )
end

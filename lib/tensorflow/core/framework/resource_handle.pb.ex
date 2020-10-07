defmodule Tensorflow.ResourceHandleProto.DtypeAndShape do
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

defmodule Tensorflow.ResourceHandleProto do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          device: String.t(),
          container: String.t(),
          name: String.t(),
          hash_code: non_neg_integer,
          maybe_type_name: String.t(),
          dtypes_and_shapes: [
            Tensorflow.ResourceHandleProto.DtypeAndShape.t()
          ]
        }
  defstruct [
    :device,
    :container,
    :name,
    :hash_code,
    :maybe_type_name,
    :dtypes_and_shapes
  ]

  field(:device, 1, type: :string)
  field(:container, 2, type: :string)
  field(:name, 3, type: :string)
  field(:hash_code, 4, type: :uint64)
  field(:maybe_type_name, 5, type: :string)

  field(:dtypes_and_shapes, 6,
    repeated: true,
    type: Tensorflow.ResourceHandleProto.DtypeAndShape
  )
end

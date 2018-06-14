defmodule Tensorflow.TensorProto do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          dtype: integer,
          tensor_shape: Tensorflow.TensorShapeProto.t(),
          version_number: integer,
          tensor_content: String.t(),
          half_val: [integer],
          float_val: [float],
          double_val: [float],
          int_val: [integer],
          string_val: [String.t()],
          scomplex_val: [float],
          int64_val: [integer],
          bool_val: [boolean],
          dcomplex_val: [float],
          resource_handle_val: [Tensorflow.ResourceHandleProto.t()],
          variant_val: [Tensorflow.VariantTensorDataProto.t()],
          uint32_val: [non_neg_integer],
          uint64_val: [non_neg_integer]
        }
  defstruct [
    :dtype,
    :tensor_shape,
    :version_number,
    :tensor_content,
    :half_val,
    :float_val,
    :double_val,
    :int_val,
    :string_val,
    :scomplex_val,
    :int64_val,
    :bool_val,
    :dcomplex_val,
    :resource_handle_val,
    :variant_val,
    :uint32_val,
    :uint64_val
  ]

  field(:dtype, 1, type: Tensorflow.DataType, enum: true)
  field(:tensor_shape, 2, type: Tensorflow.TensorShapeProto)
  field(:version_number, 3, type: :int32)
  field(:tensor_content, 4, type: :bytes)
  field(:half_val, 13, repeated: true, type: :int32, packed: true)
  field(:float_val, 5, repeated: true, type: :float, packed: true)
  field(:double_val, 6, repeated: true, type: :double, packed: true)
  field(:int_val, 7, repeated: true, type: :int32, packed: true)
  field(:string_val, 8, repeated: true, type: :bytes)
  field(:scomplex_val, 9, repeated: true, type: :float, packed: true)
  field(:int64_val, 10, repeated: true, type: :int64, packed: true)
  field(:bool_val, 11, repeated: true, type: :bool, packed: true)
  field(:dcomplex_val, 12, repeated: true, type: :double, packed: true)

  field(
    :resource_handle_val,
    14,
    repeated: true,
    type: Tensorflow.ResourceHandleProto
  )

  field(
    :variant_val,
    15,
    repeated: true,
    type: Tensorflow.VariantTensorDataProto
  )

  field(:uint32_val, 16, repeated: true, type: :uint32, packed: true)
  field(:uint64_val, 17, repeated: true, type: :uint64, packed: true)
end

defmodule Tensorflow.VariantTensorDataProto do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          type_name: String.t(),
          metadata: String.t(),
          tensors: [Tensorflow.TensorProto.t()]
        }
  defstruct [:type_name, :metadata, :tensors]

  field(:type_name, 1, type: :string)
  field(:metadata, 2, type: :bytes)
  field(:tensors, 3, repeated: true, type: Tensorflow.TensorProto)
end

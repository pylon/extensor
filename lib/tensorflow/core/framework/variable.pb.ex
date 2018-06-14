defmodule Tensorflow.VariableDef do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          variable_name: String.t(),
          initial_value_name: String.t(),
          initializer_name: String.t(),
          snapshot_name: String.t(),
          save_slice_info_def: Tensorflow.SaveSliceInfoDef.t(),
          is_resource: boolean,
          trainable: boolean
        }
  defstruct [
    :variable_name,
    :initial_value_name,
    :initializer_name,
    :snapshot_name,
    :save_slice_info_def,
    :is_resource,
    :trainable
  ]

  field(:variable_name, 1, type: :string)
  field(:initial_value_name, 6, type: :string)
  field(:initializer_name, 2, type: :string)
  field(:snapshot_name, 3, type: :string)
  field(:save_slice_info_def, 4, type: Tensorflow.SaveSliceInfoDef)
  field(:is_resource, 5, type: :bool)
  field(:trainable, 7, type: :bool)
end

defmodule Tensorflow.SaveSliceInfoDef do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          full_name: String.t(),
          full_shape: [integer],
          var_offset: [integer],
          var_shape: [integer]
        }
  defstruct [:full_name, :full_shape, :var_offset, :var_shape]

  field(:full_name, 1, type: :string)
  field(:full_shape, 2, repeated: true, type: :int64)
  field(:var_offset, 3, repeated: true, type: :int64)
  field(:var_shape, 4, repeated: true, type: :int64)
end

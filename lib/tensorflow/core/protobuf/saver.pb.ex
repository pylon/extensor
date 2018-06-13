defmodule Tensorflow.SaverDef do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          filename_tensor_name: String.t(),
          save_tensor_name: String.t(),
          restore_op_name: String.t(),
          max_to_keep: integer,
          sharded: boolean,
          keep_checkpoint_every_n_hours: float,
          version: integer
        }
  defstruct [
    :filename_tensor_name,
    :save_tensor_name,
    :restore_op_name,
    :max_to_keep,
    :sharded,
    :keep_checkpoint_every_n_hours,
    :version
  ]

  field(:filename_tensor_name, 1, type: :string)
  field(:save_tensor_name, 2, type: :string)
  field(:restore_op_name, 3, type: :string)
  field(:max_to_keep, 4, type: :int32)
  field(:sharded, 5, type: :bool)
  field(:keep_checkpoint_every_n_hours, 6, type: :float)

  field(
    :version,
    7,
    type: Tensorflow.SaverDef.CheckpointFormatVersion,
    enum: true
  )
end

defmodule Tensorflow.SaverDef.CheckpointFormatVersion do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  field(:LEGACY, 0)
  field(:V1, 1)
  field(:V2, 2)
end

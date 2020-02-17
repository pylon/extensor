defmodule Tensorflow.QueueRunnerDef do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          queue_name: String.t(),
          enqueue_op_name: [String.t()],
          close_op_name: String.t(),
          cancel_op_name: String.t(),
          queue_closed_exception_types: [[Tensorflow.Error.Code.t()]]
        }
  defstruct [
    :queue_name,
    :enqueue_op_name,
    :close_op_name,
    :cancel_op_name,
    :queue_closed_exception_types
  ]

  field(:queue_name, 1, type: :string)
  field(:enqueue_op_name, 2, repeated: true, type: :string)
  field(:close_op_name, 3, type: :string)
  field(:cancel_op_name, 4, type: :string)

  field(:queue_closed_exception_types, 5,
    repeated: true,
    type: Tensorflow.Error.Code,
    enum: true
  )
end

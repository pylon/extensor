defmodule Tensorflow.Eager.Operation.Input do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          item: {atom, any}
        }
  defstruct [:item]

  oneof(:item, 0)

  field(:remote_handle, 1, type: Tensorflow.Eager.RemoteTensorHandle, oneof: 0)

  field(:tensor, 2, type: Tensorflow.TensorProto, oneof: 0)
end

defmodule Tensorflow.Eager.Operation.AttrsEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: Tensorflow.AttrValue.t() | nil
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: Tensorflow.AttrValue)
end

defmodule Tensorflow.Eager.Operation do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          id: integer,
          name: String.t(),
          op_inputs: [Tensorflow.Eager.Operation.Input.t()],
          control_op_ids: [integer],
          attrs: %{String.t() => Tensorflow.AttrValue.t() | nil},
          device: String.t(),
          is_component_function: boolean,
          func_step_id: integer,
          is_function: boolean
        }
  defstruct [
    :id,
    :name,
    :op_inputs,
    :control_op_ids,
    :attrs,
    :device,
    :is_component_function,
    :func_step_id,
    :is_function
  ]

  field(:id, 1, type: :int64)
  field(:name, 2, type: :string)

  field(:op_inputs, 10, repeated: true, type: Tensorflow.Eager.Operation.Input)

  field(:control_op_ids, 4, repeated: true, type: :int64)

  field(:attrs, 5,
    repeated: true,
    type: Tensorflow.Eager.Operation.AttrsEntry,
    map: true
  )

  field(:device, 6, type: :string)
  field(:is_component_function, 7, type: :bool)
  field(:func_step_id, 8, type: :int64)
  field(:is_function, 9, type: :bool)
end

defmodule Tensorflow.Eager.QueueItem do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          item: {atom, any}
        }
  defstruct [:item]

  oneof(:item, 0)

  field(:handle_to_decref, 1,
    type: Tensorflow.Eager.RemoteTensorHandle,
    oneof: 0
  )

  field(:operation, 2, type: Tensorflow.Eager.Operation, oneof: 0)
  field(:send_tensor, 3, type: Tensorflow.Eager.SendTensorOp, oneof: 0)

  field(:register_function, 4,
    type: Tensorflow.Eager.RegisterFunctionOp,
    oneof: 0
  )

  field(:cleanup_function, 5,
    type: Tensorflow.Eager.CleanupFunctionOp,
    oneof: 0
  )

  field(:sync_remote_executor_for_stream, 6,
    type: Tensorflow.Eager.SyncRemoteExecutorForStream,
    oneof: 0
  )

  field(:send_packed_handle, 7,
    type: Tensorflow.Eager.SendPackedHandleOp,
    oneof: 0
  )
end

defmodule Tensorflow.Eager.QueueResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          shape: [Tensorflow.TensorShapeProto.t()],
          device: [String.t()],
          tensor: [Tensorflow.TensorProto.t()]
        }
  defstruct [:shape, :device, :tensor]

  field(:shape, 1, repeated: true, type: Tensorflow.TensorShapeProto)
  field(:device, 3, repeated: true, type: :string)
  field(:tensor, 2, repeated: true, type: Tensorflow.TensorProto)
end

defmodule Tensorflow.Eager.CreateContextRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          server_def: Tensorflow.ServerDef.t() | nil,
          async: boolean,
          keep_alive_secs: integer,
          version_def: Tensorflow.VersionDef.t() | nil,
          cluster_device_attributes: [Tensorflow.DeviceAttributes.t()],
          context_id: non_neg_integer,
          context_view_id: non_neg_integer,
          lazy_copy_remote_function_inputs: boolean
        }
  defstruct [
    :server_def,
    :async,
    :keep_alive_secs,
    :version_def,
    :cluster_device_attributes,
    :context_id,
    :context_view_id,
    :lazy_copy_remote_function_inputs
  ]

  field(:server_def, 1, type: Tensorflow.ServerDef)
  field(:async, 2, type: :bool)
  field(:keep_alive_secs, 3, type: :int64)
  field(:version_def, 4, type: Tensorflow.VersionDef)

  field(:cluster_device_attributes, 6,
    repeated: true,
    type: Tensorflow.DeviceAttributes
  )

  field(:context_id, 7, type: :fixed64)
  field(:context_view_id, 8, type: :fixed64)
  field(:lazy_copy_remote_function_inputs, 9, type: :bool)
end

defmodule Tensorflow.Eager.CreateContextResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          device_attributes: [Tensorflow.DeviceAttributes.t()]
        }
  defstruct [:device_attributes]

  field(:device_attributes, 2,
    repeated: true,
    type: Tensorflow.DeviceAttributes
  )
end

defmodule Tensorflow.Eager.UpdateContextRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          server_def: Tensorflow.ServerDef.t() | nil,
          cluster_device_attributes: [Tensorflow.DeviceAttributes.t()],
          context_id: non_neg_integer,
          context_view_id: non_neg_integer
        }
  defstruct [
    :server_def,
    :cluster_device_attributes,
    :context_id,
    :context_view_id
  ]

  field(:server_def, 1, type: Tensorflow.ServerDef)

  field(:cluster_device_attributes, 2,
    repeated: true,
    type: Tensorflow.DeviceAttributes
  )

  field(:context_id, 3, type: :fixed64)
  field(:context_view_id, 4, type: :fixed64)
end

defmodule Tensorflow.Eager.UpdateContextResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          device_attributes: [Tensorflow.DeviceAttributes.t()]
        }
  defstruct [:device_attributes]

  field(:device_attributes, 1,
    repeated: true,
    type: Tensorflow.DeviceAttributes
  )
end

defmodule Tensorflow.Eager.EnqueueRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          context_id: non_neg_integer,
          queue: [Tensorflow.Eager.QueueItem.t()]
        }
  defstruct [:context_id, :queue]

  field(:context_id, 1, type: :fixed64)
  field(:queue, 3, repeated: true, type: Tensorflow.Eager.QueueItem)
end

defmodule Tensorflow.Eager.EnqueueResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          queue_response: [Tensorflow.Eager.QueueResponse.t()]
        }
  defstruct [:queue_response]

  field(:queue_response, 1,
    repeated: true,
    type: Tensorflow.Eager.QueueResponse
  )
end

defmodule Tensorflow.Eager.WaitQueueDoneRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          context_id: non_neg_integer,
          op_id: [integer]
        }
  defstruct [:context_id, :op_id]

  field(:context_id, 1, type: :fixed64)
  field(:op_id, 2, repeated: true, type: :int64)
end

defmodule Tensorflow.Eager.WaitQueueDoneResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{}
  defstruct []
end

defmodule Tensorflow.Eager.RunComponentFunctionRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          context_id: non_neg_integer,
          operation: Tensorflow.Eager.Operation.t() | nil,
          output_num: [integer]
        }
  defstruct [:context_id, :operation, :output_num]

  field(:context_id, 1, type: :fixed64)
  field(:operation, 2, type: Tensorflow.Eager.Operation)
  field(:output_num, 3, repeated: true, type: :int32)
end

defmodule Tensorflow.Eager.RunComponentFunctionResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          shape: [Tensorflow.TensorShapeProto.t()],
          tensor: [Tensorflow.TensorProto.t()]
        }
  defstruct [:shape, :tensor]

  field(:shape, 1, repeated: true, type: Tensorflow.TensorShapeProto)
  field(:tensor, 2, repeated: true, type: Tensorflow.TensorProto)
end

defmodule Tensorflow.Eager.KeepAliveRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          context_id: non_neg_integer
        }
  defstruct [:context_id]

  field(:context_id, 1, type: :fixed64)
end

defmodule Tensorflow.Eager.KeepAliveResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          context_view_id: non_neg_integer
        }
  defstruct [:context_view_id]

  field(:context_view_id, 1, type: :fixed64)
end

defmodule Tensorflow.Eager.CloseContextRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          context_id: non_neg_integer,
          context_view_id: non_neg_integer
        }
  defstruct [:context_id, :context_view_id]

  field(:context_id, 1, type: :fixed64)
  field(:context_view_id, 2, type: :fixed64)
end

defmodule Tensorflow.Eager.CloseContextResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{}
  defstruct []
end

defmodule Tensorflow.Eager.RegisterFunctionOp do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          function_def: Tensorflow.FunctionDef.t() | nil,
          is_component_function: boolean,
          library: Tensorflow.FunctionDefLibrary.t() | nil
        }
  defstruct [:function_def, :is_component_function, :library]

  field(:function_def, 1, type: Tensorflow.FunctionDef)
  field(:is_component_function, 2, type: :bool)
  field(:library, 3, type: Tensorflow.FunctionDefLibrary)
end

defmodule Tensorflow.Eager.CleanupFunctionOp do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          step_id: integer
        }
  defstruct [:step_id]

  field(:step_id, 1, type: :int64)
end

defmodule Tensorflow.Eager.SyncRemoteExecutorForStream do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{}
  defstruct []
end

defmodule Tensorflow.Eager.SendTensorOp do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          op_id: integer,
          tensors: [Tensorflow.TensorProto.t()],
          device_name: String.t()
        }
  defstruct [:op_id, :tensors, :device_name]

  field(:op_id, 1, type: :int64)
  field(:tensors, 2, repeated: true, type: Tensorflow.TensorProto)
  field(:device_name, 3, type: :string)
end

defmodule Tensorflow.Eager.SendPackedHandleOp.LocalTensorHandle do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          tensor: Tensorflow.TensorProto.t() | nil,
          device: String.t()
        }
  defstruct [:tensor, :device]

  field(:tensor, 1, type: Tensorflow.TensorProto)
  field(:device, 2, type: :string)
end

defmodule Tensorflow.Eager.SendPackedHandleOp.Handle do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          item: {atom, any}
        }
  defstruct [:item]

  oneof(:item, 0)

  field(:local_handle, 1,
    type: Tensorflow.Eager.SendPackedHandleOp.LocalTensorHandle,
    oneof: 0
  )

  field(:remote_handle, 2, type: Tensorflow.Eager.RemoteTensorHandle, oneof: 0)
end

defmodule Tensorflow.Eager.SendPackedHandleOp do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          op_id: integer,
          handles: [Tensorflow.Eager.SendPackedHandleOp.Handle.t()],
          device_name: String.t()
        }
  defstruct [:op_id, :handles, :device_name]

  field(:op_id, 1, type: :int64)

  field(:handles, 2,
    repeated: true,
    type: Tensorflow.Eager.SendPackedHandleOp.Handle
  )

  field(:device_name, 3, type: :string)
end

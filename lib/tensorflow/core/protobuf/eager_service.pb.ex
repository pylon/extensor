defmodule Tensorflow.Eager.RemoteTensorHandle do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          op_id: integer,
          output_num: integer
        }
  defstruct [:op_id, :output_num]

  field(:op_id, 1, type: :int64)
  field(:output_num, 2, type: :int32)
end

defmodule Tensorflow.Eager.Operation do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          id: integer,
          name: String.t(),
          inputs: [Tensorflow.Eager.RemoteTensorHandle.t()],
          control_op_ids: [integer],
          attrs: %{String.t() => Tensorflow.AttrValue.t()},
          device: String.t()
        }
  defstruct [:id, :name, :inputs, :control_op_ids, :attrs, :device]

  field(:id, 1, type: :int64)
  field(:name, 2, type: :string)
  field(:inputs, 3, repeated: true, type: Tensorflow.Eager.RemoteTensorHandle)
  field(:control_op_ids, 4, repeated: true, type: :int64)

  field(
    :attrs,
    5,
    repeated: true,
    type: Tensorflow.Eager.Operation.AttrsEntry,
    map: true
  )

  field(:device, 6, type: :string)
end

defmodule Tensorflow.Eager.Operation.AttrsEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: Tensorflow.AttrValue.t()
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: Tensorflow.AttrValue)
end

defmodule Tensorflow.Eager.QueueItem do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          item: {atom, any}
        }
  defstruct [:item]

  oneof(:item, 0)

  field(
    :handle_to_decref,
    1,
    type: Tensorflow.Eager.RemoteTensorHandle,
    oneof: 0
  )

  field(:operation, 2, type: Tensorflow.Eager.Operation, oneof: 0)
end

defmodule Tensorflow.Eager.CreateContextRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          server_def: Tensorflow.ServerDef.t(),
          async: boolean,
          keep_alive_secs: integer,
          version_def: Tensorflow.VersionDef.t()
        }
  defstruct [:server_def, :async, :keep_alive_secs, :version_def]

  field(:server_def, 1, type: Tensorflow.ServerDef)
  field(:async, 2, type: :bool)
  field(:keep_alive_secs, 3, type: :int64)
  field(:version_def, 4, type: Tensorflow.VersionDef)
end

defmodule Tensorflow.Eager.CreateContextResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          context_id: non_neg_integer,
          device_attributes: [Tensorflow.DeviceAttributes.t()]
        }
  defstruct [:context_id, :device_attributes]

  field(:context_id, 1, type: :fixed64)

  field(
    :device_attributes,
    2,
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

  defstruct []
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

  defstruct []
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

  defstruct []
end

defmodule Tensorflow.Eager.CloseContextRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          context_id: non_neg_integer
        }
  defstruct [:context_id]

  field(:context_id, 1, type: :fixed64)
end

defmodule Tensorflow.Eager.CloseContextResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Tensorflow.Eager.RegisterFunctionRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          context_id: non_neg_integer,
          function_def: Tensorflow.FunctionDef.t()
        }
  defstruct [:context_id, :function_def]

  field(:context_id, 1, type: :fixed64)
  field(:function_def, 2, type: Tensorflow.FunctionDef)
end

defmodule Tensorflow.Eager.RegisterFunctionResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

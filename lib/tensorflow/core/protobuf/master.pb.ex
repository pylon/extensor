defmodule Tensorflow.CreateSessionRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          graph_def: Tensorflow.GraphDef.t() | nil,
          config: Tensorflow.ConfigProto.t() | nil,
          target: String.t()
        }
  defstruct [:graph_def, :config, :target]

  field(:graph_def, 1, type: Tensorflow.GraphDef)
  field(:config, 2, type: Tensorflow.ConfigProto)
  field(:target, 3, type: :string)
end

defmodule Tensorflow.CreateSessionResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          session_handle: String.t(),
          graph_version: integer
        }
  defstruct [:session_handle, :graph_version]

  field(:session_handle, 1, type: :string)
  field(:graph_version, 2, type: :int64)
end

defmodule Tensorflow.ExtendSessionRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          session_handle: String.t(),
          graph_def: Tensorflow.GraphDef.t() | nil,
          current_graph_version: integer
        }
  defstruct [:session_handle, :graph_def, :current_graph_version]

  field(:session_handle, 1, type: :string)
  field(:graph_def, 2, type: Tensorflow.GraphDef)
  field(:current_graph_version, 3, type: :int64)
end

defmodule Tensorflow.ExtendSessionResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          new_graph_version: integer
        }
  defstruct [:new_graph_version]

  field(:new_graph_version, 4, type: :int64)
end

defmodule Tensorflow.RunStepRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          session_handle: String.t(),
          feed: [Tensorflow.NamedTensorProto.t()],
          fetch: [String.t()],
          target: [String.t()],
          options: Tensorflow.RunOptions.t() | nil,
          partial_run_handle: String.t(),
          store_errors_in_response_body: boolean,
          request_id: integer
        }
  defstruct [
    :session_handle,
    :feed,
    :fetch,
    :target,
    :options,
    :partial_run_handle,
    :store_errors_in_response_body,
    :request_id
  ]

  field(:session_handle, 1, type: :string)
  field(:feed, 2, repeated: true, type: Tensorflow.NamedTensorProto)
  field(:fetch, 3, repeated: true, type: :string)
  field(:target, 4, repeated: true, type: :string)
  field(:options, 5, type: Tensorflow.RunOptions)
  field(:partial_run_handle, 6, type: :string)
  field(:store_errors_in_response_body, 7, type: :bool)
  field(:request_id, 8, type: :int64)
end

defmodule Tensorflow.RunStepResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          tensor: [Tensorflow.NamedTensorProto.t()],
          metadata: Tensorflow.RunMetadata.t() | nil,
          status_code: Tensorflow.Error.Code.t(),
          status_error_message: String.t()
        }
  defstruct [:tensor, :metadata, :status_code, :status_error_message]

  field(:tensor, 1, repeated: true, type: Tensorflow.NamedTensorProto)
  field(:metadata, 2, type: Tensorflow.RunMetadata)
  field(:status_code, 3, type: Tensorflow.Error.Code, enum: true)
  field(:status_error_message, 4, type: :string)
end

defmodule Tensorflow.PartialRunSetupRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          session_handle: String.t(),
          feed: [String.t()],
          fetch: [String.t()],
          target: [String.t()],
          request_id: integer
        }
  defstruct [:session_handle, :feed, :fetch, :target, :request_id]

  field(:session_handle, 1, type: :string)
  field(:feed, 2, repeated: true, type: :string)
  field(:fetch, 3, repeated: true, type: :string)
  field(:target, 4, repeated: true, type: :string)
  field(:request_id, 5, type: :int64)
end

defmodule Tensorflow.PartialRunSetupResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          partial_run_handle: String.t()
        }
  defstruct [:partial_run_handle]

  field(:partial_run_handle, 1, type: :string)
end

defmodule Tensorflow.CloseSessionRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          session_handle: String.t()
        }
  defstruct [:session_handle]

  field(:session_handle, 1, type: :string)
end

defmodule Tensorflow.CloseSessionResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{}
  defstruct []
end

defmodule Tensorflow.ResetRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          container: [String.t()],
          device_filters: [String.t()]
        }
  defstruct [:container, :device_filters]

  field(:container, 1, repeated: true, type: :string)
  field(:device_filters, 2, repeated: true, type: :string)
end

defmodule Tensorflow.ResetResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{}
  defstruct []
end

defmodule Tensorflow.ListDevicesRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          session_handle: String.t()
        }
  defstruct [:session_handle]

  field(:session_handle, 1, type: :string)
end

defmodule Tensorflow.ListDevicesResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          local_device: [Tensorflow.DeviceAttributes.t()],
          remote_device: [Tensorflow.DeviceAttributes.t()]
        }
  defstruct [:local_device, :remote_device]

  field(:local_device, 1, repeated: true, type: Tensorflow.DeviceAttributes)
  field(:remote_device, 2, repeated: true, type: Tensorflow.DeviceAttributes)
end

defmodule Tensorflow.MakeCallableRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          session_handle: String.t(),
          options: Tensorflow.CallableOptions.t() | nil,
          request_id: integer
        }
  defstruct [:session_handle, :options, :request_id]

  field(:session_handle, 1, type: :string)
  field(:options, 2, type: Tensorflow.CallableOptions)
  field(:request_id, 3, type: :int64)
end

defmodule Tensorflow.MakeCallableResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          handle: integer
        }
  defstruct [:handle]

  field(:handle, 1, type: :int64)
end

defmodule Tensorflow.RunCallableRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          session_handle: String.t(),
          handle: integer,
          feed: [Tensorflow.TensorProto.t()],
          request_id: integer
        }
  defstruct [:session_handle, :handle, :feed, :request_id]

  field(:session_handle, 1, type: :string)
  field(:handle, 2, type: :int64)
  field(:feed, 3, repeated: true, type: Tensorflow.TensorProto)
  field(:request_id, 4, type: :int64)
end

defmodule Tensorflow.RunCallableResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          fetch: [Tensorflow.TensorProto.t()],
          metadata: Tensorflow.RunMetadata.t() | nil
        }
  defstruct [:fetch, :metadata]

  field(:fetch, 1, repeated: true, type: Tensorflow.TensorProto)
  field(:metadata, 2, type: Tensorflow.RunMetadata)
end

defmodule Tensorflow.ReleaseCallableRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          session_handle: String.t(),
          handle: integer
        }
  defstruct [:session_handle, :handle]

  field(:session_handle, 1, type: :string)
  field(:handle, 2, type: :int64)
end

defmodule Tensorflow.ReleaseCallableResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{}
  defstruct []
end

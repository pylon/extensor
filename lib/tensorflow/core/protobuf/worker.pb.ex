defmodule Tensorflow.GetStatusRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Tensorflow.GetStatusResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          device_attributes: [Tensorflow.DeviceAttributes.t()]
        }
  defstruct [:device_attributes]

  field(
    :device_attributes,
    1,
    repeated: true,
    type: Tensorflow.DeviceAttributes
  )
end

defmodule Tensorflow.CreateWorkerSessionRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          session_handle: String.t(),
          server_def: Tensorflow.ServerDef.t(),
          isolate_session_state: boolean
        }
  defstruct [:session_handle, :server_def, :isolate_session_state]

  field(:session_handle, 1, type: :string)
  field(:server_def, 2, type: Tensorflow.ServerDef)
  field(:isolate_session_state, 3, type: :bool)
end

defmodule Tensorflow.CreateWorkerSessionResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Tensorflow.DeleteWorkerSessionRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          session_handle: String.t()
        }
  defstruct [:session_handle]

  field(:session_handle, 1, type: :string)
end

defmodule Tensorflow.DeleteWorkerSessionResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Tensorflow.RegisterGraphRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          session_handle: String.t(),
          create_worker_session_called: boolean,
          graph_def: Tensorflow.GraphDef.t(),
          has_control_flow: boolean,
          graph_options: Tensorflow.GraphOptions.t(),
          debug_options: Tensorflow.DebugOptions.t(),
          collective_graph_key: integer
        }
  defstruct [
    :session_handle,
    :create_worker_session_called,
    :graph_def,
    :has_control_flow,
    :graph_options,
    :debug_options,
    :collective_graph_key
  ]

  field(:session_handle, 1, type: :string)
  field(:create_worker_session_called, 6, type: :bool)
  field(:graph_def, 2, type: Tensorflow.GraphDef)
  field(:has_control_flow, 3, type: :bool, deprecated: true)
  field(:graph_options, 4, type: Tensorflow.GraphOptions)
  field(:debug_options, 5, type: Tensorflow.DebugOptions)
  field(:collective_graph_key, 7, type: :int64)
end

defmodule Tensorflow.RegisterGraphResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          graph_handle: String.t()
        }
  defstruct [:graph_handle]

  field(:graph_handle, 1, type: :string)
end

defmodule Tensorflow.DeregisterGraphRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          session_handle: String.t(),
          create_worker_session_called: boolean,
          graph_handle: String.t()
        }
  defstruct [:session_handle, :create_worker_session_called, :graph_handle]

  field(:session_handle, 2, type: :string)
  field(:create_worker_session_called, 3, type: :bool)
  field(:graph_handle, 1, type: :string)
end

defmodule Tensorflow.DeregisterGraphResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Tensorflow.CleanupAllRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          container: [String.t()]
        }
  defstruct [:container]

  field(:container, 1, repeated: true, type: :string)
end

defmodule Tensorflow.CleanupAllResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Tensorflow.ExecutorOpts do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          record_costs: boolean,
          record_timeline: boolean,
          record_partition_graphs: boolean,
          report_tensor_allocations_upon_oom: boolean
        }
  defstruct [
    :record_costs,
    :record_timeline,
    :record_partition_graphs,
    :report_tensor_allocations_upon_oom
  ]

  field(:record_costs, 1, type: :bool)
  field(:record_timeline, 3, type: :bool)
  field(:record_partition_graphs, 4, type: :bool)
  field(:report_tensor_allocations_upon_oom, 5, type: :bool)
end

defmodule Tensorflow.RunGraphRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          session_handle: String.t(),
          create_worker_session_called: boolean,
          graph_handle: String.t(),
          step_id: integer,
          exec_opts: Tensorflow.ExecutorOpts.t(),
          send: [Tensorflow.NamedTensorProto.t()],
          recv_key: [String.t()],
          is_partial: boolean,
          is_last_partial_run: boolean,
          store_errors_in_response_body: boolean
        }
  defstruct [
    :session_handle,
    :create_worker_session_called,
    :graph_handle,
    :step_id,
    :exec_opts,
    :send,
    :recv_key,
    :is_partial,
    :is_last_partial_run,
    :store_errors_in_response_body
  ]

  field(:session_handle, 8, type: :string)
  field(:create_worker_session_called, 10, type: :bool)
  field(:graph_handle, 1, type: :string)
  field(:step_id, 2, type: :int64)
  field(:exec_opts, 5, type: Tensorflow.ExecutorOpts)
  field(:send, 3, repeated: true, type: Tensorflow.NamedTensorProto)
  field(:recv_key, 4, repeated: true, type: :string)
  field(:is_partial, 6, type: :bool)
  field(:is_last_partial_run, 7, type: :bool)
  field(:store_errors_in_response_body, 9, type: :bool)
end

defmodule Tensorflow.RunGraphResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          recv: [Tensorflow.NamedTensorProto.t()],
          step_stats: Tensorflow.StepStats.t(),
          cost_graph: Tensorflow.CostGraphDef.t(),
          partition_graph: [Tensorflow.GraphDef.t()],
          status_code: integer,
          status_error_message: String.t()
        }
  defstruct [
    :recv,
    :step_stats,
    :cost_graph,
    :partition_graph,
    :status_code,
    :status_error_message
  ]

  field(:recv, 1, repeated: true, type: Tensorflow.NamedTensorProto)
  field(:step_stats, 2, type: Tensorflow.StepStats)
  field(:cost_graph, 3, type: Tensorflow.CostGraphDef)
  field(:partition_graph, 4, repeated: true, type: Tensorflow.GraphDef)
  field(:status_code, 5, type: Tensorflow.Error.Code, enum: true)
  field(:status_error_message, 6, type: :string)
end

defmodule Tensorflow.CleanupGraphRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          step_id: integer
        }
  defstruct [:step_id]

  field(:step_id, 1, type: :int64)
end

defmodule Tensorflow.CleanupGraphResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Tensorflow.RecvTensorRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          step_id: integer,
          rendezvous_key: String.t(),
          dma_ok: boolean,
          client_locality: Tensorflow.DeviceLocality.t(),
          server_locality: Tensorflow.DeviceLocality.t(),
          transport_options: Google.Protobuf.Any.t(),
          request_id: integer
        }
  defstruct [
    :step_id,
    :rendezvous_key,
    :dma_ok,
    :client_locality,
    :server_locality,
    :transport_options,
    :request_id
  ]

  field(:step_id, 1, type: :int64)
  field(:rendezvous_key, 2, type: :string)
  field(:dma_ok, 3, type: :bool)
  field(:client_locality, 4, type: Tensorflow.DeviceLocality)
  field(:server_locality, 5, type: Tensorflow.DeviceLocality)
  field(:transport_options, 6, type: Google.Protobuf.Any)
  field(:request_id, 7, type: :int64)
end

defmodule Tensorflow.RecvTensorResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          tensor: Tensorflow.TensorProto.t(),
          is_dead: boolean,
          send_start_micros: integer,
          transport_options: Google.Protobuf.Any.t()
        }
  defstruct [:tensor, :is_dead, :send_start_micros, :transport_options]

  field(:tensor, 1, type: Tensorflow.TensorProto)
  field(:is_dead, 2, type: :bool)
  field(:send_start_micros, 3, type: :int64)
  field(:transport_options, 4, type: Google.Protobuf.Any)
end

defmodule Tensorflow.LoggingRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          enable_rpc_logging: boolean,
          disable_rpc_logging: boolean,
          clear: boolean,
          fetch_step_id: [integer]
        }
  defstruct [
    :enable_rpc_logging,
    :disable_rpc_logging,
    :clear,
    :fetch_step_id
  ]

  field(:enable_rpc_logging, 1, type: :bool)
  field(:disable_rpc_logging, 4, type: :bool)
  field(:clear, 2, type: :bool)
  field(:fetch_step_id, 3, repeated: true, type: :int64)
end

defmodule Tensorflow.LabeledStepStats do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          step_id: integer,
          step_stats: Tensorflow.StepStats.t()
        }
  defstruct [:step_id, :step_stats]

  field(:step_id, 1, type: :int64)
  field(:step_stats, 2, type: Tensorflow.StepStats)
end

defmodule Tensorflow.LoggingResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          step: [Tensorflow.LabeledStepStats.t()]
        }
  defstruct [:step]

  field(:step, 1, repeated: true, type: Tensorflow.LabeledStepStats)
end

defmodule Tensorflow.TraceOpts do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          duration: float,
          use_step_profiler: boolean,
          use_kernel_profiler: boolean,
          use_extended_profiler: boolean,
          use_gpu_profiler: boolean,
          use_sample_profiler: boolean
        }
  defstruct [
    :duration,
    :use_step_profiler,
    :use_kernel_profiler,
    :use_extended_profiler,
    :use_gpu_profiler,
    :use_sample_profiler
  ]

  field(:duration, 1, type: :double)
  field(:use_step_profiler, 2, type: :bool)
  field(:use_kernel_profiler, 3, type: :bool)
  field(:use_extended_profiler, 4, type: :bool)
  field(:use_gpu_profiler, 5, type: :bool)
  field(:use_sample_profiler, 6, type: :bool)
end

defmodule Tensorflow.TracingRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          options: Tensorflow.TraceOpts.t()
        }
  defstruct [:options]

  field(:options, 1, type: Tensorflow.TraceOpts)
end

defmodule Tensorflow.TracingResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Tensorflow.RecvBufRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          step_id: integer,
          buf_rendezvous_key: String.t(),
          num_bytes: integer,
          buf_ptr: non_neg_integer,
          client_locality: Tensorflow.DeviceLocality.t(),
          server_locality: Tensorflow.DeviceLocality.t(),
          transport_options: Google.Protobuf.Any.t(),
          src_device: String.t(),
          dst_device: String.t()
        }
  defstruct [
    :step_id,
    :buf_rendezvous_key,
    :num_bytes,
    :buf_ptr,
    :client_locality,
    :server_locality,
    :transport_options,
    :src_device,
    :dst_device
  ]

  field(:step_id, 1, type: :int64)
  field(:buf_rendezvous_key, 2, type: :string)
  field(:num_bytes, 3, type: :int64)
  field(:buf_ptr, 4, type: :fixed64)
  field(:client_locality, 5, type: Tensorflow.DeviceLocality)
  field(:server_locality, 6, type: Tensorflow.DeviceLocality)
  field(:transport_options, 7, type: Google.Protobuf.Any)
  field(:src_device, 8, type: :string)
  field(:dst_device, 9, type: :string)
end

defmodule Tensorflow.RecvBufResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          buf_ptr: non_neg_integer,
          num_bytes: integer,
          is_dead: boolean,
          transport_options: Google.Protobuf.Any.t(),
          send_start_micros: integer
        }
  defstruct [
    :buf_ptr,
    :num_bytes,
    :is_dead,
    :transport_options,
    :send_start_micros
  ]

  field(:buf_ptr, 1, type: :fixed64)
  field(:num_bytes, 2, type: :int64)
  field(:is_dead, 3, type: :bool)
  field(:transport_options, 4, type: Google.Protobuf.Any)
  field(:send_start_micros, 5, type: :int64)
end

defmodule Tensorflow.CompleteGroupRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          group_key: integer,
          group_size: integer,
          device_type: String.t(),
          device_name: [String.t()]
        }
  defstruct [:group_key, :group_size, :device_type, :device_name]

  field(:group_key, 1, type: :int32)
  field(:group_size, 2, type: :int32)
  field(:device_type, 3, type: :string)
  field(:device_name, 4, repeated: true, type: :string)
end

defmodule Tensorflow.CompleteGroupResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          group_key: integer,
          group_size: integer,
          device_type: String.t(),
          num_tasks: integer,
          device_name: [String.t()],
          task_name: [String.t()]
        }
  defstruct [
    :group_key,
    :group_size,
    :device_type,
    :num_tasks,
    :device_name,
    :task_name
  ]

  field(:group_key, 1, type: :int32)
  field(:group_size, 2, type: :int32)
  field(:device_type, 3, type: :string)
  field(:num_tasks, 4, type: :int32)
  field(:device_name, 5, repeated: true, type: :string)
  field(:task_name, 6, repeated: true, type: :string)
end

defmodule Tensorflow.CompleteInstanceRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          type: integer,
          data_type: integer,
          shape: Tensorflow.TensorShapeProto.t(),
          group_key: integer,
          group_size: integer,
          instance_key: integer,
          device_type: String.t(),
          subdiv_offset: [integer],
          device: String.t(),
          is_source: boolean
        }
  defstruct [
    :name,
    :type,
    :data_type,
    :shape,
    :group_key,
    :group_size,
    :instance_key,
    :device_type,
    :subdiv_offset,
    :device,
    :is_source
  ]

  field(:name, 1, type: :string)
  field(:type, 2, type: :int32)
  field(:data_type, 3, type: Tensorflow.DataType, enum: true)
  field(:shape, 4, type: Tensorflow.TensorShapeProto)
  field(:group_key, 5, type: :int32)
  field(:group_size, 6, type: :int32)
  field(:instance_key, 7, type: :int32)
  field(:device_type, 8, type: :string)
  field(:subdiv_offset, 9, repeated: true, type: :int32)
  field(:device, 10, type: :string)
  field(:is_source, 11, type: :bool)
end

defmodule Tensorflow.CompleteInstanceResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          instance_key: integer,
          source_rank: integer
        }
  defstruct [:instance_key, :source_rank]

  field(:instance_key, 1, type: :int32)
  field(:source_rank, 2, type: :int32)
end

defmodule Tensorflow.GetStepSequenceRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          graph_key: [integer]
        }
  defstruct [:graph_key]

  field(:graph_key, 1, repeated: true, type: :int64)
end

defmodule Tensorflow.StepSequence do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          graph_key: integer,
          next_step_id: integer
        }
  defstruct [:graph_key, :next_step_id]

  field(:graph_key, 1, type: :int64)
  field(:next_step_id, 2, type: :int64)
end

defmodule Tensorflow.GetStepSequenceResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          step_sequence: [Tensorflow.StepSequence.t()]
        }
  defstruct [:step_sequence]

  field(:step_sequence, 1, repeated: true, type: Tensorflow.StepSequence)
end

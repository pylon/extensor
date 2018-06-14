defmodule Tensorflow.GPUOptions do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          per_process_gpu_memory_fraction: float,
          allow_growth: boolean,
          allocator_type: String.t(),
          deferred_deletion_bytes: integer,
          visible_device_list: String.t(),
          polling_active_delay_usecs: integer,
          polling_inactive_delay_msecs: integer,
          force_gpu_compatible: boolean,
          experimental: Tensorflow.GPUOptions.Experimental.t()
        }
  defstruct [
    :per_process_gpu_memory_fraction,
    :allow_growth,
    :allocator_type,
    :deferred_deletion_bytes,
    :visible_device_list,
    :polling_active_delay_usecs,
    :polling_inactive_delay_msecs,
    :force_gpu_compatible,
    :experimental
  ]

  field(:per_process_gpu_memory_fraction, 1, type: :double)
  field(:allow_growth, 4, type: :bool)
  field(:allocator_type, 2, type: :string)
  field(:deferred_deletion_bytes, 3, type: :int64)
  field(:visible_device_list, 5, type: :string)
  field(:polling_active_delay_usecs, 6, type: :int32)
  field(:polling_inactive_delay_msecs, 7, type: :int32)
  field(:force_gpu_compatible, 8, type: :bool)
  field(:experimental, 9, type: Tensorflow.GPUOptions.Experimental)
end

defmodule Tensorflow.GPUOptions.Experimental do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          virtual_devices: [
            Tensorflow.GPUOptions.Experimental.VirtualDevices.t()
          ],
          use_unified_memory: boolean
        }
  defstruct [:virtual_devices, :use_unified_memory]

  field(
    :virtual_devices,
    1,
    repeated: true,
    type: Tensorflow.GPUOptions.Experimental.VirtualDevices
  )

  field(:use_unified_memory, 2, type: :bool)
end

defmodule Tensorflow.GPUOptions.Experimental.VirtualDevices do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          memory_limit_mb: [float]
        }
  defstruct [:memory_limit_mb]

  field(:memory_limit_mb, 1, repeated: true, type: :float)
end

defmodule Tensorflow.OptimizerOptions do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          do_common_subexpression_elimination: boolean,
          do_constant_folding: boolean,
          max_folded_constant_in_bytes: integer,
          do_function_inlining: boolean,
          opt_level: integer,
          global_jit_level: integer
        }
  defstruct [
    :do_common_subexpression_elimination,
    :do_constant_folding,
    :max_folded_constant_in_bytes,
    :do_function_inlining,
    :opt_level,
    :global_jit_level
  ]

  field(:do_common_subexpression_elimination, 1, type: :bool)
  field(:do_constant_folding, 2, type: :bool)
  field(:max_folded_constant_in_bytes, 6, type: :int64)
  field(:do_function_inlining, 4, type: :bool)
  field(:opt_level, 3, type: Tensorflow.OptimizerOptions.Level, enum: true)

  field(
    :global_jit_level,
    5,
    type: Tensorflow.OptimizerOptions.GlobalJitLevel,
    enum: true
  )
end

defmodule Tensorflow.OptimizerOptions.Level do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  field(:L1, 0)
  field(:L0, -1)
end

defmodule Tensorflow.OptimizerOptions.GlobalJitLevel do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  field(:DEFAULT, 0)
  field(:OFF, -1)
  field(:ON_1, 1)
  field(:ON_2, 2)
end

defmodule Tensorflow.GraphOptions do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          enable_recv_scheduling: boolean,
          optimizer_options: Tensorflow.OptimizerOptions.t(),
          build_cost_model: integer,
          build_cost_model_after: integer,
          infer_shapes: boolean,
          place_pruned_graph: boolean,
          enable_bfloat16_sendrecv: boolean,
          timeline_step: integer,
          rewrite_options: Tensorflow.RewriterConfig.t()
        }
  defstruct [
    :enable_recv_scheduling,
    :optimizer_options,
    :build_cost_model,
    :build_cost_model_after,
    :infer_shapes,
    :place_pruned_graph,
    :enable_bfloat16_sendrecv,
    :timeline_step,
    :rewrite_options
  ]

  field(:enable_recv_scheduling, 2, type: :bool)
  field(:optimizer_options, 3, type: Tensorflow.OptimizerOptions)
  field(:build_cost_model, 4, type: :int64)
  field(:build_cost_model_after, 9, type: :int64)
  field(:infer_shapes, 5, type: :bool)
  field(:place_pruned_graph, 6, type: :bool)
  field(:enable_bfloat16_sendrecv, 7, type: :bool)
  field(:timeline_step, 8, type: :int32)
  field(:rewrite_options, 10, type: Tensorflow.RewriterConfig)
end

defmodule Tensorflow.ThreadPoolOptionProto do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          num_threads: integer,
          global_name: String.t()
        }
  defstruct [:num_threads, :global_name]

  field(:num_threads, 1, type: :int32)
  field(:global_name, 2, type: :string)
end

defmodule Tensorflow.RPCOptions do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          use_rpc_for_inprocess_master: boolean
        }
  defstruct [:use_rpc_for_inprocess_master]

  field(:use_rpc_for_inprocess_master, 1, type: :bool)
end

defmodule Tensorflow.ConfigProto do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          device_count: %{String.t() => integer},
          intra_op_parallelism_threads: integer,
          inter_op_parallelism_threads: integer,
          use_per_session_threads: boolean,
          session_inter_op_thread_pool: [Tensorflow.ThreadPoolOptionProto.t()],
          placement_period: integer,
          device_filters: [String.t()],
          gpu_options: Tensorflow.GPUOptions.t(),
          allow_soft_placement: boolean,
          log_device_placement: boolean,
          graph_options: Tensorflow.GraphOptions.t(),
          operation_timeout_in_ms: integer,
          rpc_options: Tensorflow.RPCOptions.t(),
          cluster_def: Tensorflow.ClusterDef.t(),
          isolate_session_state: boolean,
          experimental: Tensorflow.ConfigProto.Experimental.t()
        }
  defstruct [
    :device_count,
    :intra_op_parallelism_threads,
    :inter_op_parallelism_threads,
    :use_per_session_threads,
    :session_inter_op_thread_pool,
    :placement_period,
    :device_filters,
    :gpu_options,
    :allow_soft_placement,
    :log_device_placement,
    :graph_options,
    :operation_timeout_in_ms,
    :rpc_options,
    :cluster_def,
    :isolate_session_state,
    :experimental
  ]

  field(
    :device_count,
    1,
    repeated: true,
    type: Tensorflow.ConfigProto.DeviceCountEntry,
    map: true
  )

  field(:intra_op_parallelism_threads, 2, type: :int32)
  field(:inter_op_parallelism_threads, 5, type: :int32)
  field(:use_per_session_threads, 9, type: :bool)

  field(
    :session_inter_op_thread_pool,
    12,
    repeated: true,
    type: Tensorflow.ThreadPoolOptionProto
  )

  field(:placement_period, 3, type: :int32)
  field(:device_filters, 4, repeated: true, type: :string)
  field(:gpu_options, 6, type: Tensorflow.GPUOptions)
  field(:allow_soft_placement, 7, type: :bool)
  field(:log_device_placement, 8, type: :bool)
  field(:graph_options, 10, type: Tensorflow.GraphOptions)
  field(:operation_timeout_in_ms, 11, type: :int64)
  field(:rpc_options, 13, type: Tensorflow.RPCOptions)
  field(:cluster_def, 14, type: Tensorflow.ClusterDef)
  field(:isolate_session_state, 15, type: :bool)
  field(:experimental, 16, type: Tensorflow.ConfigProto.Experimental)
end

defmodule Tensorflow.ConfigProto.DeviceCountEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: integer
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: :int32)
end

defmodule Tensorflow.ConfigProto.Experimental do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          collective_group_leader: String.t()
        }
  defstruct [:collective_group_leader]

  field(:collective_group_leader, 1, type: :string)
end

defmodule Tensorflow.RunOptions do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          trace_level: integer,
          timeout_in_ms: integer,
          inter_op_thread_pool: integer,
          output_partition_graphs: boolean,
          debug_options: Tensorflow.DebugOptions.t(),
          report_tensor_allocations_upon_oom: boolean,
          experimental: Tensorflow.RunOptions.Experimental.t()
        }
  defstruct [
    :trace_level,
    :timeout_in_ms,
    :inter_op_thread_pool,
    :output_partition_graphs,
    :debug_options,
    :report_tensor_allocations_upon_oom,
    :experimental
  ]

  field(:trace_level, 1, type: Tensorflow.RunOptions.TraceLevel, enum: true)
  field(:timeout_in_ms, 2, type: :int64)
  field(:inter_op_thread_pool, 3, type: :int32)
  field(:output_partition_graphs, 5, type: :bool)
  field(:debug_options, 6, type: Tensorflow.DebugOptions)
  field(:report_tensor_allocations_upon_oom, 7, type: :bool)
  field(:experimental, 8, type: Tensorflow.RunOptions.Experimental)
end

defmodule Tensorflow.RunOptions.Experimental do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          collective_graph_key: integer
        }
  defstruct [:collective_graph_key]

  field(:collective_graph_key, 1, type: :int64)
end

defmodule Tensorflow.RunOptions.TraceLevel do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  field(:NO_TRACE, 0)
  field(:SOFTWARE_TRACE, 1)
  field(:HARDWARE_TRACE, 2)
  field(:FULL_TRACE, 3)
end

defmodule Tensorflow.RunMetadata do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          step_stats: Tensorflow.StepStats.t(),
          cost_graph: Tensorflow.CostGraphDef.t(),
          partition_graphs: [Tensorflow.GraphDef.t()]
        }
  defstruct [:step_stats, :cost_graph, :partition_graphs]

  field(:step_stats, 1, type: Tensorflow.StepStats)
  field(:cost_graph, 2, type: Tensorflow.CostGraphDef)
  field(:partition_graphs, 3, repeated: true, type: Tensorflow.GraphDef)
end

defmodule Tensorflow.TensorConnection do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          from_tensor: String.t(),
          to_tensor: String.t()
        }
  defstruct [:from_tensor, :to_tensor]

  field(:from_tensor, 1, type: :string)
  field(:to_tensor, 2, type: :string)
end

defmodule Tensorflow.CallableOptions do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          feed: [String.t()],
          fetch: [String.t()],
          target: [String.t()],
          run_options: Tensorflow.RunOptions.t(),
          tensor_connection: [Tensorflow.TensorConnection.t()]
        }
  defstruct [:feed, :fetch, :target, :run_options, :tensor_connection]

  field(:feed, 1, repeated: true, type: :string)
  field(:fetch, 2, repeated: true, type: :string)
  field(:target, 3, repeated: true, type: :string)
  field(:run_options, 4, type: Tensorflow.RunOptions)

  field(
    :tensor_connection,
    5,
    repeated: true,
    type: Tensorflow.TensorConnection
  )
end

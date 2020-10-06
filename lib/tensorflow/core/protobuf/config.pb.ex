defmodule Tensorflow.OptimizerOptions.Level do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  @type t :: integer | :L1 | :L0

  field(:L1, 0)
  field(:L0, -1)
end

defmodule Tensorflow.OptimizerOptions.GlobalJitLevel do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  @type t :: integer | :DEFAULT | :OFF | :ON_1 | :ON_2

  field(:DEFAULT, 0)
  field(:OFF, -1)
  field(:ON_1, 1)
  field(:ON_2, 2)
end

defmodule Tensorflow.ConfigProto.Experimental.MlirBridgeRollout do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  @type t ::
          integer
          | :MLIR_BRIDGE_ROLLOUT_UNSPECIFIED
          | :MLIR_BRIDGE_ROLLOUT_ENABLED
          | :MLIR_BRIDGE_ROLLOUT_DISABLED

  field(:MLIR_BRIDGE_ROLLOUT_UNSPECIFIED, 0)
  field(:MLIR_BRIDGE_ROLLOUT_ENABLED, 1)
  field(:MLIR_BRIDGE_ROLLOUT_DISABLED, 2)
end

defmodule Tensorflow.RunOptions.TraceLevel do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  @type t ::
          integer
          | :NO_TRACE
          | :SOFTWARE_TRACE
          | :HARDWARE_TRACE
          | :FULL_TRACE

  field(:NO_TRACE, 0)
  field(:SOFTWARE_TRACE, 1)
  field(:HARDWARE_TRACE, 2)
  field(:FULL_TRACE, 3)
end

defmodule Tensorflow.GPUOptions.Experimental.VirtualDevices do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          memory_limit_mb: [float | :infinity | :negative_infinity | :nan],
          priority: [integer]
        }
  defstruct [:memory_limit_mb, :priority]

  field(:memory_limit_mb, 1, repeated: true, type: :float)
  field(:priority, 2, repeated: true, type: :int32)
end

defmodule Tensorflow.GPUOptions.Experimental do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          virtual_devices: [
            Tensorflow.GPUOptions.Experimental.VirtualDevices.t()
          ],
          use_unified_memory: boolean,
          num_dev_to_dev_copy_streams: integer,
          collective_ring_order: String.t(),
          timestamped_allocator: boolean,
          kernel_tracker_max_interval: integer,
          kernel_tracker_max_bytes: integer,
          kernel_tracker_max_pending: integer
        }
  defstruct [
    :virtual_devices,
    :use_unified_memory,
    :num_dev_to_dev_copy_streams,
    :collective_ring_order,
    :timestamped_allocator,
    :kernel_tracker_max_interval,
    :kernel_tracker_max_bytes,
    :kernel_tracker_max_pending
  ]

  field(:virtual_devices, 1,
    repeated: true,
    type: Tensorflow.GPUOptions.Experimental.VirtualDevices
  )

  field(:use_unified_memory, 2, type: :bool)
  field(:num_dev_to_dev_copy_streams, 3, type: :int32)
  field(:collective_ring_order, 4, type: :string)
  field(:timestamped_allocator, 5, type: :bool)
  field(:kernel_tracker_max_interval, 7, type: :int32)
  field(:kernel_tracker_max_bytes, 8, type: :int32)
  field(:kernel_tracker_max_pending, 9, type: :int32)
end

defmodule Tensorflow.GPUOptions do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          per_process_gpu_memory_fraction:
            float | :infinity | :negative_infinity | :nan,
          allow_growth: boolean,
          allocator_type: String.t(),
          deferred_deletion_bytes: integer,
          visible_device_list: String.t(),
          polling_active_delay_usecs: integer,
          polling_inactive_delay_msecs: integer,
          force_gpu_compatible: boolean,
          experimental: Tensorflow.GPUOptions.Experimental.t() | nil
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

defmodule Tensorflow.OptimizerOptions do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          do_common_subexpression_elimination: boolean,
          do_constant_folding: boolean,
          max_folded_constant_in_bytes: integer,
          do_function_inlining: boolean,
          opt_level: Tensorflow.OptimizerOptions.Level.t(),
          global_jit_level: Tensorflow.OptimizerOptions.GlobalJitLevel.t()
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

  field(:global_jit_level, 5,
    type: Tensorflow.OptimizerOptions.GlobalJitLevel,
    enum: true
  )
end

defmodule Tensorflow.GraphOptions do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          enable_recv_scheduling: boolean,
          optimizer_options: Tensorflow.OptimizerOptions.t() | nil,
          build_cost_model: integer,
          build_cost_model_after: integer,
          infer_shapes: boolean,
          place_pruned_graph: boolean,
          enable_bfloat16_sendrecv: boolean,
          timeline_step: integer,
          rewrite_options: Tensorflow.RewriterConfig.t() | nil
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
          use_rpc_for_inprocess_master: boolean,
          compression_algorithm: String.t(),
          compression_level: integer,
          cache_rpc_response: boolean,
          disable_session_connection_sharing: boolean
        }
  defstruct [
    :use_rpc_for_inprocess_master,
    :compression_algorithm,
    :compression_level,
    :cache_rpc_response,
    :disable_session_connection_sharing
  ]

  field(:use_rpc_for_inprocess_master, 1, type: :bool)
  field(:compression_algorithm, 2, type: :string)
  field(:compression_level, 3, type: :int32)
  field(:cache_rpc_response, 4, type: :bool)
  field(:disable_session_connection_sharing, 5, type: :bool)
end

defmodule Tensorflow.SessionMetadata do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          version: integer
        }
  defstruct [:name, :version]

  field(:name, 1, type: :string)
  field(:version, 2, type: :int64)
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
          collective_group_leader: String.t(),
          executor_type: String.t(),
          recv_buf_max_chunk: integer,
          use_numa_affinity: boolean,
          collective_deterministic_sequential_execution: boolean,
          collective_nccl: boolean,
          share_session_state_in_clusterspec_propagation: boolean,
          disable_thread_spinning: boolean,
          share_cluster_devices_in_session: boolean,
          session_metadata: Tensorflow.SessionMetadata.t() | nil,
          optimize_for_static_graph: boolean,
          enable_mlir_bridge: boolean,
          mlir_bridge_rollout:
            Tensorflow.ConfigProto.Experimental.MlirBridgeRollout.t(),
          enable_mlir_graph_optimization: boolean,
          disable_output_partition_graphs: boolean,
          xla_fusion_autotuner_thresh: integer
        }
  defstruct [
    :collective_group_leader,
    :executor_type,
    :recv_buf_max_chunk,
    :use_numa_affinity,
    :collective_deterministic_sequential_execution,
    :collective_nccl,
    :share_session_state_in_clusterspec_propagation,
    :disable_thread_spinning,
    :share_cluster_devices_in_session,
    :session_metadata,
    :optimize_for_static_graph,
    :enable_mlir_bridge,
    :mlir_bridge_rollout,
    :enable_mlir_graph_optimization,
    :disable_output_partition_graphs,
    :xla_fusion_autotuner_thresh
  ]

  field(:collective_group_leader, 1, type: :string)
  field(:executor_type, 3, type: :string)
  field(:recv_buf_max_chunk, 4, type: :int32)
  field(:use_numa_affinity, 5, type: :bool)
  field(:collective_deterministic_sequential_execution, 6, type: :bool)
  field(:collective_nccl, 7, type: :bool)
  field(:share_session_state_in_clusterspec_propagation, 8, type: :bool)
  field(:disable_thread_spinning, 9, type: :bool)
  field(:share_cluster_devices_in_session, 10, type: :bool)
  field(:session_metadata, 11, type: Tensorflow.SessionMetadata)
  field(:optimize_for_static_graph, 12, type: :bool)
  field(:enable_mlir_bridge, 13, type: :bool)

  field(:mlir_bridge_rollout, 17,
    type: Tensorflow.ConfigProto.Experimental.MlirBridgeRollout,
    enum: true
  )

  field(:enable_mlir_graph_optimization, 16, type: :bool)
  field(:disable_output_partition_graphs, 14, type: :bool)
  field(:xla_fusion_autotuner_thresh, 15, type: :int64)
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
          gpu_options: Tensorflow.GPUOptions.t() | nil,
          allow_soft_placement: boolean,
          log_device_placement: boolean,
          graph_options: Tensorflow.GraphOptions.t() | nil,
          operation_timeout_in_ms: integer,
          rpc_options: Tensorflow.RPCOptions.t() | nil,
          cluster_def: Tensorflow.ClusterDef.t() | nil,
          isolate_session_state: boolean,
          share_cluster_devices_in_session: boolean,
          experimental: Tensorflow.ConfigProto.Experimental.t() | nil
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
    :share_cluster_devices_in_session,
    :experimental
  ]

  field(:device_count, 1,
    repeated: true,
    type: Tensorflow.ConfigProto.DeviceCountEntry,
    map: true
  )

  field(:intra_op_parallelism_threads, 2, type: :int32)
  field(:inter_op_parallelism_threads, 5, type: :int32)
  field(:use_per_session_threads, 9, type: :bool)

  field(:session_inter_op_thread_pool, 12,
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
  field(:share_cluster_devices_in_session, 17, type: :bool)
  field(:experimental, 16, type: Tensorflow.ConfigProto.Experimental)
end

defmodule Tensorflow.RunOptions.Experimental.RunHandlerPoolOptions do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          priority: integer
        }
  defstruct [:priority]

  field(:priority, 1, type: :int64)
end

defmodule Tensorflow.RunOptions.Experimental do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          collective_graph_key: integer,
          use_run_handler_pool: boolean,
          run_handler_pool_options:
            Tensorflow.RunOptions.Experimental.RunHandlerPoolOptions.t() | nil
        }
  defstruct [
    :collective_graph_key,
    :use_run_handler_pool,
    :run_handler_pool_options
  ]

  field(:collective_graph_key, 1, type: :int64)
  field(:use_run_handler_pool, 2, type: :bool)

  field(:run_handler_pool_options, 3,
    type: Tensorflow.RunOptions.Experimental.RunHandlerPoolOptions
  )
end

defmodule Tensorflow.RunOptions do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          trace_level: Tensorflow.RunOptions.TraceLevel.t(),
          timeout_in_ms: integer,
          inter_op_thread_pool: integer,
          output_partition_graphs: boolean,
          debug_options: Tensorflow.DebugOptions.t() | nil,
          report_tensor_allocations_upon_oom: boolean,
          experimental: Tensorflow.RunOptions.Experimental.t() | nil
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

defmodule Tensorflow.RunMetadata.FunctionGraphs do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          partition_graphs: [Tensorflow.GraphDef.t()],
          pre_optimization_graph: Tensorflow.GraphDef.t() | nil,
          post_optimization_graph: Tensorflow.GraphDef.t() | nil
        }
  defstruct [
    :partition_graphs,
    :pre_optimization_graph,
    :post_optimization_graph
  ]

  field(:partition_graphs, 1, repeated: true, type: Tensorflow.GraphDef)
  field(:pre_optimization_graph, 2, type: Tensorflow.GraphDef)
  field(:post_optimization_graph, 3, type: Tensorflow.GraphDef)
end

defmodule Tensorflow.RunMetadata do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          step_stats: Tensorflow.StepStats.t() | nil,
          cost_graph: Tensorflow.CostGraphDef.t() | nil,
          partition_graphs: [Tensorflow.GraphDef.t()],
          function_graphs: [Tensorflow.RunMetadata.FunctionGraphs.t()]
        }
  defstruct [:step_stats, :cost_graph, :partition_graphs, :function_graphs]

  field(:step_stats, 1, type: Tensorflow.StepStats)
  field(:cost_graph, 2, type: Tensorflow.CostGraphDef)
  field(:partition_graphs, 3, repeated: true, type: Tensorflow.GraphDef)

  field(:function_graphs, 4,
    repeated: true,
    type: Tensorflow.RunMetadata.FunctionGraphs
  )
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

defmodule Tensorflow.CallableOptions.FeedDevicesEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: String.t()
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: :string)
end

defmodule Tensorflow.CallableOptions.FetchDevicesEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: String.t()
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: :string)
end

defmodule Tensorflow.CallableOptions do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          feed: [String.t()],
          fetch: [String.t()],
          target: [String.t()],
          run_options: Tensorflow.RunOptions.t() | nil,
          tensor_connection: [Tensorflow.TensorConnection.t()],
          feed_devices: %{String.t() => String.t()},
          fetch_devices: %{String.t() => String.t()},
          fetch_skip_sync: boolean
        }
  defstruct [
    :feed,
    :fetch,
    :target,
    :run_options,
    :tensor_connection,
    :feed_devices,
    :fetch_devices,
    :fetch_skip_sync
  ]

  field(:feed, 1, repeated: true, type: :string)
  field(:fetch, 2, repeated: true, type: :string)
  field(:target, 3, repeated: true, type: :string)
  field(:run_options, 4, type: Tensorflow.RunOptions)

  field(:tensor_connection, 5,
    repeated: true,
    type: Tensorflow.TensorConnection
  )

  field(:feed_devices, 6,
    repeated: true,
    type: Tensorflow.CallableOptions.FeedDevicesEntry,
    map: true
  )

  field(:fetch_devices, 7,
    repeated: true,
    type: Tensorflow.CallableOptions.FetchDevicesEntry,
    map: true
  )

  field(:fetch_skip_sync, 8, type: :bool)
end

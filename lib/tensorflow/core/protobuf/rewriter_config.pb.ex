defmodule Tensorflow.RewriterConfig.Toggle do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  @type t :: integer | :DEFAULT | :ON | :OFF | :AGGRESSIVE

  field(:DEFAULT, 0)
  field(:ON, 1)
  field(:OFF, 2)
  field(:AGGRESSIVE, 3)
end

defmodule Tensorflow.RewriterConfig.NumIterationsType do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  @type t :: integer | :DEFAULT_NUM_ITERS | :ONE | :TWO

  field(:DEFAULT_NUM_ITERS, 0)
  field(:ONE, 1)
  field(:TWO, 2)
end

defmodule Tensorflow.RewriterConfig.MemOptType do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  @type t ::
          integer
          | :DEFAULT_MEM_OPT
          | :NO_MEM_OPT
          | :MANUAL
          | :SWAPPING_HEURISTICS
          | :RECOMPUTATION_HEURISTICS
          | :SCHEDULING_HEURISTICS
          | :HEURISTICS

  field(:DEFAULT_MEM_OPT, 0)
  field(:NO_MEM_OPT, 1)
  field(:MANUAL, 2)
  field(:SWAPPING_HEURISTICS, 4)
  field(:RECOMPUTATION_HEURISTICS, 5)
  field(:SCHEDULING_HEURISTICS, 6)
  field(:HEURISTICS, 3)
end

defmodule Tensorflow.AutoParallelOptions do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          enable: boolean,
          num_replicas: integer
        }
  defstruct [:enable, :num_replicas]

  field(:enable, 1, type: :bool)
  field(:num_replicas, 2, type: :int32)
end

defmodule Tensorflow.ScopedAllocatorOptions do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          enable_op: [String.t()]
        }
  defstruct [:enable_op]

  field(:enable_op, 1, repeated: true, type: :string)
end

defmodule Tensorflow.RewriterConfig.CustomGraphOptimizer.ParameterMapEntry do
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

defmodule Tensorflow.RewriterConfig.CustomGraphOptimizer do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          parameter_map: %{String.t() => Tensorflow.AttrValue.t() | nil}
        }
  defstruct [:name, :parameter_map]

  field(:name, 1, type: :string)

  field(:parameter_map, 2,
    repeated: true,
    type: Tensorflow.RewriterConfig.CustomGraphOptimizer.ParameterMapEntry,
    map: true
  )
end

defmodule Tensorflow.RewriterConfig do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          layout_optimizer: Tensorflow.RewriterConfig.Toggle.t(),
          constant_folding: Tensorflow.RewriterConfig.Toggle.t(),
          shape_optimization: Tensorflow.RewriterConfig.Toggle.t(),
          remapping: Tensorflow.RewriterConfig.Toggle.t(),
          arithmetic_optimization: Tensorflow.RewriterConfig.Toggle.t(),
          dependency_optimization: Tensorflow.RewriterConfig.Toggle.t(),
          loop_optimization: Tensorflow.RewriterConfig.Toggle.t(),
          function_optimization: Tensorflow.RewriterConfig.Toggle.t(),
          debug_stripper: Tensorflow.RewriterConfig.Toggle.t(),
          disable_model_pruning: boolean,
          scoped_allocator_optimization: Tensorflow.RewriterConfig.Toggle.t(),
          pin_to_host_optimization: Tensorflow.RewriterConfig.Toggle.t(),
          implementation_selector: Tensorflow.RewriterConfig.Toggle.t(),
          auto_mixed_precision: Tensorflow.RewriterConfig.Toggle.t(),
          disable_meta_optimizer: boolean,
          meta_optimizer_iterations:
            Tensorflow.RewriterConfig.NumIterationsType.t(),
          min_graph_nodes: integer,
          memory_optimization: Tensorflow.RewriterConfig.MemOptType.t(),
          memory_optimizer_target_node_name_scope: String.t(),
          meta_optimizer_timeout_ms: integer,
          auto_parallel: Tensorflow.AutoParallelOptions.t() | nil,
          fail_on_optimizer_errors: boolean,
          scoped_allocator_opts: Tensorflow.ScopedAllocatorOptions.t() | nil,
          optimizers: [String.t()],
          custom_optimizers: [
            Tensorflow.RewriterConfig.CustomGraphOptimizer.t()
          ],
          inter_optimizer_verifier_config:
            Tensorflow.VerifierConfig.t() | nil,
          post_optimization_verifier_config:
            Tensorflow.VerifierConfig.t() | nil
        }
  defstruct [
    :layout_optimizer,
    :constant_folding,
    :shape_optimization,
    :remapping,
    :arithmetic_optimization,
    :dependency_optimization,
    :loop_optimization,
    :function_optimization,
    :debug_stripper,
    :disable_model_pruning,
    :scoped_allocator_optimization,
    :pin_to_host_optimization,
    :implementation_selector,
    :auto_mixed_precision,
    :disable_meta_optimizer,
    :meta_optimizer_iterations,
    :min_graph_nodes,
    :memory_optimization,
    :memory_optimizer_target_node_name_scope,
    :meta_optimizer_timeout_ms,
    :auto_parallel,
    :fail_on_optimizer_errors,
    :scoped_allocator_opts,
    :optimizers,
    :custom_optimizers,
    :inter_optimizer_verifier_config,
    :post_optimization_verifier_config
  ]

  field(:layout_optimizer, 1,
    type: Tensorflow.RewriterConfig.Toggle,
    enum: true
  )

  field(:constant_folding, 3,
    type: Tensorflow.RewriterConfig.Toggle,
    enum: true
  )

  field(:shape_optimization, 13,
    type: Tensorflow.RewriterConfig.Toggle,
    enum: true
  )

  field(:remapping, 14, type: Tensorflow.RewriterConfig.Toggle, enum: true)

  field(:arithmetic_optimization, 7,
    type: Tensorflow.RewriterConfig.Toggle,
    enum: true
  )

  field(:dependency_optimization, 8,
    type: Tensorflow.RewriterConfig.Toggle,
    enum: true
  )

  field(:loop_optimization, 9,
    type: Tensorflow.RewriterConfig.Toggle,
    enum: true
  )

  field(:function_optimization, 10,
    type: Tensorflow.RewriterConfig.Toggle,
    enum: true
  )

  field(:debug_stripper, 11,
    type: Tensorflow.RewriterConfig.Toggle,
    enum: true
  )

  field(:disable_model_pruning, 2, type: :bool)

  field(:scoped_allocator_optimization, 15,
    type: Tensorflow.RewriterConfig.Toggle,
    enum: true
  )

  field(:pin_to_host_optimization, 18,
    type: Tensorflow.RewriterConfig.Toggle,
    enum: true
  )

  field(:implementation_selector, 22,
    type: Tensorflow.RewriterConfig.Toggle,
    enum: true
  )

  field(:auto_mixed_precision, 23,
    type: Tensorflow.RewriterConfig.Toggle,
    enum: true
  )

  field(:disable_meta_optimizer, 19, type: :bool)

  field(:meta_optimizer_iterations, 12,
    type: Tensorflow.RewriterConfig.NumIterationsType,
    enum: true
  )

  field(:min_graph_nodes, 17, type: :int32)

  field(:memory_optimization, 4,
    type: Tensorflow.RewriterConfig.MemOptType,
    enum: true
  )

  field(:memory_optimizer_target_node_name_scope, 6, type: :string)
  field(:meta_optimizer_timeout_ms, 20, type: :int64)
  field(:auto_parallel, 5, type: Tensorflow.AutoParallelOptions)
  field(:fail_on_optimizer_errors, 21, type: :bool)
  field(:scoped_allocator_opts, 16, type: Tensorflow.ScopedAllocatorOptions)
  field(:optimizers, 100, repeated: true, type: :string)

  field(:custom_optimizers, 200,
    repeated: true,
    type: Tensorflow.RewriterConfig.CustomGraphOptimizer
  )

  field(:inter_optimizer_verifier_config, 300, type: Tensorflow.VerifierConfig)

  field(:post_optimization_verifier_config, 301,
    type: Tensorflow.VerifierConfig
  )
end

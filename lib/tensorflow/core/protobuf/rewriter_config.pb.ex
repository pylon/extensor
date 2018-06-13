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

defmodule Tensorflow.RewriterConfig do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          layout_optimizer: integer,
          constant_folding: integer,
          shape_optimization: integer,
          remapping: integer,
          arithmetic_optimization: integer,
          dependency_optimization: integer,
          loop_optimization: integer,
          function_optimization: integer,
          debug_stripper: integer,
          disable_model_pruning: boolean,
          scoped_allocator_optimization: integer,
          meta_optimizer_iterations: integer,
          memory_optimization: integer,
          memory_optimizer_target_node_name_scope: String.t(),
          auto_parallel: Tensorflow.AutoParallelOptions.t(),
          scoped_allocator_opts: Tensorflow.ScopedAllocatorOptions.t(),
          optimizers: [String.t()],
          custom_optimizers: [
            Tensorflow.RewriterConfig.CustomGraphOptimizer.t()
          ]
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
    :meta_optimizer_iterations,
    :memory_optimization,
    :memory_optimizer_target_node_name_scope,
    :auto_parallel,
    :scoped_allocator_opts,
    :optimizers,
    :custom_optimizers
  ]

  field(
    :layout_optimizer,
    1,
    type: Tensorflow.RewriterConfig.Toggle,
    enum: true
  )

  field(
    :constant_folding,
    3,
    type: Tensorflow.RewriterConfig.Toggle,
    enum: true
  )

  field(
    :shape_optimization,
    13,
    type: Tensorflow.RewriterConfig.Toggle,
    enum: true
  )

  field(:remapping, 14, type: Tensorflow.RewriterConfig.Toggle, enum: true)

  field(
    :arithmetic_optimization,
    7,
    type: Tensorflow.RewriterConfig.Toggle,
    enum: true
  )

  field(
    :dependency_optimization,
    8,
    type: Tensorflow.RewriterConfig.Toggle,
    enum: true
  )

  field(
    :loop_optimization,
    9,
    type: Tensorflow.RewriterConfig.Toggle,
    enum: true
  )

  field(
    :function_optimization,
    10,
    type: Tensorflow.RewriterConfig.Toggle,
    enum: true
  )

  field(
    :debug_stripper,
    11,
    type: Tensorflow.RewriterConfig.Toggle,
    enum: true
  )

  field(:disable_model_pruning, 2, type: :bool)

  field(
    :scoped_allocator_optimization,
    15,
    type: Tensorflow.RewriterConfig.Toggle,
    enum: true
  )

  field(
    :meta_optimizer_iterations,
    12,
    type: Tensorflow.RewriterConfig.NumIterationsType,
    enum: true
  )

  field(
    :memory_optimization,
    4,
    type: Tensorflow.RewriterConfig.MemOptType,
    enum: true
  )

  field(:memory_optimizer_target_node_name_scope, 6, type: :string)
  field(:auto_parallel, 5, type: Tensorflow.AutoParallelOptions)
  field(:scoped_allocator_opts, 16, type: Tensorflow.ScopedAllocatorOptions)
  field(:optimizers, 100, repeated: true, type: :string)

  field(
    :custom_optimizers,
    200,
    repeated: true,
    type: Tensorflow.RewriterConfig.CustomGraphOptimizer
  )
end

defmodule Tensorflow.RewriterConfig.CustomGraphOptimizer do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          parameter_map: %{String.t() => Tensorflow.AttrValue.t()}
        }
  defstruct [:name, :parameter_map]

  field(:name, 1, type: :string)

  field(
    :parameter_map,
    2,
    repeated: true,
    type: Tensorflow.RewriterConfig.CustomGraphOptimizer.ParameterMapEntry,
    map: true
  )
end

defmodule Tensorflow.RewriterConfig.CustomGraphOptimizer.ParameterMapEntry do
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

defmodule Tensorflow.RewriterConfig.Toggle do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  field(:DEFAULT, 0)
  field(:ON, 1)
  field(:OFF, 2)
  field(:AGGRESSIVE, 3)
end

defmodule Tensorflow.RewriterConfig.NumIterationsType do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  field(:DEFAULT_NUM_ITERS, 0)
  field(:ONE, 1)
  field(:TWO, 2)
end

defmodule Tensorflow.RewriterConfig.MemOptType do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  field(:DEFAULT_MEM_OPT, 0)
  field(:NO_MEM_OPT, 1)
  field(:MANUAL, 2)
  field(:SWAPPING_HEURISTICS, 4)
  field(:RECOMPUTATION_HEURISTICS, 5)
  field(:SCHEDULING_HEURISTICS, 6)
  field(:HEURISTICS, 3)
end

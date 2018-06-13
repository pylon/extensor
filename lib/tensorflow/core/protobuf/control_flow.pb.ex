defmodule Tensorflow.ValuesDef do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          values: [String.t()],
          external_values: %{String.t() => String.t()}
        }
  defstruct [:values, :external_values]

  field(:values, 1, repeated: true, type: :string)

  field(
    :external_values,
    2,
    repeated: true,
    type: Tensorflow.ValuesDef.ExternalValuesEntry,
    map: true
  )
end

defmodule Tensorflow.ValuesDef.ExternalValuesEntry do
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

defmodule Tensorflow.ControlFlowContextDef do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          ctxt: {atom, any}
        }
  defstruct [:ctxt]

  oneof(:ctxt, 0)
  field(:cond_ctxt, 1, type: Tensorflow.CondContextDef, oneof: 0)
  field(:while_ctxt, 2, type: Tensorflow.WhileContextDef, oneof: 0)
end

defmodule Tensorflow.CondContextDef do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          context_name: String.t(),
          pred_name: String.t(),
          pivot_name: String.t(),
          branch: integer,
          values_def: Tensorflow.ValuesDef.t(),
          nested_contexts: [Tensorflow.ControlFlowContextDef.t()]
        }
  defstruct [
    :context_name,
    :pred_name,
    :pivot_name,
    :branch,
    :values_def,
    :nested_contexts
  ]

  field(:context_name, 1, type: :string)
  field(:pred_name, 2, type: :string)
  field(:pivot_name, 3, type: :string)
  field(:branch, 4, type: :int32)
  field(:values_def, 5, type: Tensorflow.ValuesDef)

  field(
    :nested_contexts,
    6,
    repeated: true,
    type: Tensorflow.ControlFlowContextDef
  )
end

defmodule Tensorflow.WhileContextDef do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          context_name: String.t(),
          parallel_iterations: integer,
          back_prop: boolean,
          swap_memory: boolean,
          pivot_name: String.t(),
          pivot_for_pred_name: String.t(),
          pivot_for_body_name: String.t(),
          loop_exit_names: [String.t()],
          loop_enter_names: [String.t()],
          values_def: Tensorflow.ValuesDef.t(),
          maximum_iterations_name: String.t(),
          nested_contexts: [Tensorflow.ControlFlowContextDef.t()]
        }
  defstruct [
    :context_name,
    :parallel_iterations,
    :back_prop,
    :swap_memory,
    :pivot_name,
    :pivot_for_pred_name,
    :pivot_for_body_name,
    :loop_exit_names,
    :loop_enter_names,
    :values_def,
    :maximum_iterations_name,
    :nested_contexts
  ]

  field(:context_name, 1, type: :string)
  field(:parallel_iterations, 2, type: :int32)
  field(:back_prop, 3, type: :bool)
  field(:swap_memory, 4, type: :bool)
  field(:pivot_name, 5, type: :string)
  field(:pivot_for_pred_name, 6, type: :string)
  field(:pivot_for_body_name, 7, type: :string)
  field(:loop_exit_names, 8, repeated: true, type: :string)
  field(:loop_enter_names, 10, repeated: true, type: :string)
  field(:values_def, 9, type: Tensorflow.ValuesDef)
  field(:maximum_iterations_name, 11, type: :string)

  field(
    :nested_contexts,
    12,
    repeated: true,
    type: Tensorflow.ControlFlowContextDef
  )
end

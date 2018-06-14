defmodule Tensorflow.KernelDef do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          op: String.t(),
          device_type: String.t(),
          constraint: [Tensorflow.KernelDef.AttrConstraint.t()],
          host_memory_arg: [String.t()],
          label: String.t()
        }
  defstruct [:op, :device_type, :constraint, :host_memory_arg, :label]

  field(:op, 1, type: :string)
  field(:device_type, 2, type: :string)

  field(
    :constraint,
    3,
    repeated: true,
    type: Tensorflow.KernelDef.AttrConstraint
  )

  field(:host_memory_arg, 4, repeated: true, type: :string)
  field(:label, 5, type: :string)
end

defmodule Tensorflow.KernelDef.AttrConstraint do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          allowed_values: Tensorflow.AttrValue.t()
        }
  defstruct [:name, :allowed_values]

  field(:name, 1, type: :string)
  field(:allowed_values, 2, type: Tensorflow.AttrValue)
end

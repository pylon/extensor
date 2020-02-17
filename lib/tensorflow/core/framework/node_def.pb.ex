defmodule Tensorflow.NodeDef.AttrEntry do
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

defmodule Tensorflow.NodeDef.ExperimentalDebugInfo do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          original_node_names: [String.t()],
          original_func_names: [String.t()]
        }
  defstruct [:original_node_names, :original_func_names]

  field(:original_node_names, 1, repeated: true, type: :string)
  field(:original_func_names, 2, repeated: true, type: :string)
end

defmodule Tensorflow.NodeDef do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          op: String.t(),
          input: [String.t()],
          device: String.t(),
          attr: %{String.t() => Tensorflow.AttrValue.t() | nil},
          experimental_debug_info:
            Tensorflow.NodeDef.ExperimentalDebugInfo.t() | nil
        }
  defstruct [:name, :op, :input, :device, :attr, :experimental_debug_info]

  field(:name, 1, type: :string)
  field(:op, 2, type: :string)
  field(:input, 3, repeated: true, type: :string)
  field(:device, 4, type: :string)

  field(:attr, 5,
    repeated: true,
    type: Tensorflow.NodeDef.AttrEntry,
    map: true
  )

  field(:experimental_debug_info, 6,
    type: Tensorflow.NodeDef.ExperimentalDebugInfo
  )
end

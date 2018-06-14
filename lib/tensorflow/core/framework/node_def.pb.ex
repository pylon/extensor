defmodule Tensorflow.NodeDef do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          op: String.t(),
          input: [String.t()],
          device: String.t(),
          attr: %{String.t() => Tensorflow.AttrValue.t()}
        }
  defstruct [:name, :op, :input, :device, :attr]

  field(:name, 1, type: :string)
  field(:op, 2, type: :string)
  field(:input, 3, repeated: true, type: :string)
  field(:device, 4, type: :string)

  field(
    :attr,
    5,
    repeated: true,
    type: Tensorflow.NodeDef.AttrEntry,
    map: true
  )
end

defmodule Tensorflow.NodeDef.AttrEntry do
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

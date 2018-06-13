defmodule Tensorflow.AttrValue do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          value: {atom, any}
        }
  defstruct [:value]

  oneof(:value, 0)
  field(:s, 2, type: :bytes, oneof: 0)
  field(:i, 3, type: :int64, oneof: 0)
  field(:f, 4, type: :float, oneof: 0)
  field(:b, 5, type: :bool, oneof: 0)
  field(:type, 6, type: Tensorflow.DataType, enum: true, oneof: 0)
  field(:shape, 7, type: Tensorflow.TensorShapeProto, oneof: 0)
  field(:tensor, 8, type: Tensorflow.TensorProto, oneof: 0)
  field(:list, 1, type: Tensorflow.AttrValue.ListValue, oneof: 0)
  field(:func, 10, type: Tensorflow.NameAttrList, oneof: 0)
  field(:placeholder, 9, type: :string, oneof: 0)
end

defmodule Tensorflow.AttrValue.ListValue do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          s: [String.t()],
          i: [integer],
          f: [float],
          b: [boolean],
          type: [integer],
          shape: [Tensorflow.TensorShapeProto.t()],
          tensor: [Tensorflow.TensorProto.t()],
          func: [Tensorflow.NameAttrList.t()]
        }
  defstruct [:s, :i, :f, :b, :type, :shape, :tensor, :func]

  field(:s, 2, repeated: true, type: :bytes)
  field(:i, 3, repeated: true, type: :int64, packed: true)
  field(:f, 4, repeated: true, type: :float, packed: true)
  field(:b, 5, repeated: true, type: :bool, packed: true)

  field(
    :type,
    6,
    repeated: true,
    type: Tensorflow.DataType,
    enum: true,
    packed: true
  )

  field(:shape, 7, repeated: true, type: Tensorflow.TensorShapeProto)
  field(:tensor, 8, repeated: true, type: Tensorflow.TensorProto)
  field(:func, 9, repeated: true, type: Tensorflow.NameAttrList)
end

defmodule Tensorflow.NameAttrList do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          attr: %{String.t() => Tensorflow.AttrValue.t()}
        }
  defstruct [:name, :attr]

  field(:name, 1, type: :string)

  field(
    :attr,
    2,
    repeated: true,
    type: Tensorflow.NameAttrList.AttrEntry,
    map: true
  )
end

defmodule Tensorflow.NameAttrList.AttrEntry do
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

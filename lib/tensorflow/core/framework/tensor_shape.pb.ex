defmodule Tensorflow.TensorShapeProto.Dim do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          size: integer,
          name: String.t()
        }
  defstruct [:size, :name]

  field(:size, 1, type: :int64)
  field(:name, 2, type: :string)
end

defmodule Tensorflow.TensorShapeProto do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          dim: [Tensorflow.TensorShapeProto.Dim.t()],
          unknown_rank: boolean
        }
  defstruct [:dim, :unknown_rank]

  field(:dim, 2, repeated: true, type: Tensorflow.TensorShapeProto.Dim)
  field(:unknown_rank, 3, type: :bool)
end

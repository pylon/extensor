defmodule Tensorflow.TensorSliceProto do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          extent: [Tensorflow.TensorSliceProto.Extent.t()]
        }
  defstruct [:extent]

  field(:extent, 1, repeated: true, type: Tensorflow.TensorSliceProto.Extent)
end

defmodule Tensorflow.TensorSliceProto.Extent do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          has_length: {atom, any},
          start: integer
        }
  defstruct [:has_length, :start]

  oneof(:has_length, 0)
  field(:start, 1, type: :int64)
  field(:length, 2, type: :int64, oneof: 0)
end

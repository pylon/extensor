defmodule Tensorflow.NamedTensorProto do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          tensor: Tensorflow.TensorProto.t() | nil
        }
  defstruct [:name, :tensor]

  field(:name, 1, type: :string)
  field(:tensor, 2, type: Tensorflow.TensorProto)
end

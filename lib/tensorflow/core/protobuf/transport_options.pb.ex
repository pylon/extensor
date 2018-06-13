defmodule Tensorflow.RecvBufRespExtra do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          tensor_content: String.t()
        }
  defstruct [:tensor_content]

  field(:tensor_content, 1, type: :bytes)
end

defmodule Tensorflow.RecvBufRespExtra do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          tensor_content: [binary]
        }
  defstruct [:tensor_content]

  field(:tensor_content, 1, repeated: true, type: :bytes)
end

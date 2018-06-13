defmodule Tensorflow.IteratorStateMetadata do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          version: String.t(),
          keys: [String.t()]
        }
  defstruct [:version, :keys]

  field(:version, 1, type: :string)
  field(:keys, 2, repeated: true, type: :string)
end

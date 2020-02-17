defmodule Tensorflow.VerifierConfig.Toggle do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  @type t :: integer | :DEFAULT | :ON | :OFF

  field(:DEFAULT, 0)
  field(:ON, 1)
  field(:OFF, 2)
end

defmodule Tensorflow.VerifierConfig do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          verification_timeout_in_ms: integer,
          structure_verifier: Tensorflow.VerifierConfig.Toggle.t()
        }
  defstruct [:verification_timeout_in_ms, :structure_verifier]

  field(:verification_timeout_in_ms, 1, type: :int64)

  field(:structure_verifier, 2,
    type: Tensorflow.VerifierConfig.Toggle,
    enum: true
  )
end

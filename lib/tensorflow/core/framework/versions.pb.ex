defmodule Tensorflow.VersionDef do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          producer: integer,
          min_consumer: integer,
          bad_consumers: [integer]
        }
  defstruct [:producer, :min_consumer, :bad_consumers]

  field(:producer, 1, type: :int32)
  field(:min_consumer, 2, type: :int32)
  field(:bad_consumers, 3, repeated: true, type: :int32)
end

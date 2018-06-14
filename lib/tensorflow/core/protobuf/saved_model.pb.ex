defmodule Tensorflow.SavedModel do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          saved_model_schema_version: integer,
          meta_graphs: [Tensorflow.MetaGraphDef.t()]
        }
  defstruct [:saved_model_schema_version, :meta_graphs]

  field(:saved_model_schema_version, 1, type: :int64)
  field(:meta_graphs, 2, repeated: true, type: Tensorflow.MetaGraphDef)
end

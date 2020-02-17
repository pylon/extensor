defmodule Tensorflow.GraphDef do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          node: [Tensorflow.NodeDef.t()],
          versions: Tensorflow.VersionDef.t() | nil,
          version: integer,
          library: Tensorflow.FunctionDefLibrary.t() | nil
        }
  defstruct [:node, :versions, :version, :library]

  field(:node, 1, repeated: true, type: Tensorflow.NodeDef)
  field(:versions, 4, type: Tensorflow.VersionDef)
  field(:version, 3, type: :int32, deprecated: true)
  field(:library, 2, type: Tensorflow.FunctionDefLibrary)
end

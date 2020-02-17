defmodule Tensorflow.GraphDebugInfo.FileLineCol do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          file_index: integer,
          line: integer,
          col: integer,
          func: String.t(),
          code: String.t()
        }
  defstruct [:file_index, :line, :col, :func, :code]

  field(:file_index, 1, type: :int32)
  field(:line, 2, type: :int32)
  field(:col, 3, type: :int32)
  field(:func, 4, type: :string)
  field(:code, 5, type: :string)
end

defmodule Tensorflow.GraphDebugInfo.StackTrace do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          file_line_cols: [Tensorflow.GraphDebugInfo.FileLineCol.t()]
        }
  defstruct [:file_line_cols]

  field(:file_line_cols, 1,
    repeated: true,
    type: Tensorflow.GraphDebugInfo.FileLineCol
  )
end

defmodule Tensorflow.GraphDebugInfo.TracesEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: Tensorflow.GraphDebugInfo.StackTrace.t() | nil
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: Tensorflow.GraphDebugInfo.StackTrace)
end

defmodule Tensorflow.GraphDebugInfo do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          files: [String.t()],
          traces: %{
            String.t() => Tensorflow.GraphDebugInfo.StackTrace.t() | nil
          }
        }
  defstruct [:files, :traces]

  field(:files, 1, repeated: true, type: :string)

  field(:traces, 2,
    repeated: true,
    type: Tensorflow.GraphDebugInfo.TracesEntry,
    map: true
  )
end

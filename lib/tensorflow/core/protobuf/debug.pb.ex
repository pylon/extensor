defmodule Tensorflow.DebugTensorWatch do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          node_name: String.t(),
          output_slot: integer,
          debug_ops: [String.t()],
          debug_urls: [String.t()],
          tolerate_debug_op_creation_failures: boolean
        }
  defstruct [
    :node_name,
    :output_slot,
    :debug_ops,
    :debug_urls,
    :tolerate_debug_op_creation_failures
  ]

  field(:node_name, 1, type: :string)
  field(:output_slot, 2, type: :int32)
  field(:debug_ops, 3, repeated: true, type: :string)
  field(:debug_urls, 4, repeated: true, type: :string)
  field(:tolerate_debug_op_creation_failures, 5, type: :bool)
end

defmodule Tensorflow.DebugOptions do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          debug_tensor_watch_opts: [Tensorflow.DebugTensorWatch.t()],
          global_step: integer
        }
  defstruct [:debug_tensor_watch_opts, :global_step]

  field(
    :debug_tensor_watch_opts,
    4,
    repeated: true,
    type: Tensorflow.DebugTensorWatch
  )

  field(:global_step, 10, type: :int64)
end

defmodule Tensorflow.DebuggedSourceFile do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          host: String.t(),
          file_path: String.t(),
          last_modified: integer,
          bytes: integer,
          lines: [String.t()]
        }
  defstruct [:host, :file_path, :last_modified, :bytes, :lines]

  field(:host, 1, type: :string)
  field(:file_path, 2, type: :string)
  field(:last_modified, 3, type: :int64)
  field(:bytes, 4, type: :int64)
  field(:lines, 5, repeated: true, type: :string)
end

defmodule Tensorflow.DebuggedSourceFiles do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          source_files: [Tensorflow.DebuggedSourceFile.t()]
        }
  defstruct [:source_files]

  field(:source_files, 1, repeated: true, type: Tensorflow.DebuggedSourceFile)
end

defmodule Tensorflow.JobDef do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          tasks: %{integer => String.t()}
        }
  defstruct [:name, :tasks]

  field(:name, 1, type: :string)

  field(
    :tasks,
    2,
    repeated: true,
    type: Tensorflow.JobDef.TasksEntry,
    map: true
  )
end

defmodule Tensorflow.JobDef.TasksEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: integer,
          value: String.t()
        }
  defstruct [:key, :value]

  field(:key, 1, type: :int32)
  field(:value, 2, type: :string)
end

defmodule Tensorflow.ClusterDef do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          job: [Tensorflow.JobDef.t()]
        }
  defstruct [:job]

  field(:job, 1, repeated: true, type: Tensorflow.JobDef)
end

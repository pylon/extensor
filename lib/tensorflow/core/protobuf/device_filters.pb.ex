defmodule Tensorflow.TaskDeviceFilters do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          device_filters: [String.t()]
        }
  defstruct [:device_filters]

  field(:device_filters, 1, repeated: true, type: :string)
end

defmodule Tensorflow.JobDeviceFilters.TasksEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: integer,
          value: Tensorflow.TaskDeviceFilters.t() | nil
        }
  defstruct [:key, :value]

  field(:key, 1, type: :int32)
  field(:value, 2, type: Tensorflow.TaskDeviceFilters)
end

defmodule Tensorflow.JobDeviceFilters do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          tasks: %{integer => Tensorflow.TaskDeviceFilters.t() | nil}
        }
  defstruct [:name, :tasks]

  field(:name, 1, type: :string)

  field(:tasks, 2,
    repeated: true,
    type: Tensorflow.JobDeviceFilters.TasksEntry,
    map: true
  )
end

defmodule Tensorflow.ClusterDeviceFilters do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          jobs: [Tensorflow.JobDeviceFilters.t()]
        }
  defstruct [:jobs]

  field(:jobs, 1, repeated: true, type: Tensorflow.JobDeviceFilters)
end

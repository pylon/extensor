defmodule Tensorflow.Profiler.Trace.DevicesEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: non_neg_integer,
          value: Tensorflow.Profiler.Device.t() | nil
        }
  defstruct [:key, :value]

  field(:key, 1, type: :uint32)
  field(:value, 2, type: Tensorflow.Profiler.Device)
end

defmodule Tensorflow.Profiler.Trace do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          devices: %{non_neg_integer => Tensorflow.Profiler.Device.t() | nil},
          trace_events: [Tensorflow.Profiler.TraceEvent.t()]
        }
  defstruct [:devices, :trace_events]

  field(:devices, 1,
    repeated: true,
    type: Tensorflow.Profiler.Trace.DevicesEntry,
    map: true
  )

  field(:trace_events, 4, repeated: true, type: Tensorflow.Profiler.TraceEvent)
end

defmodule Tensorflow.Profiler.Device.ResourcesEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: non_neg_integer,
          value: Tensorflow.Profiler.Resource.t() | nil
        }
  defstruct [:key, :value]

  field(:key, 1, type: :uint32)
  field(:value, 2, type: Tensorflow.Profiler.Resource)
end

defmodule Tensorflow.Profiler.Device do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          device_id: non_neg_integer,
          resources: %{
            non_neg_integer => Tensorflow.Profiler.Resource.t() | nil
          }
        }
  defstruct [:name, :device_id, :resources]

  field(:name, 1, type: :string)
  field(:device_id, 2, type: :uint32)

  field(:resources, 3,
    repeated: true,
    type: Tensorflow.Profiler.Device.ResourcesEntry,
    map: true
  )
end

defmodule Tensorflow.Profiler.Resource do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          resource_id: non_neg_integer
        }
  defstruct [:name, :resource_id]

  field(:name, 1, type: :string)
  field(:resource_id, 2, type: :uint32)
end

defmodule Tensorflow.Profiler.TraceEvent.ArgsEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: String.t()
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: :string)
end

defmodule Tensorflow.Profiler.TraceEvent do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          device_id: non_neg_integer,
          resource_id: non_neg_integer,
          name: String.t(),
          timestamp_ps: non_neg_integer,
          duration_ps: non_neg_integer,
          args: %{String.t() => String.t()}
        }
  defstruct [
    :device_id,
    :resource_id,
    :name,
    :timestamp_ps,
    :duration_ps,
    :args
  ]

  field(:device_id, 1, type: :uint32)
  field(:resource_id, 2, type: :uint32)
  field(:name, 3, type: :string)
  field(:timestamp_ps, 9, type: :uint64)
  field(:duration_ps, 10, type: :uint64)

  field(:args, 11,
    repeated: true,
    type: Tensorflow.Profiler.TraceEvent.ArgsEntry,
    map: true
  )
end

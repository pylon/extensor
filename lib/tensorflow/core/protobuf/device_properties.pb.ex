defmodule Tensorflow.DeviceProperties do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          type: String.t(),
          vendor: String.t(),
          model: String.t(),
          frequency: integer,
          num_cores: integer,
          environment: %{String.t() => String.t()},
          num_registers: integer,
          l1_cache_size: integer,
          l2_cache_size: integer,
          l3_cache_size: integer,
          shared_memory_size_per_multiprocessor: integer,
          memory_size: integer,
          bandwidth: integer
        }
  defstruct [
    :type,
    :vendor,
    :model,
    :frequency,
    :num_cores,
    :environment,
    :num_registers,
    :l1_cache_size,
    :l2_cache_size,
    :l3_cache_size,
    :shared_memory_size_per_multiprocessor,
    :memory_size,
    :bandwidth
  ]

  field(:type, 1, type: :string)
  field(:vendor, 2, type: :string)
  field(:model, 3, type: :string)
  field(:frequency, 4, type: :int64)
  field(:num_cores, 5, type: :int64)

  field(
    :environment,
    6,
    repeated: true,
    type: Tensorflow.DeviceProperties.EnvironmentEntry,
    map: true
  )

  field(:num_registers, 7, type: :int64)
  field(:l1_cache_size, 8, type: :int64)
  field(:l2_cache_size, 9, type: :int64)
  field(:l3_cache_size, 10, type: :int64)
  field(:shared_memory_size_per_multiprocessor, 11, type: :int64)
  field(:memory_size, 12, type: :int64)
  field(:bandwidth, 13, type: :int64)
end

defmodule Tensorflow.DeviceProperties.EnvironmentEntry do
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

defmodule Tensorflow.NamedDevice do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          properties: Tensorflow.DeviceProperties.t()
        }
  defstruct [:name, :properties]

  field(:name, 1, type: :string)
  field(:properties, 2, type: Tensorflow.DeviceProperties)
end

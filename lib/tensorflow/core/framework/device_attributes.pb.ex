defmodule Tensorflow.InterconnectLink do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          device_id: integer,
          type: String.t(),
          strength: integer
        }
  defstruct [:device_id, :type, :strength]

  field(:device_id, 1, type: :int32)
  field(:type, 2, type: :string)
  field(:strength, 3, type: :int32)
end

defmodule Tensorflow.LocalLinks do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          link: [Tensorflow.InterconnectLink.t()]
        }
  defstruct [:link]

  field(:link, 1, repeated: true, type: Tensorflow.InterconnectLink)
end

defmodule Tensorflow.DeviceLocality do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          bus_id: integer,
          numa_node: integer,
          links: Tensorflow.LocalLinks.t() | nil
        }
  defstruct [:bus_id, :numa_node, :links]

  field(:bus_id, 1, type: :int32)
  field(:numa_node, 2, type: :int32)
  field(:links, 3, type: Tensorflow.LocalLinks)
end

defmodule Tensorflow.DeviceAttributes do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          device_type: String.t(),
          memory_limit: integer,
          locality: Tensorflow.DeviceLocality.t() | nil,
          incarnation: non_neg_integer,
          physical_device_desc: String.t()
        }
  defstruct [
    :name,
    :device_type,
    :memory_limit,
    :locality,
    :incarnation,
    :physical_device_desc
  ]

  field(:name, 1, type: :string)
  field(:device_type, 2, type: :string)
  field(:memory_limit, 4, type: :int64)
  field(:locality, 5, type: Tensorflow.DeviceLocality)
  field(:incarnation, 6, type: :fixed64)
  field(:physical_device_desc, 7, type: :string)
end

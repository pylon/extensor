defmodule Tensorflow.CostGraphDef.Node.InputInfo do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          preceding_node: integer,
          preceding_port: integer
        }
  defstruct [:preceding_node, :preceding_port]

  field(:preceding_node, 1, type: :int32)
  field(:preceding_port, 2, type: :int32)
end

defmodule Tensorflow.CostGraphDef.Node.OutputInfo do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          size: integer,
          alias_input_port: integer,
          shape: Tensorflow.TensorShapeProto.t() | nil,
          dtype: Tensorflow.DataType.t()
        }
  defstruct [:size, :alias_input_port, :shape, :dtype]

  field(:size, 1, type: :int64)
  field(:alias_input_port, 2, type: :int64)
  field(:shape, 3, type: Tensorflow.TensorShapeProto)
  field(:dtype, 4, type: Tensorflow.DataType, enum: true)
end

defmodule Tensorflow.CostGraphDef.Node do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          device: String.t(),
          id: integer,
          input_info: [Tensorflow.CostGraphDef.Node.InputInfo.t()],
          output_info: [Tensorflow.CostGraphDef.Node.OutputInfo.t()],
          temporary_memory_size: integer,
          persistent_memory_size: integer,
          host_temp_memory_size: integer,
          device_temp_memory_size: integer,
          device_persistent_memory_size: integer,
          compute_cost: integer,
          compute_time: integer,
          memory_time: integer,
          is_final: boolean,
          control_input: [integer],
          inaccurate: boolean
        }
  defstruct [
    :name,
    :device,
    :id,
    :input_info,
    :output_info,
    :temporary_memory_size,
    :persistent_memory_size,
    :host_temp_memory_size,
    :device_temp_memory_size,
    :device_persistent_memory_size,
    :compute_cost,
    :compute_time,
    :memory_time,
    :is_final,
    :control_input,
    :inaccurate
  ]

  field(:name, 1, type: :string)
  field(:device, 2, type: :string)
  field(:id, 3, type: :int32)

  field(:input_info, 4,
    repeated: true,
    type: Tensorflow.CostGraphDef.Node.InputInfo
  )

  field(:output_info, 5,
    repeated: true,
    type: Tensorflow.CostGraphDef.Node.OutputInfo
  )

  field(:temporary_memory_size, 6, type: :int64)
  field(:persistent_memory_size, 12, type: :int64)
  field(:host_temp_memory_size, 10, type: :int64, deprecated: true)
  field(:device_temp_memory_size, 11, type: :int64, deprecated: true)
  field(:device_persistent_memory_size, 16, type: :int64, deprecated: true)
  field(:compute_cost, 9, type: :int64)
  field(:compute_time, 14, type: :int64)
  field(:memory_time, 15, type: :int64)
  field(:is_final, 7, type: :bool)
  field(:control_input, 8, repeated: true, type: :int32)
  field(:inaccurate, 17, type: :bool)
end

defmodule Tensorflow.CostGraphDef do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          node: [Tensorflow.CostGraphDef.Node.t()]
        }
  defstruct [:node]

  field(:node, 1, repeated: true, type: Tensorflow.CostGraphDef.Node)
end

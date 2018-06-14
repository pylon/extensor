defmodule Tensorflow.AllocationRecord do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          alloc_micros: integer,
          alloc_bytes: integer
        }
  defstruct [:alloc_micros, :alloc_bytes]

  field(:alloc_micros, 1, type: :int64)
  field(:alloc_bytes, 2, type: :int64)
end

defmodule Tensorflow.AllocatorMemoryUsed do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          allocator_name: String.t(),
          total_bytes: integer,
          peak_bytes: integer,
          live_bytes: integer,
          allocation_records: [Tensorflow.AllocationRecord.t()],
          allocator_bytes_in_use: integer
        }
  defstruct [
    :allocator_name,
    :total_bytes,
    :peak_bytes,
    :live_bytes,
    :allocation_records,
    :allocator_bytes_in_use
  ]

  field(:allocator_name, 1, type: :string)
  field(:total_bytes, 2, type: :int64)
  field(:peak_bytes, 3, type: :int64)
  field(:live_bytes, 4, type: :int64)

  field(
    :allocation_records,
    6,
    repeated: true,
    type: Tensorflow.AllocationRecord
  )

  field(:allocator_bytes_in_use, 5, type: :int64)
end

defmodule Tensorflow.NodeOutput do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          slot: integer,
          tensor_description: Tensorflow.TensorDescription.t()
        }
  defstruct [:slot, :tensor_description]

  field(:slot, 1, type: :int32)
  field(:tensor_description, 3, type: Tensorflow.TensorDescription)
end

defmodule Tensorflow.MemoryStats do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          temp_memory_size: integer,
          persistent_memory_size: integer,
          persistent_tensor_alloc_ids: [integer],
          device_temp_memory_size: integer,
          device_persistent_memory_size: integer,
          device_persistent_tensor_alloc_ids: [integer]
        }
  defstruct [
    :temp_memory_size,
    :persistent_memory_size,
    :persistent_tensor_alloc_ids,
    :device_temp_memory_size,
    :device_persistent_memory_size,
    :device_persistent_tensor_alloc_ids
  ]

  field(:temp_memory_size, 1, type: :int64)
  field(:persistent_memory_size, 3, type: :int64)
  field(:persistent_tensor_alloc_ids, 5, repeated: true, type: :int64)
  field(:device_temp_memory_size, 2, type: :int64, deprecated: true)
  field(:device_persistent_memory_size, 4, type: :int64, deprecated: true)

  field(
    :device_persistent_tensor_alloc_ids,
    6,
    repeated: true,
    type: :int64,
    deprecated: true
  )
end

defmodule Tensorflow.NodeExecStats do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          node_name: String.t(),
          all_start_micros: integer,
          op_start_rel_micros: integer,
          op_end_rel_micros: integer,
          all_end_rel_micros: integer,
          memory: [Tensorflow.AllocatorMemoryUsed.t()],
          output: [Tensorflow.NodeOutput.t()],
          timeline_label: String.t(),
          scheduled_micros: integer,
          thread_id: non_neg_integer,
          referenced_tensor: [Tensorflow.AllocationDescription.t()],
          memory_stats: Tensorflow.MemoryStats.t()
        }
  defstruct [
    :node_name,
    :all_start_micros,
    :op_start_rel_micros,
    :op_end_rel_micros,
    :all_end_rel_micros,
    :memory,
    :output,
    :timeline_label,
    :scheduled_micros,
    :thread_id,
    :referenced_tensor,
    :memory_stats
  ]

  field(:node_name, 1, type: :string)
  field(:all_start_micros, 2, type: :int64)
  field(:op_start_rel_micros, 3, type: :int64)
  field(:op_end_rel_micros, 4, type: :int64)
  field(:all_end_rel_micros, 5, type: :int64)
  field(:memory, 6, repeated: true, type: Tensorflow.AllocatorMemoryUsed)
  field(:output, 7, repeated: true, type: Tensorflow.NodeOutput)
  field(:timeline_label, 8, type: :string)
  field(:scheduled_micros, 9, type: :int64)
  field(:thread_id, 10, type: :uint32)

  field(
    :referenced_tensor,
    11,
    repeated: true,
    type: Tensorflow.AllocationDescription
  )

  field(:memory_stats, 12, type: Tensorflow.MemoryStats)
end

defmodule Tensorflow.DeviceStepStats do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          device: String.t(),
          node_stats: [Tensorflow.NodeExecStats.t()]
        }
  defstruct [:device, :node_stats]

  field(:device, 1, type: :string)
  field(:node_stats, 2, repeated: true, type: Tensorflow.NodeExecStats)
end

defmodule Tensorflow.StepStats do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          dev_stats: [Tensorflow.DeviceStepStats.t()]
        }
  defstruct [:dev_stats]

  field(:dev_stats, 1, repeated: true, type: Tensorflow.DeviceStepStats)
end

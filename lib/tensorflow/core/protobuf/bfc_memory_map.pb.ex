defmodule Tensorflow.MemAllocatorStats do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          num_allocs: integer,
          bytes_in_use: integer,
          peak_bytes_in_use: integer,
          largest_alloc_size: integer,
          fragmentation_metric: float | :infinity | :negative_infinity | :nan
        }
  defstruct [
    :num_allocs,
    :bytes_in_use,
    :peak_bytes_in_use,
    :largest_alloc_size,
    :fragmentation_metric
  ]

  field(:num_allocs, 1, type: :int64)
  field(:bytes_in_use, 2, type: :int64)
  field(:peak_bytes_in_use, 3, type: :int64)
  field(:largest_alloc_size, 4, type: :int64)
  field(:fragmentation_metric, 5, type: :float)
end

defmodule Tensorflow.MemChunk do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          address: non_neg_integer,
          size: integer,
          requested_size: integer,
          bin: integer,
          op_name: String.t(),
          freed_at_count: non_neg_integer,
          action_count: non_neg_integer,
          in_use: boolean,
          step_id: non_neg_integer
        }
  defstruct [
    :address,
    :size,
    :requested_size,
    :bin,
    :op_name,
    :freed_at_count,
    :action_count,
    :in_use,
    :step_id
  ]

  field(:address, 1, type: :uint64)
  field(:size, 2, type: :int64)
  field(:requested_size, 3, type: :int64)
  field(:bin, 4, type: :int32)
  field(:op_name, 5, type: :string)
  field(:freed_at_count, 6, type: :uint64)
  field(:action_count, 7, type: :uint64)
  field(:in_use, 8, type: :bool)
  field(:step_id, 9, type: :uint64)
end

defmodule Tensorflow.BinSummary do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          bin: integer,
          total_bytes_in_use: integer,
          total_bytes_in_bin: integer,
          total_chunks_in_use: integer,
          total_chunks_in_bin: integer
        }
  defstruct [
    :bin,
    :total_bytes_in_use,
    :total_bytes_in_bin,
    :total_chunks_in_use,
    :total_chunks_in_bin
  ]

  field(:bin, 1, type: :int32)
  field(:total_bytes_in_use, 2, type: :int64)
  field(:total_bytes_in_bin, 3, type: :int64)
  field(:total_chunks_in_use, 4, type: :int64)
  field(:total_chunks_in_bin, 5, type: :int64)
end

defmodule Tensorflow.SnapShot do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          action_count: non_neg_integer,
          size: integer
        }
  defstruct [:action_count, :size]

  field(:action_count, 1, type: :uint64)
  field(:size, 2, type: :int64)
end

defmodule Tensorflow.MemoryDump do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          allocator_name: String.t(),
          bin_summary: [Tensorflow.BinSummary.t()],
          chunk: [Tensorflow.MemChunk.t()],
          snap_shot: [Tensorflow.SnapShot.t()],
          stats: Tensorflow.MemAllocatorStats.t() | nil
        }
  defstruct [:allocator_name, :bin_summary, :chunk, :snap_shot, :stats]

  field(:allocator_name, 1, type: :string)
  field(:bin_summary, 2, repeated: true, type: Tensorflow.BinSummary)
  field(:chunk, 3, repeated: true, type: Tensorflow.MemChunk)
  field(:snap_shot, 4, repeated: true, type: Tensorflow.SnapShot)
  field(:stats, 5, type: Tensorflow.MemAllocatorStats)
end

defmodule Tensorflow.BundleHeaderProto do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          num_shards: integer,
          endianness: integer,
          version: Tensorflow.VersionDef.t()
        }
  defstruct [:num_shards, :endianness, :version]

  field(:num_shards, 1, type: :int32)

  field(
    :endianness,
    2,
    type: Tensorflow.BundleHeaderProto.Endianness,
    enum: true
  )

  field(:version, 3, type: Tensorflow.VersionDef)
end

defmodule Tensorflow.BundleHeaderProto.Endianness do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  field(:LITTLE, 0)
  field(:BIG, 1)
end

defmodule Tensorflow.BundleEntryProto do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          dtype: integer,
          shape: Tensorflow.TensorShapeProto.t(),
          shard_id: integer,
          offset: integer,
          size: integer,
          crc32c: non_neg_integer,
          slices: [Tensorflow.TensorSliceProto.t()]
        }
  defstruct [:dtype, :shape, :shard_id, :offset, :size, :crc32c, :slices]

  field(:dtype, 1, type: Tensorflow.DataType, enum: true)
  field(:shape, 2, type: Tensorflow.TensorShapeProto)
  field(:shard_id, 3, type: :int32)
  field(:offset, 4, type: :int64)
  field(:size, 5, type: :int64)
  field(:crc32c, 6, type: :fixed32)
  field(:slices, 7, repeated: true, type: Tensorflow.TensorSliceProto)
end

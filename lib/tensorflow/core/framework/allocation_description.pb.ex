defmodule Tensorflow.AllocationDescription do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          requested_bytes: integer,
          allocated_bytes: integer,
          allocator_name: String.t(),
          allocation_id: integer,
          has_single_reference: boolean,
          ptr: non_neg_integer
        }
  defstruct [
    :requested_bytes,
    :allocated_bytes,
    :allocator_name,
    :allocation_id,
    :has_single_reference,
    :ptr
  ]

  field(:requested_bytes, 1, type: :int64)
  field(:allocated_bytes, 2, type: :int64)
  field(:allocator_name, 3, type: :string)
  field(:allocation_id, 4, type: :int64)
  field(:has_single_reference, 5, type: :bool)
  field(:ptr, 6, type: :uint64)
end

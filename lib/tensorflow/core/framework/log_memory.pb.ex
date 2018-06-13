defmodule Tensorflow.MemoryLogStep do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          step_id: integer,
          handle: String.t()
        }
  defstruct [:step_id, :handle]

  field(:step_id, 1, type: :int64)
  field(:handle, 2, type: :string)
end

defmodule Tensorflow.MemoryLogTensorAllocation do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          step_id: integer,
          kernel_name: String.t(),
          tensor: Tensorflow.TensorDescription.t()
        }
  defstruct [:step_id, :kernel_name, :tensor]

  field(:step_id, 1, type: :int64)
  field(:kernel_name, 2, type: :string)
  field(:tensor, 3, type: Tensorflow.TensorDescription)
end

defmodule Tensorflow.MemoryLogTensorDeallocation do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          allocation_id: integer,
          allocator_name: String.t()
        }
  defstruct [:allocation_id, :allocator_name]

  field(:allocation_id, 1, type: :int64)
  field(:allocator_name, 2, type: :string)
end

defmodule Tensorflow.MemoryLogTensorOutput do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          step_id: integer,
          kernel_name: String.t(),
          index: integer,
          tensor: Tensorflow.TensorDescription.t()
        }
  defstruct [:step_id, :kernel_name, :index, :tensor]

  field(:step_id, 1, type: :int64)
  field(:kernel_name, 2, type: :string)
  field(:index, 3, type: :int32)
  field(:tensor, 4, type: Tensorflow.TensorDescription)
end

defmodule Tensorflow.MemoryLogRawAllocation do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          step_id: integer,
          operation: String.t(),
          num_bytes: integer,
          ptr: non_neg_integer,
          allocation_id: integer,
          allocator_name: String.t()
        }
  defstruct [
    :step_id,
    :operation,
    :num_bytes,
    :ptr,
    :allocation_id,
    :allocator_name
  ]

  field(:step_id, 1, type: :int64)
  field(:operation, 2, type: :string)
  field(:num_bytes, 3, type: :int64)
  field(:ptr, 4, type: :uint64)
  field(:allocation_id, 5, type: :int64)
  field(:allocator_name, 6, type: :string)
end

defmodule Tensorflow.MemoryLogRawDeallocation do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          step_id: integer,
          operation: String.t(),
          allocation_id: integer,
          allocator_name: String.t(),
          deferred: boolean
        }
  defstruct [:step_id, :operation, :allocation_id, :allocator_name, :deferred]

  field(:step_id, 1, type: :int64)
  field(:operation, 2, type: :string)
  field(:allocation_id, 3, type: :int64)
  field(:allocator_name, 4, type: :string)
  field(:deferred, 5, type: :bool)
end

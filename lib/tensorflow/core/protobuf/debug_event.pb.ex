defmodule Tensorflow.TensorDebugMode do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  @type t ::
          integer
          | :UNSPECIFIED
          | :NO_TENSOR
          | :CURT_HEALTH
          | :CONCISE_HEALTH
          | :FULL_HEALTH
          | :SHAPE
          | :FULL_NUMERICS
          | :FULL_TENSOR
          | :REDUCE_INF_NAN_THREE_SLOTS

  field(:UNSPECIFIED, 0)
  field(:NO_TENSOR, 1)
  field(:CURT_HEALTH, 2)
  field(:CONCISE_HEALTH, 3)
  field(:FULL_HEALTH, 4)
  field(:SHAPE, 5)
  field(:FULL_NUMERICS, 6)
  field(:FULL_TENSOR, 7)
  field(:REDUCE_INF_NAN_THREE_SLOTS, 8)
end

defmodule Tensorflow.DebugEvent do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          what: {atom, any},
          wall_time: float | :infinity | :negative_infinity | :nan,
          step: integer
        }
  defstruct [:what, :wall_time, :step]

  oneof(:what, 0)
  field(:wall_time, 1, type: :double)
  field(:step, 2, type: :int64)
  field(:debug_metadata, 3, type: Tensorflow.DebugMetadata, oneof: 0)
  field(:source_file, 4, type: Tensorflow.SourceFile, oneof: 0)
  field(:stack_frame_with_id, 6, type: Tensorflow.StackFrameWithId, oneof: 0)
  field(:graph_op_creation, 7, type: Tensorflow.GraphOpCreation, oneof: 0)
  field(:debugged_graph, 8, type: Tensorflow.DebuggedGraph, oneof: 0)
  field(:execution, 9, type: Tensorflow.Execution, oneof: 0)

  field(:graph_execution_trace, 10,
    type: Tensorflow.GraphExecutionTrace,
    oneof: 0
  )

  field(:graph_id, 11, type: :string, oneof: 0)
  field(:debugged_device, 12, type: Tensorflow.DebuggedDevice, oneof: 0)
end

defmodule Tensorflow.DebugMetadata do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          tensorflow_version: String.t(),
          file_version: String.t(),
          tfdbg_run_id: String.t()
        }
  defstruct [:tensorflow_version, :file_version, :tfdbg_run_id]

  field(:tensorflow_version, 1, type: :string)
  field(:file_version, 2, type: :string)
  field(:tfdbg_run_id, 3, type: :string)
end

defmodule Tensorflow.SourceFile do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          file_path: String.t(),
          host_name: String.t(),
          lines: [String.t()]
        }
  defstruct [:file_path, :host_name, :lines]

  field(:file_path, 1, type: :string)
  field(:host_name, 2, type: :string)
  field(:lines, 3, repeated: true, type: :string)
end

defmodule Tensorflow.StackFrameWithId do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          id: String.t(),
          file_line_col: Tensorflow.GraphDebugInfo.FileLineCol.t() | nil
        }
  defstruct [:id, :file_line_col]

  field(:id, 1, type: :string)
  field(:file_line_col, 2, type: Tensorflow.GraphDebugInfo.FileLineCol)
end

defmodule Tensorflow.CodeLocation do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          host_name: String.t(),
          stack_frame_ids: [String.t()]
        }
  defstruct [:host_name, :stack_frame_ids]

  field(:host_name, 1, type: :string)
  field(:stack_frame_ids, 2, repeated: true, type: :string)
end

defmodule Tensorflow.GraphOpCreation do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          op_type: String.t(),
          op_name: String.t(),
          graph_name: String.t(),
          graph_id: String.t(),
          device_name: String.t(),
          input_names: [String.t()],
          num_outputs: integer,
          code_location: Tensorflow.CodeLocation.t() | nil,
          output_tensor_ids: [integer]
        }
  defstruct [
    :op_type,
    :op_name,
    :graph_name,
    :graph_id,
    :device_name,
    :input_names,
    :num_outputs,
    :code_location,
    :output_tensor_ids
  ]

  field(:op_type, 1, type: :string)
  field(:op_name, 2, type: :string)
  field(:graph_name, 3, type: :string)
  field(:graph_id, 4, type: :string)
  field(:device_name, 5, type: :string)
  field(:input_names, 6, repeated: true, type: :string)
  field(:num_outputs, 7, type: :int32)
  field(:code_location, 8, type: Tensorflow.CodeLocation)
  field(:output_tensor_ids, 9, repeated: true, type: :int32)
end

defmodule Tensorflow.DebuggedGraph do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          graph_id: String.t(),
          graph_name: String.t(),
          instrumented_ops: [String.t()],
          original_graph_def: binary,
          instrumented_graph_def: binary,
          outer_context_id: String.t()
        }
  defstruct [
    :graph_id,
    :graph_name,
    :instrumented_ops,
    :original_graph_def,
    :instrumented_graph_def,
    :outer_context_id
  ]

  field(:graph_id, 1, type: :string)
  field(:graph_name, 2, type: :string)
  field(:instrumented_ops, 3, repeated: true, type: :string)
  field(:original_graph_def, 4, type: :bytes)
  field(:instrumented_graph_def, 5, type: :bytes)
  field(:outer_context_id, 6, type: :string)
end

defmodule Tensorflow.DebuggedDevice do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          device_name: String.t(),
          device_id: integer
        }
  defstruct [:device_name, :device_id]

  field(:device_name, 1, type: :string)
  field(:device_id, 2, type: :int32)
end

defmodule Tensorflow.Execution do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          op_type: String.t(),
          num_outputs: integer,
          graph_id: String.t(),
          input_tensor_ids: [integer],
          output_tensor_ids: [integer],
          tensor_debug_mode: Tensorflow.TensorDebugMode.t(),
          tensor_protos: [Tensorflow.TensorProto.t()],
          code_location: Tensorflow.CodeLocation.t() | nil,
          output_tensor_device_ids: [integer]
        }
  defstruct [
    :op_type,
    :num_outputs,
    :graph_id,
    :input_tensor_ids,
    :output_tensor_ids,
    :tensor_debug_mode,
    :tensor_protos,
    :code_location,
    :output_tensor_device_ids
  ]

  field(:op_type, 1, type: :string)
  field(:num_outputs, 2, type: :int32)
  field(:graph_id, 3, type: :string)
  field(:input_tensor_ids, 4, repeated: true, type: :int64)
  field(:output_tensor_ids, 5, repeated: true, type: :int64)
  field(:tensor_debug_mode, 6, type: Tensorflow.TensorDebugMode, enum: true)
  field(:tensor_protos, 7, repeated: true, type: Tensorflow.TensorProto)
  field(:code_location, 8, type: Tensorflow.CodeLocation)
  field(:output_tensor_device_ids, 9, repeated: true, type: :int32)
end

defmodule Tensorflow.GraphExecutionTrace do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          tfdbg_context_id: String.t(),
          op_name: String.t(),
          output_slot: integer,
          tensor_debug_mode: Tensorflow.TensorDebugMode.t(),
          tensor_proto: Tensorflow.TensorProto.t() | nil,
          device_name: String.t()
        }
  defstruct [
    :tfdbg_context_id,
    :op_name,
    :output_slot,
    :tensor_debug_mode,
    :tensor_proto,
    :device_name
  ]

  field(:tfdbg_context_id, 1, type: :string)
  field(:op_name, 2, type: :string)
  field(:output_slot, 3, type: :int32)
  field(:tensor_debug_mode, 4, type: Tensorflow.TensorDebugMode, enum: true)
  field(:tensor_proto, 5, type: Tensorflow.TensorProto)
  field(:device_name, 6, type: :string)
end

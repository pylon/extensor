defmodule Tensorflow.GraphTransferNodeInput do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          node_id: integer,
          output_port: integer
        }
  defstruct [:node_id, :output_port]

  field(:node_id, 1, type: :int32)
  field(:output_port, 2, type: :int32)
end

defmodule Tensorflow.GraphTransferNodeInfo do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          node_id: integer,
          type_name: String.t(),
          soc_op_id: integer,
          padding_id: integer,
          input_count: integer,
          output_count: integer
        }
  defstruct [
    :name,
    :node_id,
    :type_name,
    :soc_op_id,
    :padding_id,
    :input_count,
    :output_count
  ]

  field(:name, 1, type: :string)
  field(:node_id, 2, type: :int32)
  field(:type_name, 3, type: :string)
  field(:soc_op_id, 4, type: :int32)
  field(:padding_id, 5, type: :int32)
  field(:input_count, 6, type: :int32)
  field(:output_count, 7, type: :int32)
end

defmodule Tensorflow.GraphTransferConstNodeInfo do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          node_id: integer,
          shape: [integer],
          data: String.t(),
          dtype: integer
        }
  defstruct [:name, :node_id, :shape, :data, :dtype]

  field(:name, 1, type: :string)
  field(:node_id, 2, type: :int32)
  field(:shape, 3, repeated: true, type: :int64)
  field(:data, 4, type: :bytes)
  field(:dtype, 5, type: Tensorflow.DataType, enum: true)
end

defmodule Tensorflow.GraphTransferNodeInputInfo do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          node_id: integer,
          node_input: [Tensorflow.GraphTransferNodeInput.t()]
        }
  defstruct [:node_id, :node_input]

  field(:node_id, 1, type: :int32)

  field(
    :node_input,
    2,
    repeated: true,
    type: Tensorflow.GraphTransferNodeInput
  )
end

defmodule Tensorflow.GraphTransferNodeOutputInfo do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          node_id: integer,
          max_byte_size: [integer]
        }
  defstruct [:node_id, :max_byte_size]

  field(:node_id, 1, type: :int32)
  field(:max_byte_size, 2, repeated: true, type: :int32)
end

defmodule Tensorflow.GraphTransferGraphInputNodeInfo do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          shape: [integer],
          dtype: integer
        }
  defstruct [:name, :shape, :dtype]

  field(:name, 1, type: :string)
  field(:shape, 2, repeated: true, type: :int64)
  field(:dtype, 3, type: Tensorflow.DataType, enum: true)
end

defmodule Tensorflow.GraphTransferGraphOutputNodeInfo do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          shape: [integer],
          dtype: integer
        }
  defstruct [:name, :shape, :dtype]

  field(:name, 1, type: :string)
  field(:shape, 2, repeated: true, type: :int64)
  field(:dtype, 3, type: Tensorflow.DataType, enum: true)
end

defmodule Tensorflow.GraphTransferInfo do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          node_info: [Tensorflow.GraphTransferNodeInfo.t()],
          const_node_info: [Tensorflow.GraphTransferConstNodeInfo.t()],
          node_input_info: [Tensorflow.GraphTransferNodeInputInfo.t()],
          node_output_info: [Tensorflow.GraphTransferNodeOutputInfo.t()],
          graph_input_node_info: [
            Tensorflow.GraphTransferGraphInputNodeInfo.t()
          ],
          graph_output_node_info: [
            Tensorflow.GraphTransferGraphOutputNodeInfo.t()
          ],
          destination: integer
        }
  defstruct [
    :node_info,
    :const_node_info,
    :node_input_info,
    :node_output_info,
    :graph_input_node_info,
    :graph_output_node_info,
    :destination
  ]

  field(:node_info, 1, repeated: true, type: Tensorflow.GraphTransferNodeInfo)

  field(
    :const_node_info,
    2,
    repeated: true,
    type: Tensorflow.GraphTransferConstNodeInfo
  )

  field(
    :node_input_info,
    3,
    repeated: true,
    type: Tensorflow.GraphTransferNodeInputInfo
  )

  field(
    :node_output_info,
    4,
    repeated: true,
    type: Tensorflow.GraphTransferNodeOutputInfo
  )

  field(
    :graph_input_node_info,
    5,
    repeated: true,
    type: Tensorflow.GraphTransferGraphInputNodeInfo
  )

  field(
    :graph_output_node_info,
    6,
    repeated: true,
    type: Tensorflow.GraphTransferGraphOutputNodeInfo
  )

  field(
    :destination,
    7,
    type: Tensorflow.GraphTransferInfo.Destination,
    enum: true
  )
end

defmodule Tensorflow.GraphTransferInfo.Destination do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  field(:NOP, 0)
  field(:HEXAGON, 1)
end

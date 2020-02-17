defmodule Tensorflow.RemoteFusedGraphExecuteInfo.TensorShapeTypeProto do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          dtype: Tensorflow.DataType.t(),
          shape: Tensorflow.TensorShapeProto.t() | nil
        }
  defstruct [:dtype, :shape]

  field(:dtype, 1, type: Tensorflow.DataType, enum: true)
  field(:shape, 2, type: Tensorflow.TensorShapeProto)
end

defmodule Tensorflow.RemoteFusedGraphExecuteInfo do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          remote_graph: Tensorflow.GraphDef.t() | nil,
          graph_input_node_name: [String.t()],
          graph_output_node_name: [String.t()],
          executor_name: String.t(),
          serialized_executor_parameters: binary,
          default_graph_input_tensor_shape: [
            Tensorflow.RemoteFusedGraphExecuteInfo.TensorShapeTypeProto.t()
          ],
          default_graph_output_tensor_shape: [
            Tensorflow.RemoteFusedGraphExecuteInfo.TensorShapeTypeProto.t()
          ]
        }
  defstruct [
    :remote_graph,
    :graph_input_node_name,
    :graph_output_node_name,
    :executor_name,
    :serialized_executor_parameters,
    :default_graph_input_tensor_shape,
    :default_graph_output_tensor_shape
  ]

  field(:remote_graph, 1, type: Tensorflow.GraphDef)
  field(:graph_input_node_name, 2, repeated: true, type: :string)
  field(:graph_output_node_name, 3, repeated: true, type: :string)
  field(:executor_name, 4, type: :string)
  field(:serialized_executor_parameters, 5, type: :bytes)

  field(:default_graph_input_tensor_shape, 6,
    repeated: true,
    type: Tensorflow.RemoteFusedGraphExecuteInfo.TensorShapeTypeProto
  )

  field(:default_graph_output_tensor_shape, 7,
    repeated: true,
    type: Tensorflow.RemoteFusedGraphExecuteInfo.TensorShapeTypeProto
  )
end

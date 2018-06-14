defmodule Tensorflow.CheckpointableObjectGraph do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          nodes: [
            Tensorflow.CheckpointableObjectGraph.CheckpointableObject.t()
          ]
        }
  defstruct [:nodes]

  field(
    :nodes,
    1,
    repeated: true,
    type: Tensorflow.CheckpointableObjectGraph.CheckpointableObject
  )
end

defmodule Tensorflow.CheckpointableObjectGraph.CheckpointableObject do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          children: [
            Tensorflow.CheckpointableObjectGraph.CheckpointableObject.ObjectReference.t()
          ],
          attributes: [
            Tensorflow.CheckpointableObjectGraph.CheckpointableObject.SerializedTensor.t()
          ],
          slot_variables: [
            Tensorflow.CheckpointableObjectGraph.CheckpointableObject.SlotVariableReference.t()
          ]
        }
  defstruct [:children, :attributes, :slot_variables]

  field(
    :children,
    1,
    repeated: true,
    type:
      Tensorflow.CheckpointableObjectGraph.CheckpointableObject.ObjectReference
  )

  field(
    :attributes,
    2,
    repeated: true,
    type:
      Tensorflow.CheckpointableObjectGraph.CheckpointableObject.SerializedTensor
  )

  field(
    :slot_variables,
    3,
    repeated: true,
    type:
      Tensorflow.CheckpointableObjectGraph.CheckpointableObject.SlotVariableReference
  )
end

defmodule Tensorflow.CheckpointableObjectGraph.CheckpointableObject.ObjectReference do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          node_id: integer,
          local_name: String.t()
        }
  defstruct [:node_id, :local_name]

  field(:node_id, 1, type: :int32)
  field(:local_name, 2, type: :string)
end

defmodule Tensorflow.CheckpointableObjectGraph.CheckpointableObject.SerializedTensor do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          full_name: String.t(),
          checkpoint_key: String.t()
        }
  defstruct [:name, :full_name, :checkpoint_key]

  field(:name, 1, type: :string)
  field(:full_name, 2, type: :string)
  field(:checkpoint_key, 3, type: :string)
end

defmodule Tensorflow.CheckpointableObjectGraph.CheckpointableObject.SlotVariableReference do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          original_variable_node_id: integer,
          slot_name: String.t(),
          slot_variable_node_id: integer
        }
  defstruct [:original_variable_node_id, :slot_name, :slot_variable_node_id]

  field(:original_variable_node_id, 1, type: :int32)
  field(:slot_name, 2, type: :string)
  field(:slot_variable_node_id, 3, type: :int32)
end

defmodule Tensorflow.TrackableObjectGraph.TrackableObject.ObjectReference do
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

defmodule Tensorflow.TrackableObjectGraph.TrackableObject.SerializedTensor do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          full_name: String.t(),
          checkpoint_key: String.t(),
          optional_restore: boolean
        }
  defstruct [:name, :full_name, :checkpoint_key, :optional_restore]

  field(:name, 1, type: :string)
  field(:full_name, 2, type: :string)
  field(:checkpoint_key, 3, type: :string)
  field(:optional_restore, 4, type: :bool)
end

defmodule Tensorflow.TrackableObjectGraph.TrackableObject.SlotVariableReference do
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

defmodule Tensorflow.TrackableObjectGraph.TrackableObject do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          children: [
            Tensorflow.TrackableObjectGraph.TrackableObject.ObjectReference.t()
          ],
          attributes: [
            Tensorflow.TrackableObjectGraph.TrackableObject.SerializedTensor.t()
          ],
          slot_variables: [
            Tensorflow.TrackableObjectGraph.TrackableObject.SlotVariableReference.t()
          ]
        }
  defstruct [:children, :attributes, :slot_variables]

  field(:children, 1,
    repeated: true,
    type: Tensorflow.TrackableObjectGraph.TrackableObject.ObjectReference
  )

  field(:attributes, 2,
    repeated: true,
    type: Tensorflow.TrackableObjectGraph.TrackableObject.SerializedTensor
  )

  field(:slot_variables, 3,
    repeated: true,
    type:
      Tensorflow.TrackableObjectGraph.TrackableObject.SlotVariableReference
  )
end

defmodule Tensorflow.TrackableObjectGraph do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          nodes: [Tensorflow.TrackableObjectGraph.TrackableObject.t()]
        }
  defstruct [:nodes]

  field(:nodes, 1,
    repeated: true,
    type: Tensorflow.TrackableObjectGraph.TrackableObject
  )
end

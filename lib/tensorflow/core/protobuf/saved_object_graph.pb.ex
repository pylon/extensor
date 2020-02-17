defmodule Tensorflow.SavedObjectGraph.ConcreteFunctionsEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: Tensorflow.SavedConcreteFunction.t() | nil
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: Tensorflow.SavedConcreteFunction)
end

defmodule Tensorflow.SavedObjectGraph do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          nodes: [Tensorflow.SavedObject.t()],
          concrete_functions: %{
            String.t() => Tensorflow.SavedConcreteFunction.t() | nil
          }
        }
  defstruct [:nodes, :concrete_functions]

  field(:nodes, 1, repeated: true, type: Tensorflow.SavedObject)

  field(:concrete_functions, 2,
    repeated: true,
    type: Tensorflow.SavedObjectGraph.ConcreteFunctionsEntry,
    map: true
  )
end

defmodule Tensorflow.SavedObject do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          kind: {atom, any},
          children: [
            Tensorflow.TrackableObjectGraph.TrackableObject.ObjectReference.t()
          ],
          slot_variables: [
            Tensorflow.TrackableObjectGraph.TrackableObject.SlotVariableReference.t()
          ]
        }
  defstruct [:kind, :children, :slot_variables]

  oneof(:kind, 0)

  field(:children, 1,
    repeated: true,
    type: Tensorflow.TrackableObjectGraph.TrackableObject.ObjectReference
  )

  field(:slot_variables, 3,
    repeated: true,
    type:
      Tensorflow.TrackableObjectGraph.TrackableObject.SlotVariableReference
  )

  field(:user_object, 4, type: Tensorflow.SavedUserObject, oneof: 0)
  field(:asset, 5, type: Tensorflow.SavedAsset, oneof: 0)
  field(:function, 6, type: Tensorflow.SavedFunction, oneof: 0)
  field(:variable, 7, type: Tensorflow.SavedVariable, oneof: 0)

  field(:bare_concrete_function, 8,
    type: Tensorflow.SavedBareConcreteFunction,
    oneof: 0
  )

  field(:constant, 9, type: Tensorflow.SavedConstant, oneof: 0)
  field(:resource, 10, type: Tensorflow.SavedResource, oneof: 0)
end

defmodule Tensorflow.SavedUserObject do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          identifier: String.t(),
          version: Tensorflow.VersionDef.t() | nil,
          metadata: String.t()
        }
  defstruct [:identifier, :version, :metadata]

  field(:identifier, 1, type: :string)
  field(:version, 2, type: Tensorflow.VersionDef)
  field(:metadata, 3, type: :string)
end

defmodule Tensorflow.SavedAsset do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          asset_file_def_index: integer
        }
  defstruct [:asset_file_def_index]

  field(:asset_file_def_index, 1, type: :int32)
end

defmodule Tensorflow.SavedFunction do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          concrete_functions: [String.t()],
          function_spec: Tensorflow.FunctionSpec.t() | nil
        }
  defstruct [:concrete_functions, :function_spec]

  field(:concrete_functions, 1, repeated: true, type: :string)
  field(:function_spec, 2, type: Tensorflow.FunctionSpec)
end

defmodule Tensorflow.SavedConcreteFunction do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          bound_inputs: [integer],
          canonicalized_input_signature: Tensorflow.StructuredValue.t() | nil,
          output_signature: Tensorflow.StructuredValue.t() | nil
        }
  defstruct [:bound_inputs, :canonicalized_input_signature, :output_signature]

  field(:bound_inputs, 2, repeated: true, type: :int32)
  field(:canonicalized_input_signature, 3, type: Tensorflow.StructuredValue)
  field(:output_signature, 4, type: Tensorflow.StructuredValue)
end

defmodule Tensorflow.SavedBareConcreteFunction do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          concrete_function_name: String.t(),
          argument_keywords: [String.t()],
          allowed_positional_arguments: integer
        }
  defstruct [
    :concrete_function_name,
    :argument_keywords,
    :allowed_positional_arguments
  ]

  field(:concrete_function_name, 1, type: :string)
  field(:argument_keywords, 2, repeated: true, type: :string)
  field(:allowed_positional_arguments, 3, type: :int64)
end

defmodule Tensorflow.SavedConstant do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          operation: String.t()
        }
  defstruct [:operation]

  field(:operation, 1, type: :string)
end

defmodule Tensorflow.SavedVariable do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          dtype: Tensorflow.DataType.t(),
          shape: Tensorflow.TensorShapeProto.t() | nil,
          trainable: boolean,
          synchronization: Tensorflow.VariableSynchronization.t(),
          aggregation: Tensorflow.VariableAggregation.t(),
          name: String.t()
        }
  defstruct [
    :dtype,
    :shape,
    :trainable,
    :synchronization,
    :aggregation,
    :name
  ]

  field(:dtype, 1, type: Tensorflow.DataType, enum: true)
  field(:shape, 2, type: Tensorflow.TensorShapeProto)
  field(:trainable, 3, type: :bool)

  field(:synchronization, 4,
    type: Tensorflow.VariableSynchronization,
    enum: true
  )

  field(:aggregation, 5, type: Tensorflow.VariableAggregation, enum: true)
  field(:name, 6, type: :string)
end

defmodule Tensorflow.FunctionSpec do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          fullargspec: Tensorflow.StructuredValue.t() | nil,
          is_method: boolean,
          input_signature: Tensorflow.StructuredValue.t() | nil
        }
  defstruct [:fullargspec, :is_method, :input_signature]

  field(:fullargspec, 1, type: Tensorflow.StructuredValue)
  field(:is_method, 2, type: :bool)
  field(:input_signature, 5, type: Tensorflow.StructuredValue)
end

defmodule Tensorflow.SavedResource do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          device: String.t()
        }
  defstruct [:device]

  field(:device, 1, type: :string)
end

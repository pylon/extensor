defmodule Tensorflow.TypeSpecProto.TypeSpecClass do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  @type t ::
          integer
          | :UNKNOWN
          | :SPARSE_TENSOR_SPEC
          | :INDEXED_SLICES_SPEC
          | :RAGGED_TENSOR_SPEC
          | :TENSOR_ARRAY_SPEC
          | :DATA_DATASET_SPEC
          | :DATA_ITERATOR_SPEC
          | :OPTIONAL_SPEC
          | :PER_REPLICA_SPEC
          | :VARIABLE_SPEC

  field(:UNKNOWN, 0)
  field(:SPARSE_TENSOR_SPEC, 1)
  field(:INDEXED_SLICES_SPEC, 2)
  field(:RAGGED_TENSOR_SPEC, 3)
  field(:TENSOR_ARRAY_SPEC, 4)
  field(:DATA_DATASET_SPEC, 5)
  field(:DATA_ITERATOR_SPEC, 6)
  field(:OPTIONAL_SPEC, 7)
  field(:PER_REPLICA_SPEC, 8)
  field(:VARIABLE_SPEC, 9)
end

defmodule Tensorflow.StructuredValue do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          kind: {atom, any}
        }
  defstruct [:kind]

  oneof(:kind, 0)
  field(:none_value, 1, type: Tensorflow.NoneValue, oneof: 0)
  field(:float64_value, 11, type: :double, oneof: 0)
  field(:int64_value, 12, type: :sint64, oneof: 0)
  field(:string_value, 13, type: :string, oneof: 0)
  field(:bool_value, 14, type: :bool, oneof: 0)
  field(:tensor_shape_value, 31, type: Tensorflow.TensorShapeProto, oneof: 0)

  field(:tensor_dtype_value, 32,
    type: Tensorflow.DataType,
    enum: true,
    oneof: 0
  )

  field(:tensor_spec_value, 33, type: Tensorflow.TensorSpecProto, oneof: 0)
  field(:type_spec_value, 34, type: Tensorflow.TypeSpecProto, oneof: 0)
  field(:list_value, 51, type: Tensorflow.ListValue, oneof: 0)
  field(:tuple_value, 52, type: Tensorflow.TupleValue, oneof: 0)
  field(:dict_value, 53, type: Tensorflow.DictValue, oneof: 0)
  field(:named_tuple_value, 54, type: Tensorflow.NamedTupleValue, oneof: 0)
end

defmodule Tensorflow.NoneValue do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{}
  defstruct []
end

defmodule Tensorflow.ListValue do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          values: [Tensorflow.StructuredValue.t()]
        }
  defstruct [:values]

  field(:values, 1, repeated: true, type: Tensorflow.StructuredValue)
end

defmodule Tensorflow.TupleValue do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          values: [Tensorflow.StructuredValue.t()]
        }
  defstruct [:values]

  field(:values, 1, repeated: true, type: Tensorflow.StructuredValue)
end

defmodule Tensorflow.DictValue.FieldsEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: Tensorflow.StructuredValue.t() | nil
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: Tensorflow.StructuredValue)
end

defmodule Tensorflow.DictValue do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          fields: %{String.t() => Tensorflow.StructuredValue.t() | nil}
        }
  defstruct [:fields]

  field(:fields, 1,
    repeated: true,
    type: Tensorflow.DictValue.FieldsEntry,
    map: true
  )
end

defmodule Tensorflow.PairValue do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: Tensorflow.StructuredValue.t() | nil
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: Tensorflow.StructuredValue)
end

defmodule Tensorflow.NamedTupleValue do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          values: [Tensorflow.PairValue.t()]
        }
  defstruct [:name, :values]

  field(:name, 1, type: :string)
  field(:values, 2, repeated: true, type: Tensorflow.PairValue)
end

defmodule Tensorflow.TensorSpecProto do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          shape: Tensorflow.TensorShapeProto.t() | nil,
          dtype: Tensorflow.DataType.t()
        }
  defstruct [:name, :shape, :dtype]

  field(:name, 1, type: :string)
  field(:shape, 2, type: Tensorflow.TensorShapeProto)
  field(:dtype, 3, type: Tensorflow.DataType, enum: true)
end

defmodule Tensorflow.TypeSpecProto do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          type_spec_class: Tensorflow.TypeSpecProto.TypeSpecClass.t(),
          type_state: Tensorflow.StructuredValue.t() | nil,
          type_spec_class_name: String.t()
        }
  defstruct [:type_spec_class, :type_state, :type_spec_class_name]

  field(:type_spec_class, 1,
    type: Tensorflow.TypeSpecProto.TypeSpecClass,
    enum: true
  )

  field(:type_state, 2, type: Tensorflow.StructuredValue)
  field(:type_spec_class_name, 3, type: :string)
end

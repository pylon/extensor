defmodule Tensorflow.OpDef.ArgDef do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          description: String.t(),
          type: Tensorflow.DataType.t(),
          type_attr: String.t(),
          number_attr: String.t(),
          type_list_attr: String.t(),
          is_ref: boolean
        }
  defstruct [
    :name,
    :description,
    :type,
    :type_attr,
    :number_attr,
    :type_list_attr,
    :is_ref
  ]

  field(:name, 1, type: :string)
  field(:description, 2, type: :string)
  field(:type, 3, type: Tensorflow.DataType, enum: true)
  field(:type_attr, 4, type: :string)
  field(:number_attr, 5, type: :string)
  field(:type_list_attr, 6, type: :string)
  field(:is_ref, 16, type: :bool)
end

defmodule Tensorflow.OpDef.AttrDef do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          type: String.t(),
          default_value: Tensorflow.AttrValue.t() | nil,
          description: String.t(),
          has_minimum: boolean,
          minimum: integer,
          allowed_values: Tensorflow.AttrValue.t() | nil
        }
  defstruct [
    :name,
    :type,
    :default_value,
    :description,
    :has_minimum,
    :minimum,
    :allowed_values
  ]

  field(:name, 1, type: :string)
  field(:type, 2, type: :string)
  field(:default_value, 3, type: Tensorflow.AttrValue)
  field(:description, 4, type: :string)
  field(:has_minimum, 5, type: :bool)
  field(:minimum, 6, type: :int64)
  field(:allowed_values, 7, type: Tensorflow.AttrValue)
end

defmodule Tensorflow.OpDef do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          input_arg: [Tensorflow.OpDef.ArgDef.t()],
          output_arg: [Tensorflow.OpDef.ArgDef.t()],
          control_output: [String.t()],
          attr: [Tensorflow.OpDef.AttrDef.t()],
          deprecation: Tensorflow.OpDeprecation.t() | nil,
          summary: String.t(),
          description: String.t(),
          is_commutative: boolean,
          is_aggregate: boolean,
          is_stateful: boolean,
          allows_uninitialized_input: boolean
        }
  defstruct [
    :name,
    :input_arg,
    :output_arg,
    :control_output,
    :attr,
    :deprecation,
    :summary,
    :description,
    :is_commutative,
    :is_aggregate,
    :is_stateful,
    :allows_uninitialized_input
  ]

  field(:name, 1, type: :string)
  field(:input_arg, 2, repeated: true, type: Tensorflow.OpDef.ArgDef)
  field(:output_arg, 3, repeated: true, type: Tensorflow.OpDef.ArgDef)
  field(:control_output, 20, repeated: true, type: :string)
  field(:attr, 4, repeated: true, type: Tensorflow.OpDef.AttrDef)
  field(:deprecation, 8, type: Tensorflow.OpDeprecation)
  field(:summary, 5, type: :string)
  field(:description, 6, type: :string)
  field(:is_commutative, 18, type: :bool)
  field(:is_aggregate, 16, type: :bool)
  field(:is_stateful, 17, type: :bool)
  field(:allows_uninitialized_input, 19, type: :bool)
end

defmodule Tensorflow.OpDeprecation do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          version: integer,
          explanation: String.t()
        }
  defstruct [:version, :explanation]

  field(:version, 1, type: :int32)
  field(:explanation, 2, type: :string)
end

defmodule Tensorflow.OpList do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          op: [Tensorflow.OpDef.t()]
        }
  defstruct [:op]

  field(:op, 1, repeated: true, type: Tensorflow.OpDef)
end

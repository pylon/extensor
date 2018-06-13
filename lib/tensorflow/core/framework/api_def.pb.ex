defmodule Tensorflow.ApiDef do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          graph_op_name: String.t(),
          visibility: integer,
          endpoint: [Tensorflow.ApiDef.Endpoint.t()],
          in_arg: [Tensorflow.ApiDef.Arg.t()],
          out_arg: [Tensorflow.ApiDef.Arg.t()],
          arg_order: [String.t()],
          attr: [Tensorflow.ApiDef.Attr.t()],
          summary: String.t(),
          description: String.t(),
          description_prefix: String.t(),
          description_suffix: String.t()
        }
  defstruct [
    :graph_op_name,
    :visibility,
    :endpoint,
    :in_arg,
    :out_arg,
    :arg_order,
    :attr,
    :summary,
    :description,
    :description_prefix,
    :description_suffix
  ]

  field(:graph_op_name, 1, type: :string)
  field(:visibility, 2, type: Tensorflow.ApiDef.Visibility, enum: true)
  field(:endpoint, 3, repeated: true, type: Tensorflow.ApiDef.Endpoint)
  field(:in_arg, 4, repeated: true, type: Tensorflow.ApiDef.Arg)
  field(:out_arg, 5, repeated: true, type: Tensorflow.ApiDef.Arg)
  field(:arg_order, 11, repeated: true, type: :string)
  field(:attr, 6, repeated: true, type: Tensorflow.ApiDef.Attr)
  field(:summary, 7, type: :string)
  field(:description, 8, type: :string)
  field(:description_prefix, 9, type: :string)
  field(:description_suffix, 10, type: :string)
end

defmodule Tensorflow.ApiDef.Endpoint do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          deprecation_message: String.t()
        }
  defstruct [:name, :deprecation_message]

  field(:name, 1, type: :string)
  field(:deprecation_message, 2, type: :string)
end

defmodule Tensorflow.ApiDef.Arg do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          rename_to: String.t(),
          description: String.t()
        }
  defstruct [:name, :rename_to, :description]

  field(:name, 1, type: :string)
  field(:rename_to, 2, type: :string)
  field(:description, 3, type: :string)
end

defmodule Tensorflow.ApiDef.Attr do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          rename_to: String.t(),
          default_value: Tensorflow.AttrValue.t(),
          description: String.t()
        }
  defstruct [:name, :rename_to, :default_value, :description]

  field(:name, 1, type: :string)
  field(:rename_to, 2, type: :string)
  field(:default_value, 3, type: Tensorflow.AttrValue)
  field(:description, 4, type: :string)
end

defmodule Tensorflow.ApiDef.Visibility do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  field(:DEFAULT_VISIBILITY, 0)
  field(:VISIBLE, 1)
  field(:SKIP, 2)
  field(:HIDDEN, 3)
end

defmodule Tensorflow.ApiDefs do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          op: [Tensorflow.ApiDef.t()]
        }
  defstruct [:op]

  field(:op, 1, repeated: true, type: Tensorflow.ApiDef)
end

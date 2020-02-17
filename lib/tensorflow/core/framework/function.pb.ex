defmodule Tensorflow.FunctionDefLibrary do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          function: [Tensorflow.FunctionDef.t()],
          gradient: [Tensorflow.GradientDef.t()]
        }
  defstruct [:function, :gradient]

  field(:function, 1, repeated: true, type: Tensorflow.FunctionDef)
  field(:gradient, 2, repeated: true, type: Tensorflow.GradientDef)
end

defmodule Tensorflow.FunctionDef.AttrEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: Tensorflow.AttrValue.t() | nil
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: Tensorflow.AttrValue)
end

defmodule Tensorflow.FunctionDef.ArgAttrs.AttrEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: Tensorflow.AttrValue.t() | nil
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: Tensorflow.AttrValue)
end

defmodule Tensorflow.FunctionDef.ArgAttrs do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          attr: %{String.t() => Tensorflow.AttrValue.t() | nil}
        }
  defstruct [:attr]

  field(:attr, 1,
    repeated: true,
    type: Tensorflow.FunctionDef.ArgAttrs.AttrEntry,
    map: true
  )
end

defmodule Tensorflow.FunctionDef.ArgAttrEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: non_neg_integer,
          value: Tensorflow.FunctionDef.ArgAttrs.t() | nil
        }
  defstruct [:key, :value]

  field(:key, 1, type: :uint32)
  field(:value, 2, type: Tensorflow.FunctionDef.ArgAttrs)
end

defmodule Tensorflow.FunctionDef.ResourceArgUniqueIdEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: non_neg_integer,
          value: non_neg_integer
        }
  defstruct [:key, :value]

  field(:key, 1, type: :uint32)
  field(:value, 2, type: :uint32)
end

defmodule Tensorflow.FunctionDef.RetEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: String.t()
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: :string)
end

defmodule Tensorflow.FunctionDef.ControlRetEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: String.t()
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: :string)
end

defmodule Tensorflow.FunctionDef do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          signature: Tensorflow.OpDef.t() | nil,
          attr: %{String.t() => Tensorflow.AttrValue.t() | nil},
          arg_attr: %{
            non_neg_integer => Tensorflow.FunctionDef.ArgAttrs.t() | nil
          },
          resource_arg_unique_id: %{non_neg_integer => non_neg_integer},
          node_def: [Tensorflow.NodeDef.t()],
          ret: %{String.t() => String.t()},
          control_ret: %{String.t() => String.t()}
        }
  defstruct [
    :signature,
    :attr,
    :arg_attr,
    :resource_arg_unique_id,
    :node_def,
    :ret,
    :control_ret
  ]

  field(:signature, 1, type: Tensorflow.OpDef)

  field(:attr, 5,
    repeated: true,
    type: Tensorflow.FunctionDef.AttrEntry,
    map: true
  )

  field(:arg_attr, 7,
    repeated: true,
    type: Tensorflow.FunctionDef.ArgAttrEntry,
    map: true
  )

  field(:resource_arg_unique_id, 8,
    repeated: true,
    type: Tensorflow.FunctionDef.ResourceArgUniqueIdEntry,
    map: true
  )

  field(:node_def, 3, repeated: true, type: Tensorflow.NodeDef)

  field(:ret, 4,
    repeated: true,
    type: Tensorflow.FunctionDef.RetEntry,
    map: true
  )

  field(:control_ret, 6,
    repeated: true,
    type: Tensorflow.FunctionDef.ControlRetEntry,
    map: true
  )
end

defmodule Tensorflow.GradientDef do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          function_name: String.t(),
          gradient_func: String.t()
        }
  defstruct [:function_name, :gradient_func]

  field(:function_name, 1, type: :string)
  field(:gradient_func, 2, type: :string)
end

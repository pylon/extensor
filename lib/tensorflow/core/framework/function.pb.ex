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

defmodule Tensorflow.FunctionDef do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          signature: Tensorflow.OpDef.t(),
          attr: %{String.t() => Tensorflow.AttrValue.t()},
          node_def: [Tensorflow.NodeDef.t()],
          ret: %{String.t() => String.t()}
        }
  defstruct [:signature, :attr, :node_def, :ret]

  field(:signature, 1, type: Tensorflow.OpDef)

  field(
    :attr,
    5,
    repeated: true,
    type: Tensorflow.FunctionDef.AttrEntry,
    map: true
  )

  field(:node_def, 3, repeated: true, type: Tensorflow.NodeDef)

  field(
    :ret,
    4,
    repeated: true,
    type: Tensorflow.FunctionDef.RetEntry,
    map: true
  )
end

defmodule Tensorflow.FunctionDef.AttrEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: Tensorflow.AttrValue.t()
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: Tensorflow.AttrValue)
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

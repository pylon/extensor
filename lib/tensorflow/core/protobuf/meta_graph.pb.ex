defmodule Tensorflow.MetaGraphDef.MetaInfoDef.FunctionAliasesEntry do
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

defmodule Tensorflow.MetaGraphDef.MetaInfoDef do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          meta_graph_version: String.t(),
          stripped_op_list: Tensorflow.OpList.t() | nil,
          any_info: Google.Protobuf.Any.t() | nil,
          tags: [String.t()],
          tensorflow_version: String.t(),
          tensorflow_git_version: String.t(),
          stripped_default_attrs: boolean,
          function_aliases: %{String.t() => String.t()}
        }
  defstruct [
    :meta_graph_version,
    :stripped_op_list,
    :any_info,
    :tags,
    :tensorflow_version,
    :tensorflow_git_version,
    :stripped_default_attrs,
    :function_aliases
  ]

  field(:meta_graph_version, 1, type: :string)
  field(:stripped_op_list, 2, type: Tensorflow.OpList)
  field(:any_info, 3, type: Google.Protobuf.Any)
  field(:tags, 4, repeated: true, type: :string)
  field(:tensorflow_version, 5, type: :string)
  field(:tensorflow_git_version, 6, type: :string)
  field(:stripped_default_attrs, 7, type: :bool)

  field(:function_aliases, 8,
    repeated: true,
    type: Tensorflow.MetaGraphDef.MetaInfoDef.FunctionAliasesEntry,
    map: true
  )
end

defmodule Tensorflow.MetaGraphDef.CollectionDefEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: Tensorflow.CollectionDef.t() | nil
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: Tensorflow.CollectionDef)
end

defmodule Tensorflow.MetaGraphDef.SignatureDefEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: Tensorflow.SignatureDef.t() | nil
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: Tensorflow.SignatureDef)
end

defmodule Tensorflow.MetaGraphDef do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          meta_info_def: Tensorflow.MetaGraphDef.MetaInfoDef.t() | nil,
          graph_def: Tensorflow.GraphDef.t() | nil,
          saver_def: Tensorflow.SaverDef.t() | nil,
          collection_def: %{String.t() => Tensorflow.CollectionDef.t() | nil},
          signature_def: %{String.t() => Tensorflow.SignatureDef.t() | nil},
          asset_file_def: [Tensorflow.AssetFileDef.t()],
          object_graph_def: Tensorflow.SavedObjectGraph.t() | nil
        }
  defstruct [
    :meta_info_def,
    :graph_def,
    :saver_def,
    :collection_def,
    :signature_def,
    :asset_file_def,
    :object_graph_def
  ]

  field(:meta_info_def, 1, type: Tensorflow.MetaGraphDef.MetaInfoDef)
  field(:graph_def, 2, type: Tensorflow.GraphDef)
  field(:saver_def, 3, type: Tensorflow.SaverDef)

  field(:collection_def, 4,
    repeated: true,
    type: Tensorflow.MetaGraphDef.CollectionDefEntry,
    map: true
  )

  field(:signature_def, 5,
    repeated: true,
    type: Tensorflow.MetaGraphDef.SignatureDefEntry,
    map: true
  )

  field(:asset_file_def, 6, repeated: true, type: Tensorflow.AssetFileDef)
  field(:object_graph_def, 7, type: Tensorflow.SavedObjectGraph)
end

defmodule Tensorflow.CollectionDef.NodeList do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          value: [String.t()]
        }
  defstruct [:value]

  field(:value, 1, repeated: true, type: :string)
end

defmodule Tensorflow.CollectionDef.BytesList do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          value: [binary]
        }
  defstruct [:value]

  field(:value, 1, repeated: true, type: :bytes)
end

defmodule Tensorflow.CollectionDef.Int64List do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          value: [integer]
        }
  defstruct [:value]

  field(:value, 1, repeated: true, type: :int64, packed: true)
end

defmodule Tensorflow.CollectionDef.FloatList do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          value: [float | :infinity | :negative_infinity | :nan]
        }
  defstruct [:value]

  field(:value, 1, repeated: true, type: :float, packed: true)
end

defmodule Tensorflow.CollectionDef.AnyList do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          value: [Google.Protobuf.Any.t()]
        }
  defstruct [:value]

  field(:value, 1, repeated: true, type: Google.Protobuf.Any)
end

defmodule Tensorflow.CollectionDef do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          kind: {atom, any}
        }
  defstruct [:kind]

  oneof(:kind, 0)
  field(:node_list, 1, type: Tensorflow.CollectionDef.NodeList, oneof: 0)
  field(:bytes_list, 2, type: Tensorflow.CollectionDef.BytesList, oneof: 0)
  field(:int64_list, 3, type: Tensorflow.CollectionDef.Int64List, oneof: 0)
  field(:float_list, 4, type: Tensorflow.CollectionDef.FloatList, oneof: 0)
  field(:any_list, 5, type: Tensorflow.CollectionDef.AnyList, oneof: 0)
end

defmodule Tensorflow.TensorInfo.CooSparse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          values_tensor_name: String.t(),
          indices_tensor_name: String.t(),
          dense_shape_tensor_name: String.t()
        }
  defstruct [
    :values_tensor_name,
    :indices_tensor_name,
    :dense_shape_tensor_name
  ]

  field(:values_tensor_name, 1, type: :string)
  field(:indices_tensor_name, 2, type: :string)
  field(:dense_shape_tensor_name, 3, type: :string)
end

defmodule Tensorflow.TensorInfo.CompositeTensor do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          type_spec: Tensorflow.TypeSpecProto.t() | nil,
          components: [Tensorflow.TensorInfo.t()]
        }
  defstruct [:type_spec, :components]

  field(:type_spec, 1, type: Tensorflow.TypeSpecProto)
  field(:components, 2, repeated: true, type: Tensorflow.TensorInfo)
end

defmodule Tensorflow.TensorInfo do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          encoding: {atom, any},
          dtype: Tensorflow.DataType.t(),
          tensor_shape: Tensorflow.TensorShapeProto.t() | nil
        }
  defstruct [:encoding, :dtype, :tensor_shape]

  oneof(:encoding, 0)
  field(:name, 1, type: :string, oneof: 0)
  field(:coo_sparse, 4, type: Tensorflow.TensorInfo.CooSparse, oneof: 0)

  field(:composite_tensor, 5,
    type: Tensorflow.TensorInfo.CompositeTensor,
    oneof: 0
  )

  field(:dtype, 2, type: Tensorflow.DataType, enum: true)
  field(:tensor_shape, 3, type: Tensorflow.TensorShapeProto)
end

defmodule Tensorflow.SignatureDef.InputsEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: Tensorflow.TensorInfo.t() | nil
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: Tensorflow.TensorInfo)
end

defmodule Tensorflow.SignatureDef.OutputsEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: Tensorflow.TensorInfo.t() | nil
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: Tensorflow.TensorInfo)
end

defmodule Tensorflow.SignatureDef do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          inputs: %{String.t() => Tensorflow.TensorInfo.t() | nil},
          outputs: %{String.t() => Tensorflow.TensorInfo.t() | nil},
          method_name: String.t()
        }
  defstruct [:inputs, :outputs, :method_name]

  field(:inputs, 1,
    repeated: true,
    type: Tensorflow.SignatureDef.InputsEntry,
    map: true
  )

  field(:outputs, 2,
    repeated: true,
    type: Tensorflow.SignatureDef.OutputsEntry,
    map: true
  )

  field(:method_name, 3, type: :string)
end

defmodule Tensorflow.AssetFileDef do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          tensor_info: Tensorflow.TensorInfo.t() | nil,
          filename: String.t()
        }
  defstruct [:tensor_info, :filename]

  field(:tensor_info, 1, type: Tensorflow.TensorInfo)
  field(:filename, 2, type: :string)
end

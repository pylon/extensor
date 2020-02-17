defmodule Tensorflow.DataClass do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  @type t ::
          integer
          | :DATA_CLASS_UNKNOWN
          | :DATA_CLASS_SCALAR
          | :DATA_CLASS_TENSOR
          | :DATA_CLASS_BLOB_SEQUENCE

  field(:DATA_CLASS_UNKNOWN, 0)
  field(:DATA_CLASS_SCALAR, 1)
  field(:DATA_CLASS_TENSOR, 2)
  field(:DATA_CLASS_BLOB_SEQUENCE, 3)
end

defmodule Tensorflow.SummaryDescription do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          type_hint: String.t()
        }
  defstruct [:type_hint]

  field(:type_hint, 1, type: :string)
end

defmodule Tensorflow.HistogramProto do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          min: float | :infinity | :negative_infinity | :nan,
          max: float | :infinity | :negative_infinity | :nan,
          num: float | :infinity | :negative_infinity | :nan,
          sum: float | :infinity | :negative_infinity | :nan,
          sum_squares: float | :infinity | :negative_infinity | :nan,
          bucket_limit: [float | :infinity | :negative_infinity | :nan],
          bucket: [float | :infinity | :negative_infinity | :nan]
        }
  defstruct [:min, :max, :num, :sum, :sum_squares, :bucket_limit, :bucket]

  field(:min, 1, type: :double)
  field(:max, 2, type: :double)
  field(:num, 3, type: :double)
  field(:sum, 4, type: :double)
  field(:sum_squares, 5, type: :double)
  field(:bucket_limit, 6, repeated: true, type: :double, packed: true)
  field(:bucket, 7, repeated: true, type: :double, packed: true)
end

defmodule Tensorflow.SummaryMetadata.PluginData do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          plugin_name: String.t(),
          content: binary
        }
  defstruct [:plugin_name, :content]

  field(:plugin_name, 1, type: :string)
  field(:content, 2, type: :bytes)
end

defmodule Tensorflow.SummaryMetadata do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          plugin_data: Tensorflow.SummaryMetadata.PluginData.t() | nil,
          display_name: String.t(),
          summary_description: String.t(),
          data_class: Tensorflow.DataClass.t()
        }
  defstruct [:plugin_data, :display_name, :summary_description, :data_class]

  field(:plugin_data, 1, type: Tensorflow.SummaryMetadata.PluginData)
  field(:display_name, 2, type: :string)
  field(:summary_description, 3, type: :string)
  field(:data_class, 4, type: Tensorflow.DataClass, enum: true)
end

defmodule Tensorflow.Summary.Image do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          height: integer,
          width: integer,
          colorspace: integer,
          encoded_image_string: binary
        }
  defstruct [:height, :width, :colorspace, :encoded_image_string]

  field(:height, 1, type: :int32)
  field(:width, 2, type: :int32)
  field(:colorspace, 3, type: :int32)
  field(:encoded_image_string, 4, type: :bytes)
end

defmodule Tensorflow.Summary.Audio do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          sample_rate: float | :infinity | :negative_infinity | :nan,
          num_channels: integer,
          length_frames: integer,
          encoded_audio_string: binary,
          content_type: String.t()
        }
  defstruct [
    :sample_rate,
    :num_channels,
    :length_frames,
    :encoded_audio_string,
    :content_type
  ]

  field(:sample_rate, 1, type: :float)
  field(:num_channels, 2, type: :int64)
  field(:length_frames, 3, type: :int64)
  field(:encoded_audio_string, 4, type: :bytes)
  field(:content_type, 5, type: :string)
end

defmodule Tensorflow.Summary.Value do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          value: {atom, any},
          node_name: String.t(),
          tag: String.t(),
          metadata: Tensorflow.SummaryMetadata.t() | nil
        }
  defstruct [:value, :node_name, :tag, :metadata]

  oneof(:value, 0)
  field(:node_name, 7, type: :string)
  field(:tag, 1, type: :string)
  field(:metadata, 9, type: Tensorflow.SummaryMetadata)
  field(:simple_value, 2, type: :float, oneof: 0)
  field(:obsolete_old_style_histogram, 3, type: :bytes, oneof: 0)
  field(:image, 4, type: Tensorflow.Summary.Image, oneof: 0)
  field(:histo, 5, type: Tensorflow.HistogramProto, oneof: 0)
  field(:audio, 6, type: Tensorflow.Summary.Audio, oneof: 0)
  field(:tensor, 8, type: Tensorflow.TensorProto, oneof: 0)
end

defmodule Tensorflow.Summary do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          value: [Tensorflow.Summary.Value.t()]
        }
  defstruct [:value]

  field(:value, 1, repeated: true, type: Tensorflow.Summary.Value)
end

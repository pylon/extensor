defmodule StreamExecutor.Dnn.DataType do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  @type t :: integer | :kFloat | :kDouble | :kHalf | :kInt8 | :kInt32

  field(:kFloat, 0)
  field(:kDouble, 1)
  field(:kHalf, 2)
  field(:kInt8, 3)
  field(:kInt32, 4)
end

defmodule StreamExecutor.Dnn.DataLayout do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  @type t ::
          integer
          | :kYXDepthBatch
          | :kYXBatchDepth
          | :kBatchYXDepth
          | :kBatchDepthYX
          | :kBatchDepthYX4

  field(:kYXDepthBatch, 0)
  field(:kYXBatchDepth, 1)
  field(:kBatchYXDepth, 2)
  field(:kBatchDepthYX, 3)
  field(:kBatchDepthYX4, 4)
end

defmodule StreamExecutor.Dnn.FilterLayout do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  @type t ::
          integer
          | :kOutputInputYX
          | :kOutputYXInput
          | :kOutputInputYX4
          | :kInputYXOutput
          | :kYXInputOutput

  field(:kOutputInputYX, 0)
  field(:kOutputYXInput, 1)
  field(:kOutputInputYX4, 2)
  field(:kInputYXOutput, 3)
  field(:kYXInputOutput, 4)
end

defmodule StreamExecutor.Dnn.ActivationMode do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  @type t ::
          integer
          | :kNone
          | :kSigmoid
          | :kRelu
          | :kRelu6
          | :kReluX
          | :kTanh
          | :kBandPass

  field(:kNone, 0)
  field(:kSigmoid, 1)
  field(:kRelu, 2)
  field(:kRelu6, 3)
  field(:kReluX, 4)
  field(:kTanh, 5)
  field(:kBandPass, 6)
end

defmodule StreamExecutor.Dnn.ConvolutionMode do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  @type t :: integer | :CROSS_CORRELATION | :CONVOLUTION

  field(:CROSS_CORRELATION, 0)
  field(:CONVOLUTION, 1)
end

defmodule StreamExecutor.Dnn.ConvolutionKind do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  @type t ::
          integer
          | :INVALID
          | :FORWARD
          | :BACKWARD_FILTER
          | :BACKWARD_DATA
          | :FORWARD_BIAS_ACTIVATION

  field(:INVALID, 0)
  field(:FORWARD, 1)
  field(:BACKWARD_FILTER, 2)
  field(:BACKWARD_DATA, 3)
  field(:FORWARD_BIAS_ACTIVATION, 4)
end

defmodule StreamExecutor.Dnn.AlgorithmProto.MathType do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  @type t :: integer | :DEFAULT_MATH | :TENSOR_OP_MATH

  field(:DEFAULT_MATH, 0)
  field(:TENSOR_OP_MATH, 1)
end

defmodule StreamExecutor.Dnn.TensorDescriptorProto do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          layout_oneof: {atom, any},
          dimensions: [integer],
          data_type: StreamExecutor.Dnn.DataType.t()
        }
  defstruct [:layout_oneof, :dimensions, :data_type]

  oneof(:layout_oneof, 0)
  field(:dimensions, 1, repeated: true, type: :int64)
  field(:data_type, 2, type: StreamExecutor.Dnn.DataType, enum: true)

  field(:data_layout, 3,
    type: StreamExecutor.Dnn.DataLayout,
    enum: true,
    oneof: 0
  )

  field(:filter_layout, 4,
    type: StreamExecutor.Dnn.FilterLayout,
    enum: true,
    oneof: 0
  )
end

defmodule StreamExecutor.Dnn.AlgorithmProto do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          algo_id: integer,
          math_type: StreamExecutor.Dnn.AlgorithmProto.MathType.t()
        }
  defstruct [:algo_id, :math_type]

  field(:algo_id, 1, type: :int64)

  field(:math_type, 2,
    type: StreamExecutor.Dnn.AlgorithmProto.MathType,
    enum: true
  )
end

defmodule StreamExecutor.Dnn.ConvolutionDescriptorProto do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          paddings: [integer],
          strides: [integer],
          dilations: [integer],
          compute_mode: StreamExecutor.Dnn.DataType.t(),
          group_count: integer,
          convolution_mode: StreamExecutor.Dnn.ConvolutionMode.t(),
          name: String.t()
        }
  defstruct [
    :paddings,
    :strides,
    :dilations,
    :compute_mode,
    :group_count,
    :convolution_mode,
    :name
  ]

  field(:paddings, 1, repeated: true, type: :int64)
  field(:strides, 2, repeated: true, type: :int64)
  field(:dilations, 3, repeated: true, type: :int64)
  field(:compute_mode, 4, type: StreamExecutor.Dnn.DataType, enum: true)
  field(:group_count, 5, type: :int32)

  field(:convolution_mode, 6,
    type: StreamExecutor.Dnn.ConvolutionMode,
    enum: true
  )

  field(:name, 7, type: :string)
end

defmodule Tensorflow.ConvolutionProto do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          kind: StreamExecutor.Dnn.ConvolutionKind.t(),
          input: StreamExecutor.Dnn.TensorDescriptorProto.t() | nil,
          filter: StreamExecutor.Dnn.TensorDescriptorProto.t() | nil,
          output: StreamExecutor.Dnn.TensorDescriptorProto.t() | nil,
          conv_desc: StreamExecutor.Dnn.ConvolutionDescriptorProto.t() | nil,
          conv_scale: float | :infinity | :negative_infinity | :nan,
          side_value_scale: float | :infinity | :negative_infinity | :nan,
          activation: StreamExecutor.Dnn.ActivationMode.t(),
          input_address: integer,
          filter_address: integer,
          output_address: integer,
          bias_address: integer,
          side_input_address: integer
        }
  defstruct [
    :kind,
    :input,
    :filter,
    :output,
    :conv_desc,
    :conv_scale,
    :side_value_scale,
    :activation,
    :input_address,
    :filter_address,
    :output_address,
    :bias_address,
    :side_input_address
  ]

  field(:kind, 1, type: StreamExecutor.Dnn.ConvolutionKind, enum: true)
  field(:input, 2, type: StreamExecutor.Dnn.TensorDescriptorProto)
  field(:filter, 3, type: StreamExecutor.Dnn.TensorDescriptorProto)
  field(:output, 4, type: StreamExecutor.Dnn.TensorDescriptorProto)
  field(:conv_desc, 5, type: StreamExecutor.Dnn.ConvolutionDescriptorProto)
  field(:conv_scale, 6, type: :double)
  field(:side_value_scale, 7, type: :double)
  field(:activation, 8, type: StreamExecutor.Dnn.ActivationMode, enum: true)
  field(:input_address, 9, type: :int64)
  field(:filter_address, 10, type: :int64)
  field(:output_address, 11, type: :int64)
  field(:bias_address, 12, type: :int64)
  field(:side_input_address, 13, type: :int64)
end

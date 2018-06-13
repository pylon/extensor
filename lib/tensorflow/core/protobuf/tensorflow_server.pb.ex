defmodule Tensorflow.ServerDef do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          cluster: Tensorflow.ClusterDef.t(),
          job_name: String.t(),
          task_index: integer,
          default_session_config: Tensorflow.ConfigProto.t(),
          protocol: String.t()
        }
  defstruct [
    :cluster,
    :job_name,
    :task_index,
    :default_session_config,
    :protocol
  ]

  field(:cluster, 1, type: Tensorflow.ClusterDef)
  field(:job_name, 2, type: :string)
  field(:task_index, 3, type: :int32)
  field(:default_session_config, 4, type: Tensorflow.ConfigProto)
  field(:protocol, 5, type: :string)
end

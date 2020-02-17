defmodule Tensorflow.ServerDef do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          cluster: Tensorflow.ClusterDef.t() | nil,
          job_name: String.t(),
          task_index: integer,
          default_session_config: Tensorflow.ConfigProto.t() | nil,
          protocol: String.t(),
          port: integer,
          cluster_device_filters: Tensorflow.ClusterDeviceFilters.t() | nil
        }
  defstruct [
    :cluster,
    :job_name,
    :task_index,
    :default_session_config,
    :protocol,
    :port,
    :cluster_device_filters
  ]

  field(:cluster, 1, type: Tensorflow.ClusterDef)
  field(:job_name, 2, type: :string)
  field(:task_index, 3, type: :int32)
  field(:default_session_config, 4, type: Tensorflow.ConfigProto)
  field(:protocol, 5, type: :string)
  field(:port, 6, type: :int32)
  field(:cluster_device_filters, 7, type: Tensorflow.ClusterDeviceFilters)
end

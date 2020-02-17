defmodule Tensorflow.AutotuneResult.FailureKind do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  @type t :: integer | :UNKNOWN | :REDZONE_MODIFIED | :WRONG_RESULT

  field(:UNKNOWN, 0)
  field(:REDZONE_MODIFIED, 1)
  field(:WRONG_RESULT, 2)
end

defmodule Tensorflow.CudnnVersion do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          major: integer,
          minor: integer,
          patch: integer
        }
  defstruct [:major, :minor, :patch]

  field(:major, 1, type: :int32)
  field(:minor, 2, type: :int32)
  field(:patch, 3, type: :int32)
end

defmodule Tensorflow.ComputeCapability do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          major: integer,
          minor: integer
        }
  defstruct [:major, :minor]

  field(:major, 1, type: :int32)
  field(:minor, 2, type: :int32)
end

defmodule Tensorflow.AutotuneResult.FailureResult do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          key: {atom, any},
          kind: Tensorflow.AutotuneResult.FailureKind.t(),
          msg: String.t(),
          buffer_address: integer
        }
  defstruct [:key, :kind, :msg, :buffer_address]

  oneof(:key, 0)
  field(:kind, 1, type: Tensorflow.AutotuneResult.FailureKind, enum: true)
  field(:msg, 2, type: :string)

  field(:reference_conv, 11, type: Tensorflow.AutotuneResult.ConvKey, oneof: 0)

  field(:reference_gemm, 12, type: Tensorflow.AutotuneResult.GemmKey, oneof: 0)

  field(:buffer_address, 13, type: :int64)
end

defmodule Tensorflow.AutotuneResult.ConvKey do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          algorithm: integer,
          tensor_ops_enabled: boolean
        }
  defstruct [:algorithm, :tensor_ops_enabled]

  field(:algorithm, 1, type: :int64)
  field(:tensor_ops_enabled, 2, type: :bool)
end

defmodule Tensorflow.AutotuneResult.GemmKey do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          algorithm: integer
        }
  defstruct [:algorithm]

  field(:algorithm, 1, type: :int64)
end

defmodule Tensorflow.AutotuneResult do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          key: {atom, any},
          scratch_bytes: integer,
          run_time: Google.Protobuf.Duration.t() | nil,
          failure: Tensorflow.AutotuneResult.FailureResult.t() | nil
        }
  defstruct [:key, :scratch_bytes, :run_time, :failure]

  oneof(:key, 0)
  field(:scratch_bytes, 8, type: :int64)
  field(:run_time, 9, type: Google.Protobuf.Duration)
  field(:failure, 7, type: Tensorflow.AutotuneResult.FailureResult)
  field(:conv, 5, type: Tensorflow.AutotuneResult.ConvKey, oneof: 0)
  field(:gemm, 6, type: Tensorflow.AutotuneResult.GemmKey, oneof: 0)
end

defmodule Tensorflow.AutotuningLog do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          instr: Google.Protobuf.Any.t() | nil,
          results: [Tensorflow.AutotuneResult.t()],
          cudnn_version: Tensorflow.CudnnVersion.t() | nil,
          compute_capability: Tensorflow.ComputeCapability.t() | nil,
          device_pci_bus_id: String.t(),
          blas_version: String.t()
        }
  defstruct [
    :instr,
    :results,
    :cudnn_version,
    :compute_capability,
    :device_pci_bus_id,
    :blas_version
  ]

  field(:instr, 1, type: Google.Protobuf.Any)
  field(:results, 2, repeated: true, type: Tensorflow.AutotuneResult)
  field(:cudnn_version, 3, type: Tensorflow.CudnnVersion)
  field(:compute_capability, 4, type: Tensorflow.ComputeCapability)
  field(:device_pci_bus_id, 5, type: :string)
  field(:blas_version, 6, type: :string)
end

defmodule Tensorflow.NewReplaySession do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          devices: Tensorflow.ListDevicesResponse.t() | nil,
          session_handle: String.t()
        }
  defstruct [:devices, :session_handle]

  field(:devices, 1, type: Tensorflow.ListDevicesResponse)
  field(:session_handle, 2, type: :string)
end

defmodule Tensorflow.ReplayOp do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          op: {atom, any},
          response: {atom, any},
          start_time_us: float | :infinity | :negative_infinity | :nan,
          end_time_us: float | :infinity | :negative_infinity | :nan
        }
  defstruct [:op, :response, :start_time_us, :end_time_us]

  oneof(:op, 0)
  oneof(:response, 1)
  field(:start_time_us, 31, type: :double)
  field(:end_time_us, 32, type: :double)
  field(:create_session, 1, type: Tensorflow.CreateSessionRequest, oneof: 0)
  field(:extend_session, 2, type: Tensorflow.ExtendSessionRequest, oneof: 0)

  field(:partial_run_setup, 3,
    type: Tensorflow.PartialRunSetupRequest,
    oneof: 0
  )

  field(:run_step, 4, type: Tensorflow.RunStepRequest, oneof: 0)
  field(:close_session, 5, type: Tensorflow.CloseSessionRequest, oneof: 0)
  field(:list_devices, 6, type: Tensorflow.ListDevicesRequest, oneof: 0)
  field(:reset_request, 7, type: Tensorflow.ResetRequest, oneof: 0)
  field(:make_callable, 8, type: Tensorflow.MakeCallableRequest, oneof: 0)
  field(:run_callable, 9, type: Tensorflow.RunCallableRequest, oneof: 0)

  field(:release_callable, 10,
    type: Tensorflow.ReleaseCallableRequest,
    oneof: 0
  )

  field(:new_replay_session, 11, type: Tensorflow.NewReplaySession, oneof: 0)

  field(:create_session_response, 21,
    type: Tensorflow.CreateSessionResponse,
    oneof: 1
  )

  field(:extend_session_response, 22,
    type: Tensorflow.ExtendSessionResponse,
    oneof: 1
  )

  field(:partial_run_setup_response, 23,
    type: Tensorflow.PartialRunSetupResponse,
    oneof: 1
  )

  field(:run_step_response, 24, type: Tensorflow.RunStepResponse, oneof: 1)

  field(:close_session_response, 25,
    type: Tensorflow.CloseSessionResponse,
    oneof: 1
  )

  field(:list_devices_response, 26,
    type: Tensorflow.ListDevicesResponse,
    oneof: 1
  )

  field(:reset_request_response, 27, type: Tensorflow.ResetResponse, oneof: 1)

  field(:make_callable_response, 28,
    type: Tensorflow.MakeCallableResponse,
    oneof: 1
  )

  field(:run_callable_response, 29,
    type: Tensorflow.RunCallableResponse,
    oneof: 1
  )

  field(:release_callable_response, 30,
    type: Tensorflow.ReleaseCallableResponse,
    oneof: 1
  )
end

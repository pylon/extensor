defmodule Tensorflow.ReaderBaseState do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          work_started: integer,
          work_finished: integer,
          num_records_produced: integer,
          current_work: binary
        }
  defstruct [
    :work_started,
    :work_finished,
    :num_records_produced,
    :current_work
  ]

  field(:work_started, 1, type: :int64)
  field(:work_finished, 2, type: :int64)
  field(:num_records_produced, 3, type: :int64)
  field(:current_work, 4, type: :bytes)
end

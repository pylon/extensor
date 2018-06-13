defmodule Tensorflow.CriticalSectionDef do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          critical_section_name: String.t()
        }
  defstruct [:critical_section_name]

  field(:critical_section_name, 1, type: :string)
end

defmodule Tensorflow.CriticalSectionExecutionDef do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          execute_in_critical_section_name: String.t(),
          exclusive_resource_access: boolean
        }
  defstruct [:execute_in_critical_section_name, :exclusive_resource_access]

  field(:execute_in_critical_section_name, 1, type: :string)
  field(:exclusive_resource_access, 2, type: :bool)
end

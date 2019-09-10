defmodule Extensor.SessionTest do
  use ExUnit.Case, async: true

  alias Extensor.{Session, Tensor}
  alias Tensorflow.{ConfigProto, GPUOptions}

  setup_all do
    # disable tensorflow debug logging
    System.put_env("TF_CPP_MIN_LOG_LEVEL", "3")

    {:ok, []}
  end

  test "custom op kernel library" do
    # smoke test only, building a test kernel is outside extensor's scope
    {:error, _e} = Session.load_library("invalid")

    assert_raise ErlangError, ~r/tf_error/, fn ->
      Session.load_library!("invalid")
    end

    :ok = Session.load_library("priv/extensor.so")
    Session.load_library!("priv/extensor.so")
  end

  test "parse frozen graph" do
    config = %{
      ConfigProto.new()
      | gpu_options: %{GPUOptions.new() | allow_growth: true}
    }

    graph_def = File.read!("test/data/pythagoras.pb")

    # invalid protobuf
    {:error, _e} = Session.parse_frozen_graph("invalid_graph_def")

    assert_raise ErlangError, ~r/tf_error/, fn ->
      Session.parse_frozen_graph!("invalid_graph_def")
    end

    # valid protobuf
    {:ok, session} = Session.parse_frozen_graph(graph_def)
    assert is_reference(session)

    session = Session.parse_frozen_graph!(graph_def)
    assert is_reference(session)

    session = Session.parse_frozen_graph!(graph_def, config)
    assert is_reference(session)
  end

  test "load frozen graph file" do
    config = %{
      ConfigProto.new()
      | gpu_options: %{GPUOptions.new() | allow_growth: true}
    }

    graph_path = "test/data/pythagoras.pb"

    # invalid file path
    {:error, _e} = Session.load_frozen_graph("invalid_path")

    assert_raise File.Error, ~r/no such file/, fn ->
      Session.load_frozen_graph!("invalid_path")
    end

    # valid file path
    {:ok, session} = Session.load_frozen_graph(graph_path)
    assert is_reference(session)

    session = Session.load_frozen_graph!(graph_path)
    assert is_reference(session)

    session = Session.load_frozen_graph!(graph_path, config)
    assert is_reference(session)
  end

  test "load saved_model directory" do
    config = %{
      ConfigProto.new()
      | gpu_options: %{GPUOptions.new() | allow_growth: true}
    }

    model_path = "test/data/pythagoras"

    # invalid model path
    {:error, _e} = Session.load_saved_model("invalid_path")

    assert_raise ErlangError, ~r/tf_error/, fn ->
      Session.load_saved_model!("invalid_path")
    end

    # invalid serving tag
    {:error, _e} = Session.load_saved_model(model_path, config, "invalid_tag")

    assert_raise ErlangError, ~r/tf_error/, fn ->
      Session.load_saved_model!(model_path, config, "invalid_tag")
    end

    # valid model
    {:ok, session} = Session.load_saved_model(model_path)
    assert is_reference(session)

    session = Session.load_saved_model!(model_path)
    assert is_reference(session)

    session = Session.load_saved_model!(model_path, config)
    assert is_reference(session)

    session = Session.load_saved_model!(model_path, config, "serve")
    assert is_reference(session)
  end

  test "run session" do
    session = Session.load_frozen_graph!("test/data/pythagoras.pb")

    # missing input/output tensors
    input = %{
      "a" => Tensor.from_list([3]),
      "b" => Tensor.from_list([4])
    }

    {:error, _e} = Session.run(session, %{}, [])

    assert_raise ErlangError, ~r/tf_error/, fn ->
      Session.run!(session, %{}, [])
    end

    assert_raise ErlangError, ~r/tf_error/, fn ->
      Session.run!(session, input, [])
    end

    assert_raise ErlangError, ~r/tf_error/, fn ->
      Session.run!(session, %{}, ["c"])
    end

    # invalid tensor name
    assert_raise ErlangError, ~r/invalid_tensor_name/, fn ->
      Session.run!(session, Map.put(input, 42, Tensor.from_list([5])), ["c"])
    end

    assert_raise ErlangError, ~r/invalid_tensor_name/, fn ->
      Session.run!(session, input, [42])
    end

    assert_raise ErlangError, ~r/tensor_not_found.*missing_tensor/, fn ->
      Session.run!(session, input, ["missing_tensor"])
    end

    # invalid tensor shape
    input = %{
      "a" => Tensor.from_list([[1], [2, 3]]),
      "b" => Tensor.from_list([[4], [5, 6]])
    }

    assert_raise ArgumentError, ~r/tensor size mismatch/, fn ->
      Session.run!(session, input, ["c"])
    end

    # valid tensors
    input = %{
      "a:0" => Tensor.from_list([3]),
      "b:0" => Tensor.from_list([4])
    }

    {:ok, output} = Session.run(session, input, ["c:0"])
    assert Tensor.to_list(output["c:0"]) == [5]

    output = Session.run!(session, input, ["c:0"])
    assert Tensor.to_list(output["c:0"]) == [5]

    # default tensor name from op name
    input = %{
      "a" => Tensor.from_list([5]),
      "b" => Tensor.from_list([12])
    }

    output = Session.run!(session, input, ["c", "c:0"])
    assert Tensor.to_list(output["c"]) == [13]
    assert Tensor.to_list(output["c:0"]) == [13]

    # 1D tensor
    input = %{
      "a" => Tensor.from_list([3, 5]),
      "b" => Tensor.from_list([4, 12])
    }

    output = Session.run!(session, input, ["c", "c"])
    assert Tensor.to_list(output["c"]) == [5, 13]

    # 2D tensor
    input = %{
      "a" => Tensor.from_list([[3], [5]]),
      "b" => Tensor.from_list([[4], [12]])
    }

    output = Session.run!(session, input, ["c"])
    assert Tensor.to_list(output["c"]) == [[5], [13]]
  end

  test "global parallelism" do
    tasks =
      Task.async_stream(
        1..100,
        fn _i ->
          input = %{
            "a" => Tensor.from_list([5]),
            "b" => Tensor.from_list([12])
          }

          graph_def = File.read!("test/data/pythagoras.pb")
          session = Session.parse_frozen_graph!(graph_def)
          output = Session.run!(session, input, ["c"])
          assert Tensor.to_list(output["c"]) == [13]

          session = Session.load_saved_model!("test/data/pythagoras")
          output = Session.run!(session, input, ["c"])
          assert Tensor.to_list(output["c"]) == [13]
        end,
        ordered: false
      )

    Stream.run(tasks)
  end

  test "shared parallelism" do
    graph_def = File.read!("test/data/pythagoras.pb")
    session = Session.parse_frozen_graph!(graph_def)

    tasks =
      Task.async_stream(
        1..10_000,
        fn _i ->
          input = %{
            "a" => Tensor.from_list([5]),
            "b" => Tensor.from_list([12])
          }

          output = Session.run!(session, input, ["c"])
          assert Tensor.to_list(output["c"]) == [13]
        end,
        ordered: false
      )

    Stream.run(tasks)
  end

  @tag :stress
  test "frozen graph stress" do
    graph_def = File.read!("test/data/pythagoras.pb")

    for _ <- 1..120_000 do
      Session.parse_frozen_graph!(graph_def)
      :erlang.garbage_collect()
    end
  end

  @tag :stress
  test "saved_model stress" do
    for _ <- 1..60_000 do
      Session.load_saved_model!("test/data/pythagoras")
      :erlang.garbage_collect()
    end
  end

  @tag :stress
  test "run session stress" do
    session = Session.load_frozen_graph!("test/data/pythagoras.pb")

    input = %{
      "a" => Tensor.from_list(Enum.into(1..100, [])),
      "b" => Tensor.from_list(Enum.into(1..100, []))
    }

    for _ <- 1..1_000_000 do
      Session.run!(session, input, ["c"])
      :erlang.garbage_collect()
    end
  end
end

defmodule Qencode.TaskTest do
  @moduledoc false
  alias Qencode.Client
  alias Qencode.Task
  use ExUnit.Case
  doctest Qencode.Task

  @test_video_url "https://github.com/char0n/qencode/raw/master/test/data/test.mp4"

  describe "create/1: given valid request payload" do
    setup [:create_client]

    test "should create new task", %{client: client} do
      task = Task.create!(client)

      assert %{id: id, upload_url: upload_url} = task
      assert is_binary(id)
      assert is_binary(upload_url)
    end
  end

  describe "create/1: given invalid request payload" do
    test "should raise MatchError" do
      assert_raise FunctionClauseError, fn ->
        Task.create!(%{})
      end
    end
  end

  describe "start/1: given valid request payload" do
    setup [:create_client, :create_task1]

    test "should start encoding task", %{task1: task} do
      started_task = Task.start!(task)

      assert %{id: id, video_url: video_url, profiles: profiles, status_url: status_url} =
               started_task

      assert is_binary(id)
      assert is_binary(video_url)
      assert is_binary(profiles)
      assert is_binary(status_url)
    end

    test "should start encoding task using profiles from mix configuration", %{task1: task} do
      started_task =
        task
        |> Map.delete(:profiles)
        |> Task.start!()

      assert %{id: id, video_url: video_url, profiles: profiles, status_url: status_url} =
               started_task

      assert is_binary(id)
      assert is_binary(video_url)
      assert is_binary(profiles)
      assert is_binary(status_url)
    end
  end

  describe "start/2: given valid request payload" do
    setup [:create_client, :create_task1]

    test "should start encoding task", %{task1: task} do
      started_task = Task.start!(task, [])

      assert %{id: id, video_url: video_url, profiles: profiles, status_url: status_url} =
               started_task

      assert is_binary(id)
      assert is_binary(video_url)
      assert is_binary(profiles)
      assert is_binary(status_url)
    end
  end

  describe "status/1: given Task/Job id" do
    setup [:create_client, :create_task1]

    test "should return Task/Job status", %{task1: task} do
      started_task = Task.start!(task)
      task_status = Task.status!(started_task.id)

      assert %{"error" => error, "percent" => percent, "status" => status} = task_status
      assert error === 0
      assert percent >= 0
      assert is_binary(status)
    end
  end

  describe "status/1: given Task/Job ids" do
    setup [:create_client, :create_task1, :create_task2]

    test "should return Task1/Job1 status", %{task1: task1, task2: task2} do
      started_task1 = Task.start!(task1)
      started_task2 = Task.start!(task2)
      statuses = Task.status!([started_task1.id, started_task2.id])

      assert is_map(statuses[task1.id])
      assert is_map(statuses[task2.id])
    end
  end

  describe "status_full/2: given status url and Task/Job id" do
    setup [:create_client, :create_task1]

    test "should return full Task/Job status", %{task1: task} do
      %{id: id, status_url: status_url} = Task.start!(task)
      task_full_statuses = Task.status_full!(id, status_url)

      assert is_map(task_full_statuses[id])
    end
  end

  defp create_client(_context) do
    api_key = Application.get_env(:qencode, :api_key)
    client = Client.new!(api_key)
    %{client: client}
  end

  defp create_task1(%{client: client}) do
    task = Task.create!(client)

    task =
      task
      |> Map.put(:profiles, Application.get_env(:qencode, :profiles))
      |> Map.put(:video_url, @test_video_url)

    %{task1: task}
  end

  defp create_task2(context) do
    %{task1: task2} = create_task1(context)
    %{task2: task2}
  end
end

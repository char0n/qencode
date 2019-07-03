defmodule Qencode.TaskTest do
  @moduledoc false
  alias Qencode.Client
  alias Qencode.Task
  use ExUnit.Case
  doctest Qencode.Task

  @test_video_url "https://github.com/char0n/qencode/raw/master/test/data/test.mp4"

  describe "create: given valid request payload" do
    setup do
      api_key = System.get_env("QENCODE_API_KEY")
      client = Client.new!(api_key)
      %{client: client}
    end

    test "should create new task", %{client: client} do
      task = Task.create!(client)

      assert %{id: id, upload_url: upload_url} = task
      assert is_binary(id)
      assert is_binary(upload_url)
    end
  end

  describe "create: given invalid request payload" do
    test "should raise MatchError" do
      assert_raise MatchError, fn ->
        Task.create!(%{})
      end
    end
  end

  describe "start: given valid request payload" do
    setup do
      api_key = System.get_env("QENCODE_API_KEY")
      client = Client.new!(api_key)

      task = Task.create!(client)

      task =
        task
        |> Map.put(:profiles, System.get_env("QENCODE_PROFILES"))
        |> Map.put(:video_url, @test_video_url)

      %{task: task}
    end

    test "should start encoding task", %{task: task} do
      started_task = Task.start!(task)

      assert %{id: id, video_url: video_url, profiles: profiles, status_url: status_url} =
               started_task

      assert is_binary(id)
      assert is_binary(video_url)
      assert is_binary(profiles)
      assert is_binary(status_url)
    end
  end

  describe "status: given Task/Job id" do
    setup do
      api_key = System.get_env("QENCODE_API_KEY")
      client = Client.new!(api_key)

      task = Task.create!(client)

      task =
        task
        |> Map.put(:profiles, System.get_env("QENCODE_PROFILES"))
        |> Map.put(:video_url, @test_video_url)

      %{task: task}
    end

    test "should return Task/Job status", %{task: task} do
      started_task = Task.start!(task)
      task_status = Task.status!(started_task.id)

      assert %{"error" => error, "percent" => percent, "status" => status} = task_status
      assert error === 0
      assert percent >= 0
      assert is_binary(status)
    end
  end

  describe "status: given Task/Job ids" do
    setup do
      api_key = System.get_env("QENCODE_API_KEY")
      client = Client.new!(api_key)

      task1 = Task.create!(client)

      task1 =
        task1
        |> Map.put(:profiles, System.get_env("QENCODE_PROFILES"))
        |> Map.put(:video_url, @test_video_url)

      task2 = Task.create!(client)

      task2 =
        task2
        |> Map.put(:profiles, System.get_env("QENCODE_PROFILES"))
        |> Map.put(:video_url, @test_video_url)

      %{task1: task1, task2: task2}
    end

    test "should return Task1/Job1 status", %{task1: task1, task2: task2} do
      started_task1 = Task.start!(task1)
      started_task2 = Task.start!(task2)
      statuses = Task.status!([started_task1.id, started_task2.id])

      assert is_map(statuses[task1.id])
      assert is_map(statuses[task2.id])
    end
  end

  describe "status_full: given status url and Task/Job id" do
    setup do
      api_key = System.get_env("QENCODE_API_KEY")
      client = Client.new!(api_key)

      task = Task.create!(client)

      task =
        task
        |> Map.put(:profiles, System.get_env("QENCODE_PROFILES"))
        |> Map.put(:video_url, @test_video_url)

      %{task: task}
    end

    test "should return full Task/Job status", %{task: task} do
      %{id: id, status_url: status_url} = Task.start!(task)
      task_full_statuses = Task.status_full!(id, status_url)

      assert is_map(task_full_statuses[id])
    end
  end
end

defmodule Qencode.Task do
  @moduledoc """
  This module groups function for Qencode Task/Job manipulation.
  """

  require Logger

  import Qencode, only: [json_library: 0]

  alias Qencode.Client

  @doc """
  Creating a Task.
  Creates a transcoding job and returns it's token, which is needed to start transcoding jobs.
  """
  @spec create!(map) :: map
  def create!(%{session_token: session_token} = _client) do
    Logger.debug("Creating a new task")
    payload = [token: session_token]

    %{"task_token" => task_token, "upload_url" => upload_url} =
      Client.make_request!("/v1/create_task", payload)

    %{id: task_token, upload_url: upload_url}
  end

  @doc """
  Starting a Task using Profiles.
  Starts a transcoding Task/Job based on your selected presets.
  """

  def start!(
        data,
        opts \\ [transfer_method: Application.get_env(:qencode, :transfer_method, nil)]
      )

  @spec start!(map, keyword) :: map
  def start!(%{id: id, video_url: video_url, profiles: profiles}, opts) do
    Logger.debug("Starting a new Task(#{id})")
    payload = Keyword.merge([task_token: id, uri: video_url, profiles: profiles], opts)
    %{"status_url" => status_url} = Client.make_request!("/v1/start_encode", payload)
    %{id: id, video_url: video_url, profiles: profiles, status_url: status_url}
  end

  @spec start!(map, keyword) :: map
  def start!(data, opts) do
    profiles = Application.get_env(:qencode, :profiles, nil)

    if is_nil(profiles) do
      raise QencodeError, "Qencode profiles not provided by configuration"
    else
      start!(data |> Map.put(:profiles, profiles), opts)
    end
  end

  @doc "Gets status for one transcoding Task/Job."
  @spec status!(binary) :: map
  def status!(id) when is_binary(id) do
    statuses = status!([id])
    statuses[id]
  end

  @doc "Gets status for multiple transcoding Tasks/Jobs."
  @spec status!(list) :: map
  def status!(ids) when is_list(ids) do
    Logger.debug("Getting status of a Tasks(#{Enum.join(ids, ",")})")
    payload = ids |> Enum.map(fn id -> {:"task_tokens[]", id} end)
    response = Client.make_request!("/v1/status", payload)
    %{"statuses" => statuses} = response
    statuses
  end

  @doc "Gets full status for Task that is being processed."
  @spec status_full!(binary, binary) :: map
  def status_full!(id, status_url) when is_binary(id) and is_binary(status_url) do
    Logger.debug("Getting full status of a Task(#{id})")
    payload = [{:"task_tokens[]", id}]

    {:ok, response} =
      SimpleHttp.post(status_url,
        params: payload,
        headers: Client.headers()
      )

    %{"statuses" => statuses} = json_library().decode!(response.body)
    statuses
  end
end

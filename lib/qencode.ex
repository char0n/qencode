defmodule Qencode do
  require Logger

  @moduledoc """
  Qencode main module.
  """

  @api_host "api.qencode.com"
  @content_type "application/x-www-form-urlencoded"

  @doc """
  Getting Session Token.

  To get started, first access the Qencode API by acquiring a session token.
  You will pass this token as a param when you use the create task.
  """
  @spec get_session_token!(bitstring) :: bitstring
  def get_session_token!(api_key) when is_binary(api_key) do
    Logger.debug("Getting session token from API Key")
    {:ok, conn} = Mint.HTTP.connect(:https, @api_host, 443)

    {:ok, conn, request_ref} =
      Mint.HTTP.request(
        conn,
        "POST",
        "/v1/access_token",
        [{"content-type", @content_type}],
        URI.encode_query(%{"api_key" => api_key})
      )

    {:ok, _, responses} = receive_next_and_stream(conn)

    [
      {:status, ^request_ref, 200},
      _,
      {:data, ^request_ref, data},
      _
    ] = responses

    %{"token" => token, "error" => 0} = Poison.decode!(data)
    token
  end

  defp receive_next_and_stream(conn) do
    receive do
      message -> Mint.HTTP.stream(conn, message)
    end
  end
end

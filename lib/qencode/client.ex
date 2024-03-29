defmodule Qencode.Client do
  @moduledoc """
  This module represents client for this Qencode API wrapper.
  """
  require Logger

  import Qencode, only: [json_library: 0]

  @host "https://api.qencode.com"
  @headers %{
    "Content-Type" => "application/x-www-form-urlencoded"
  }

  @doc """
  Creating new data representation of Qencode client.
  Uses application configuration to get API key.
  """
  @spec new!() :: map
  def new!() do
    api_key = Application.get_env(:qencode, :api_key, nil)

    if is_nil(api_key) do
      raise QencodeError, "API key not provided by configuration"
    else
      new!(api_key)
    end
  end

  @doc """
  Creating new data representation of Qencode client.
  """
  @spec new!(bitstring) :: map
  def new!(api_key) when is_binary(api_key) do
    Logger.debug("Qencode: Getting session token from API Key")
    payload = [api_key: api_key]
    %{"token" => session_token, "error" => 0} = make_request!("/v1/access_token", payload)
    %{session_token: session_token}
  end

  @doc "Helper for making Qencode API calls"
  @spec make_request!(binary, keyword) :: any
  def make_request!(path, payload) do
    Logger.debug(
      "Qencode: POST Request to URL: #{@host}#{path} PARAMS: #{inspect(payload)} HEADERS: #{
        inspect(@headers)
      }"
    )

    {:ok, response} =
      SimpleHttp.post("#{@host}#{path}",
        params: payload,
        headers: @headers
      )

    json_library().decode!(response.body)
  end

  @doc "Helper for returning common request headers"
  @spec headers() :: map
  def headers, do: @headers
end

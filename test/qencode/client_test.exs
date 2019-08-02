defmodule Qencode.ClientTest do
  @moduledoc false
  alias Qencode.Client
  use ExUnit.Case
  doctest Qencode.Client

  describe "given valid api_key" do
    setup [:provide_api_key]

    test "should return access token", %{api_key: api_key} do
      client = Client.new!(api_key)

      assert %{session_token: session_token} = client
      assert is_binary(session_token)
      assert String.length(session_token) === 32
    end
  end

  describe "given api_key provided by mix configuration" do
    test "should return access token" do
      client = Client.new!()

      assert %{session_token: session_token} = client
      assert is_binary(session_token)
      assert String.length(session_token) === 32
    end
  end

  describe "given invalid api_key" do
    test "should raise MatchError" do
      assert_raise MatchError, fn ->
        Client.new!("invalid_api_key")
      end
    end
  end

  defp provide_api_key(_context) do
    api_key = Application.get_env(:qencode, :api_key)
    %{api_key: api_key}
  end
end

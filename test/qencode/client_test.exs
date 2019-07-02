defmodule Qencode.ClientTest do
  @moduledoc false
  alias Qencode.Client
  use ExUnit.Case
  doctest Qencode.Client

  describe "new: given valid api_key" do
    setup do
      api_key = System.get_env("QENCODE_API_KEY")
      %{api_key: api_key}
    end

    test "should return access token", %{api_key: api_key} do
      client = Client.new!(api_key)

      assert %{session_token: session_token} = client
      assert is_binary(session_token)
      assert String.length(session_token) === 32
    end
  end

  describe "get: given invalid api_key" do
    test "should raise MatchError" do
      assert_raise MatchError, fn ->
        Client.new!("invalid_api_key")
      end
    end
  end
end

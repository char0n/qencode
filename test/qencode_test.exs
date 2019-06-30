defmodule QencodeTest do
  use ExUnit.Case
  doctest Qencode

  describe "get_session_token: given valid api_key" do
    setup do
      api_key = System.get_env("QENCODE_API_KEY")
      assert(not is_nil(api_key), "missing QENCODE_API_KEY env variable")
      %{api_key: api_key}
    end

    test "should return session token", %{api_key: api_key} do
      session_token = Qencode.get_session_token!(api_key)

      assert is_binary(session_token)
      assert String.length(session_token) === 32
    end
  end

  describe "get_session_token: given invalid api_key" do
    test "should raise MatchError" do
      assert_raise MatchError, fn ->
        Qencode.get_session_token!("invalid_api_key")
      end
    end
  end
end

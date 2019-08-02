defmodule Qencode do
  @moduledoc "Entry point module of Qencode library"

  @doc "Returns the configured JSON encoding library for Qencode."
  def json_library do
    Application.get_env(:qencode, :json_library, Jason)
  end
end

defmodule QencodeError do
  defexception message: "Qencode error"
end
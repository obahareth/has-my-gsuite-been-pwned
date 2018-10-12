defmodule HasMyGsuiteBeenPwned.HaveIBeenPwnedTest do
  use ExUnit.Case
  import HasMyGsuiteBeenPwned.HaveIBeenPwned
  alias HasMyGsuiteBeenPwned.User

  test "pwned test" do
    u = %User{email: "bob@bob.com"}
    res = check_user(u)
    assert res == :ok
  end

  test "unpwned test" do
    u = %User{email: "jkjjkfjdsajfkd;jfkdsjfkdsj"}
    res = check_user(u)
    assert res == nil
  end
end

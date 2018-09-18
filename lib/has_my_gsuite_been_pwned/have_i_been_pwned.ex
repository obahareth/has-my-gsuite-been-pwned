defmodule HasMyGsuiteBeenPwned.HaveIBeenPwned do
  alias HasMyGsuiteBeenPwned.User

  def check_user(user = %User{}) do
    user.email
    |> ExPwned.Breaches.breachedaccount
  end
end
defmodule HasMyGsuiteBeenPwned.HaveIBeenPwned do
  @moduledoc """
  Wrapper for the ex_pwned allowing us to retry requests if they timeout
  """

  alias HasMyGsuiteBeenPwned.User

  def check_user(user = %User{}) do
    case ExPwned.Breaches.breachedaccount(user.email) do
      {:ok, breach_report, _ } ->
        breach_report
        |> Enum.each(&(get_simplified_breach_report(&1, user)))
      {:error, :rate, _msg, retry_after} ->
        :timer.sleep(retry_after * 1000)
         check_user(user)
    end
  end

  defp get_simplified_breach_report(report, user) do
    IO.inspect(report)

    if report == nil || report[:msg] do
      nil
    else
      %{
        "Name" => user.name,
        "Email" => user.email,
        "BreachDate" => report["BreachDate"],
        "DataClasses" => report["DataClasses"] |> Enum.join(", "),
        "Domain" => report["Domain"],
        "Title" => report["Title"]
      }
    end
  end
end

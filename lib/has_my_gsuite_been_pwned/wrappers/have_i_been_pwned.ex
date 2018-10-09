defmodule HasMyGsuiteBeenPwned.HaveIBeenPwned do
  @moduledoc """
  Wrapper for the ex_pwned allowing us to retry requests if they timeout
  """

  alias HasMyGsuiteBeenPwned.User

  def check_user(user = %User{}) do
    user.email
    |> ExPwned.Breaches.breachedaccount
  end

  def check_user_and_sleep(user = %User{}) do
    case check_user(user) do
      {:ok, breach_report, retry_after} ->
        if retry_after do
          # Sleep for retry_time + 150ms (to avoid getting hit by rate limit)
          sleep_time = (retry_after[:retry_after] * 1000) + 150
          :timer.sleep(sleep_time)
        end

        get_simplified_breach_report(breach_report, user)
      _ -> nil
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

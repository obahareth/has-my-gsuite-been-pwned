defmodule HasMyGsuiteBeenPwned.ReportGenerator do
  alias HasMyGsuiteBeenPwned.Google.Directory, as: DirectoryService
  alias HasMyGsuiteBeenPwned.HaveIBeenPwned, as: PwnedService

  def generate(oauth_client, _email) do
    get_breach_reports(oauth_client)
    |> build_csv
    |> IO.inspect
  end

  defp get_breach_reports(oauth_client) do
    DirectoryService.fetch_entire_directory(oauth_client)
    |> Enum.map(&PwnedService.check_user_and_sleep/1)
    |> Enum.filter(fn u -> u!= nil end)
  end

  defp build_csv(breach_reports) do
    breach_reports
    |> CSV.encode(headers: ["BreachDate",
                            "DataClasses",
                            "Domain",
                            "Title"])
  end
end
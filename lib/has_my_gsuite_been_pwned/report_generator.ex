defmodule HasMyGsuiteBeenPwned.ReportGenerator do
  @moduledoc """
  CSV report generator
  """

  alias HasMyGsuiteBeenPwned.Google.Directory, as: DirectoryService
  alias HasMyGsuiteBeenPwned.HaveIBeenPwned, as: PwnedService

  def generate(oauth_client, _email) do
    oauth_client
    |> get_breach_reports
    |> build_csv
    |> IO.inspect
  end

  defp get_breach_reports(oauth_client) do
    oauth_client
    |> DirectoryService.fetch_entire_directory
    |> Enum.map(&PwnedService.check_user/1)
    |> Enum.reject(&is_nil/1)
  end

  defp build_csv(breach_reports) do
    breach_reports
    |> CSV.encode(headers: ["BreachDate",
                            "DataClasses",
                            "Domain",
                            "Title"])
  end
end

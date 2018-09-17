defmodule HasMyGsuiteBeenPwned.Repo do
  use Ecto.Repo, otp_app: :has_my_gsuite_been_pwned

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end
end

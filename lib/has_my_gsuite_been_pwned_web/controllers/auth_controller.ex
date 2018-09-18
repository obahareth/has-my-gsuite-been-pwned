defmodule HasMyGsuiteBeenPwnedWeb.AuthController do
  alias HasMyGsuiteBeenPwned.Google.Directory, as: DirectoryService
  alias HasMyGsuiteBeenPwned.HaveIBeenPwned, as: PwnedService

  use HasMyGsuiteBeenPwnedWeb, :controller

  @auth_scope "https://www.googleapis.com/auth/admin.directory.user.readonly https://www.googleapis.com/auth/userinfo.email"

  @doc """
  This action is reached via `/auth/callback` is the the callback URL that
  Google's OAuth2 provider will redirect the user back to with a `code` that will
  be used to request an access token. The access token will then be used to
  access protected resources on behalf of the user.
  """
  def callback(conn, %{"code" => code}) do
    # Exchange an auth code for an access token
    client = Google.get_token!(code: code)

    # Request the user's data with the access token
    user_endpoint = "https://www.googleapis.com/plus/v1/people/me/openIdConnect"
    %{body: user} = OAuth2.Client.get!(client, user_endpoint)
    current_user = %{
      name: user["name"],
      email: user["email"],
      avatar: String.replace_suffix(user["picture"], "?sz=50", "?sz=400")
    }

    # TODO: Move this to somewhere that makes more sense (probably backgroudn task?)

    # directory_endpoint = "https://www.googleapis.com/admin/directory/v1/users?customer=my_customer"
    # %{body: directory} = OAuth2.Client.get!(client, directory_endpoint)
    DirectoryService.fetch_entire_directory(client)
    |> Enum.map(fn u ->
        Task.async(fn -> PwnedService.check_user(u) end)
      end)
    |> Enum.map(fn t -> Task.await(t) end)
    |> IO.inspect

    # Store the user in the session under `:current_user` and redirect to /.
    # In most cases, we'd probably just store the user's ID that can be used
    # to fetch from the database. In this case, since this example app has no
    # database, I'm just storing the user map.
    #
    # If you need to make additional resource requests, you may want to store
    # the access token as well.
    conn
    |> put_session(:current_user, current_user)
    |> put_session(:access_token, client.token.access_token)
    |> redirect(to: "/")
  end

  @doc """
  This action is reached via `/auth` and redirects to the Google OAuth2 provider.
  """
  def index(conn, _params) do
    redirect conn, external: Google.authorize_url!(
      scope: @auth_scope
    )
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end
end
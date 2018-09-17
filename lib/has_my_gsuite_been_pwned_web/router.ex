defmodule HasMyGsuiteBeenPwnedWeb.Router do
  use HasMyGsuiteBeenPwnedWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :assign_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HasMyGsuiteBeenPwnedWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/auth", AuthController, :index
    get "/oauth-callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", HasMyGsuiteBeenPwnedWeb do
  #   pipe_through :api
  # end

  # Fetch the current user from the session and add it to `conn.assigns`. This
  # will allow you to have access to the current user in your views with
  # `@current_user`.
  defp assign_current_user(conn, _) do
    assign(conn, :current_user, get_session(conn, :current_user))
  end
end

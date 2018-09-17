defmodule HasMyGsuiteBeenPwnedWeb.PageView do
  use HasMyGsuiteBeenPwnedWeb, :view

  def user_name(conn) do
    current_user = conn.assigns.current_user

    if (String.length(current_user.name) > 0) do
      current_user.name
    else
      current_user.email
    end
  end
end

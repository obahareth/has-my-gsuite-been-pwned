defmodule HasMyGsuiteBeenPwned.Google.Directory do
  @moduledoc """
  Directory allows us to fetch all users from a gsuite
  """

  alias HasMyGsuiteBeenPwned.User

  @directory_endpoint "https://www.googleapis.com/admin/directory/v1/users?customer=my_customer&maxResults=500"

  def directory_endpoint(page_token) when is_nil(page_token), do: @directory_endpoint

  def directory_endpoint(page_token) do
    "#{@directory_endpoint}&pageToken=#{page_token}"
  end

  def fetch_directory!(oauth_client, page_token) do
    endpoint = directory_endpoint(page_token)
    %{body: directory} = OAuth2.Client.get!(oauth_client, endpoint)

    directory
  end

  def fetch_entire_directory(oauth_client, page_token \\ nil, users \\ []) do
    directory_response = fetch_directory!(oauth_client, page_token)

    users_response = directory_response["users"]
    next_page_token = directory_response["nextPageToken"]

    next_users = users_response
    |> flatten_users
    |> Enum.concat(users)

    if next_page_token do
      fetch_entire_directory(oauth_client, next_page_token, next_users)
    else
      next_users
    end
  end

  def flatten_users(users) do
    Enum.map(users, fn u ->
      %User{email: u["primaryEmail"], name: u["name"]["fullName"]}
    end)
  end
end

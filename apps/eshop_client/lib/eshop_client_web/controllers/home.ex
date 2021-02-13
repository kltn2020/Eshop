defmodule EshopClientWeb.Home do
  use EshopClientWeb, :controller

  def home(conn, _params) do
    json(conn, %{logged_token: conn.private[:api_access_token], user_id: conn.private[:user_id]})
  end
end

defmodule EshopAdminWeb.AuthErrorHandler do
  use EshopAdminWeb, :controller

  def call(conn, :not_authenticated) do
    conn
    |> put_status(401)
    |> json(%{error: %{code: 401, message: "The user is not authenticated"}})
  end
end

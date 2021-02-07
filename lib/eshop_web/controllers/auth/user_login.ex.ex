defmodule EshopWeb.Auth.UserLogin do
  use EshopWeb, :controller

  def login(conn, user_pass_login) do
    with {:ok, conn} <- conn |> Pow.Plug.authenticate_user(user_pass_login),
         {:ok} <- check_user_is_active(conn.assigns.current_user) do
      json(conn, %{token: conn.private[:api_access_token]})
    else
      {:error, :active} ->
        conn
        |> put_status(401)
        |> json(%{error: %{status: 401, message: "User not active"}})

      {:error, conn} ->
        conn
        |> put_status(401)
        |> json(%{error: %{status: 401, message: "Invalid email or password"}})
    end
  end

  defp check_user_is_active(user) do
    case user.verify do
      true ->
        {:ok}

      false ->
        {:error, :active}
    end
  end
end

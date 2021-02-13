defmodule EshopClientWeb.Auth.UserConfirm do
  use EshopClientWeb, :controller

  alias EshopCore.Identity.User
  alias EshopCore.Identity

  def confirm(conn, %{"email" => email, "token" => token}) do
    with %User{} = user <- EshopCore.Identity.find_user(%{email: email}),
         {:ok} <- check_user_verify_condition(user, token) do
      Identity.verify_user(user)

      conn |> json(%{status: "OK"})
    else
      {:error, :verify} ->
        conn
        |> put_status(401)
        |> json(%{error: %{status: 401, message: "User already verify"}})

      {:error, :time} ->
        conn
        |> put_status(401)
        |> json(%{error: %{status: 401, message: "Expired token"}})

      {:error, :token} ->
        conn
        |> put_status(401)
        |> json(%{error: %{status: 401, message: "Token not matched"}})

      nil ->
        conn
        |> put_status(401)
        |> json(%{error: %{status: 401, message: "cant not find user by that email"}})
    end
  end

  defp check_user_verify_condition(user, token) do
    current_time = NaiveDateTime.local_now()

    with {:verify, false} <- {:verify, user.verify},
         {:time, true} <- {:time, current_time < user.token_expired_at},
         {:token, true} <- {:token, token == user.token} do
      {:ok}
    else
      {:verify, true} -> {:error, :verify}
      {:time, false} -> {:error, :time}
      {:token, false} -> {:error, :token}
    end
  end
end

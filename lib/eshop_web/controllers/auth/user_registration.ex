defmodule EshopWeb.Auth.UserRegistration do
  use EshopWeb, :controller

  alias Ecto.Changeset
  alias EshopWeb.ErrorHelpers

  def register(conn, user_registration_command) do
    with {:ok, _user, conn} <- conn |> Pow.Plug.create_user(user_registration_command) do
      json(conn, %{status: "OK"})
    else
      {:error, changeset, conn} ->
        errors = Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)

        conn
        |> put_status(500)
        |> json(%{error: %{status: 500, message: "Couldn't create user", errors: errors}})
    end
  end
end

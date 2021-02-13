defmodule EshopClientWeb.Plug.EnsureAdmin do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: Enum.into(opts, %{})

  def call(conn, opts \\ []) do
    check_admin(conn, opts)
  end

  defp check_admin(conn, _opts) do
    role = conn.private[:role]

    case role do
      "admin" -> conn
      _ -> halt_plug(conn)
    end
  end

  defp halt_plug(conn) do
    conn
    |> put_status(:unauthorized)
    |> json(%{code: 401, message: "The user is not unauthorized"})
    |> halt()
  end
end

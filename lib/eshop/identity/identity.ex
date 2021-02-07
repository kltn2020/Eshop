defmodule Eshop.Identity do
  import Ecto.Query, warn: false
  alias Eshop.Repo

  alias Eshop.Identity.User

  def get_user!(id), do: Repo.get!(User, id)

  def find_user(attrs \\ %{}), do: Repo.get_by(User, attrs)

  def verify_user(user) do
    user
    |> User.verify_changeset(%{
      verify: true,
      token: nil,
      token_expired_at: nil
    })
    |> Repo.update()
  end
end

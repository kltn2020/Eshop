defmodule Eshop.Identity do
  import Ecto.Query, warn: false
  alias Eshop.Repo

  alias Eshop.Identity.User

  def get_user!(id), do: Repo.get!(User, id)
end

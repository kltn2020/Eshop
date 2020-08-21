defmodule EshopCore.Identity do
  import Ecto.Query, warn: false
  alias Eshop.Repo

  alias EshopCore.Identity.User

  def get_user!(id), do: Repo.get!(User, id)
end

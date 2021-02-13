defmodule EshopCore.Tracking do
  @moduledoc """
  The Tracking context.
  """

  import Ecto.Query, warn: false
  alias EshopCore.Repo

  alias EshopCore.Tracking.UserViewProduct

  def create_user_view_product(attrs \\ %{}) do
    %UserViewProduct{}
    |> UserViewProduct.changeset(attrs)
    |> Repo.insert()
  end
end

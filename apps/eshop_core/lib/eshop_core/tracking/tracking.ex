defmodule EshopCore.Tracking do
  @moduledoc """
  The Tracking context.
  """

  use EshopCore, :domain

  alias EshopCore.Tracking.UserViewProduct

  def create_user_view_product(attrs \\ %{}) do
    %UserViewProduct{}
    |> UserViewProduct.changeset(attrs)
    |> Repo.insert()
  end
end

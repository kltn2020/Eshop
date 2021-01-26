defmodule Eshop.Tracking do
  @moduledoc """
  The Tracking context.
  """

  import Ecto.Query, warn: false
  alias Eshop.Repo

  alias Eshop.Tracking.UserViewProduct

  def create_user_view_product(attrs \\ %{}) do
    %UserViewProduct{}
    |> UserViewProduct.changeset(attrs)
    |> Repo.insert()
  end
end

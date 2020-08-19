defmodule Eshop.Ecom do
  import Ecto.Query, warn: false
  alias Eshop.Repo

  alias Eshop.Ecom.Category

  def list_categories do
    Repo.all(Category)
  end
end

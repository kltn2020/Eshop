defmodule Eshop.Ecom do
  import Ecto.Query, warn: false
  alias Eshop.Repo

  alias Eshop.Ecom.{Category, Brand}

  def list_categories do
    Repo.all(Category)
  end

  def list_brands do
    Repo.all(Brand)
  end
end

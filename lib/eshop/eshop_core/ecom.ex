defmodule EshopCore.Ecom do
  import Ecto.Query, warn: false
  alias Eshop.Repo

  alias EshopCore.Ecom.{Category, Brand, Product}

  def list_categories do
    Repo.all(Category)
  end

  def list_brands do
    Repo.all(Brand)
  end

  def list_products_with_paging(params) do
    from(i in Product)
    |> Eshop.Core.Filter.apply(params)
    |> Eshop.Core.Paginator.new(Repo, params)
  end

  def get_product!(id), do: Repo.get!(Product, id)

  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end
end

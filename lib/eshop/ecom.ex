defmodule Eshop.Ecom do
  import Ecto.Query, warn: false
  alias Eshop.Repo

  alias Eshop.Ecom.{Category, Brand, Product, Favorite}

  def list_categories do
    Repo.all(Category)
  end

  def list_brands do
    Repo.all(Brand)
  end

  def list_products_with_paging(params) do
    from(i in Product)
    |> Eshop.Utils.Filter.apply(params)
    |> Eshop.Utils.Paginator.new(Repo, params)
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

  def list_favorite_products(user_id) do
    product_ids =
      from(
        f in Favorite,
        where: f.user_id == ^user_id,
        select: f.product_id
      )
      |> Repo.all()

    from(p in Product, where: p.id in ^product_ids)
    |> Repo.all()
  end

  def create_favorite(user_id, product_id) do
    from(f in Favorite, where: f.user_id == ^user_id and f.product_id == ^product_id)
    |> Repo.delete_all()

    %Favorite{}
    |> Favorite.changeset(%{user_id: user_id, product_id: product_id})
    |> Repo.insert()
  end

  def delete_favorite(user_id, product_id) do
    from(f in Favorite, where: f.user_id == ^user_id and f.product_id == ^product_id)
    |> Repo.delete_all()
  end
end

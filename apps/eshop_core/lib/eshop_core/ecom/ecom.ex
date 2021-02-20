defmodule EshopCore.Ecom do
  use EshopCore, :domain

  alias EshopCore.Ecom.Category
  alias EshopCore.Ecom.Brand
  alias EshopCore.Ecom.Product
  alias EshopCore.Ecom.Favorite

  def list_categories do
    Repo.all(Category)
  end

  def list_brands do
    Repo.all(Brand)
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
    subset =
      from(
        f in Favorite,
        where: f.user_id == ^user_id,
        select: f.product_id
      )

    from(p in Product, where: p.id in subquery(subset))
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

  def find_favourite(user_id, product_id) do
    from(
      f in Favorite,
      where: f.user_id == ^user_id and f.product_id == ^product_id,
      limit: 1
    )
    |> Repo.one()
  end
end

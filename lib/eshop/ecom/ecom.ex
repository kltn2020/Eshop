defmodule Eshop.Ecom do
  import Ecto.Query, warn: false
  alias Eshop.Repo

  alias Eshop.Ecom.{Category, Brand, Product, Favorite}

  @filter_param_list ~w(brand_id category_id)

  def list_categories do
    Repo.all(Category)
  end

  def list_brands do
    Repo.all(Brand)
  end

  def list_products_with_paging(params) do
    with {:ok, collection} <- Eshop.ES.Product.Search.run(params),
         product_ids <- Enum.map(collection, &(&1["_id"] |> String.to_integer())),
         filter_params <- Map.take(params, @filter_param_list) do
      from(
        p in Product,
        where: p.id in ^product_ids,
        order_by: fragment("array_position(?::BIGINT[], id)", ^product_ids),
        order_by: [desc: :inserted_at]
      )
      |> Eshop.Utils.Filter.apply(filter_params)
      |> Eshop.Utils.Paginator.new(Repo, params)
    end
  end

  def content_based_recommend(user_id, product_id, limit) do
    with {:ok, res} <-
           Eshop.Recommender.ContentBasedRecommend.product_ids(user_id, product_id, limit),
         product_ids <- res.body do
      from(
        p in Product,
        where: p.id in ^product_ids,
        order_by: fragment("array_position(?::BIGINT[], id)", ^product_ids),
        order_by: [desc: :inserted_at]
      )
      |> Eshop.Utils.Paginator.new(Repo, %{})
    end
  end

  def collaborative_recommend(user_id, product_id, limit) do
    with {:ok, res} <-
           Eshop.Recommender.CollaborativeRecommend.product_ids(user_id, product_id, limit),
         product_ids <- res.body do
      from(
        p in Product,
        where: p.id in ^product_ids,
        order_by: fragment("array_position(?::BIGINT[], id)", ^product_ids),
        order_by: [desc: :inserted_at]
      )
      |> Eshop.Utils.Paginator.new(Repo, %{})
    end
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
end

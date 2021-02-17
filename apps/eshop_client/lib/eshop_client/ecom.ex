defmodule EshopClient.Ecom do
  import Ecto.Query, warn: false
  alias EshopCore.Repo
  alias EshopCore.Ecom.ProductQuery
  alias EshopCore.Recommender.CollaborativeRecommend
  alias EshopCore.Recommender.ContentBasedRecommend

  @default_preload [
    :brand,
    :category
  ]

  def load_product_data(products) when is_list(products) do
    products
    |> Repo.preload(@default_preload)
  end

  def filter_products(params) do
    with {:ok, collection} <- EshopCore.ES.Product.Search.run(params) do
      product_ids = Enum.map(collection, &(&1["_id"] |> String.to_integer()))

      paginate =
        ProductQuery.query()
        |> ProductQuery.by_product_ids(product_ids)
        |> ProductQuery.by_brand(params.brand_id)
        |> ProductQuery.by_category(params.category_id)
        |> EshopCore.Utils.Paginator.new(Repo, params)

      entries =
        paginate.entries
        |> load_product_data()

      {entries, paginate}
    end
  end

  def content_based_recommend(user_id, product_id, limit) do
    with {:ok, product_ids} <- ContentBasedRecommend.perform(user_id, product_id, limit) do
      paginate =
        ProductQuery.query()
        |> ProductQuery.by_product_ids(product_ids)
        |> EshopCore.Utils.Paginator.new(Repo, %{size: limit})

      entries =
        paginate.entries
        |> load_product_data()

      {entries, paginate}
    end
  end

  def collaborative_recommend(user_id, limit) do
    with {:ok, product_ids} <- CollaborativeRecommend.perform(user_id, limit) do
      paginate =
        ProductQuery.query()
        |> ProductQuery.by_product_ids(product_ids)
        |> EshopCore.Utils.Paginator.new(Repo, %{size: limit})

      entries =
        paginate.entries
        |> load_product_data()

      {entries, paginate}
    end
  end
end

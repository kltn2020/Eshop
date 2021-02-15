defmodule EshopClientWeb.Ecom.ProductController do
  use EshopClientWeb, :controller

  alias EshopCore.Settings
  alias EshopClient.Ecom

  action_fallback EshopClientWeb.FallbackController

  @schema %{
    size: [type: :integer, validate: {:inclusion, [20, 50, 100]}, default: 20],
    page: [type: :integer, default: 1],
    brand_id: [type: :integer],
    category_id: [type: :integer],
    search_terms: :string
  }

  def index(conn, params) do
    with {:ok, valid_params} <- Tarams.parse(@schema, params) do
      {entries, paginate} = Ecom.filter_products(valid_params)

      render(conn, "index.json", products: entries, paginate: paginate)
    end
  end

  def content_based_recommend(conn, %{"product_id" => product_id}) do
    user_id = conn.private[:user_id]
    setting = Settings.get_setting()
    {entries, paginate} = Ecom.content_based_recommend(user_id, product_id, setting.limit)

    render(conn, "index.json", products: entries, paginate: paginate)
  end

  def collaborative_recommend(conn, %{"product_id" => product_id}) do
    user_id = conn.private[:user_id]
    setting = Settings.get_setting()
    {entries, paginate} = Ecom.collaborative_recommend(user_id, product_id, setting.limit)

    render(conn, "index.json", products: entries, paginate: paginate)
  end

  def show(conn, %{"id" => id}) do
    product = EshopCore.Ecom.get_product!(id)

    user_id = conn.private[:user_id]

    EshopCore.Tracking.create_user_view_product(%{product_id: id, user_id: user_id})

    [preload_product | _] = Ecom.load_product_data([product])

    render(conn, "show.json", product: preload_product)
  end
end

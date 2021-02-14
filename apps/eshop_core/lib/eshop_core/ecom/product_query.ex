defmodule EshopCore.Ecom.ProductQuery do
  use EshopCore, :query

  alias EshopCore.Ecom.Product

  def query do
    Product
  end

  def with_filter(query, filters \\ %{}) do
    Filter.apply(query, filters, skip_nil: true)
  end

  def by_product_ids(query, product_ids) do
    where(query, [p], p.id in ^product_ids)
    |> order_by([p], fragment("array_position(?::BIGINT[], ?)", ^product_ids, p.id))
  end

  def by_brand(query, nil), do: query

  def by_brand(query, brand_id) do
    with_filter(query, %{brand_id: brand_id})
  end

  def by_category(query, nil), do: query

  def by_category(query, category_id) do
    with_filter(query, %{category_id: category_id})
  end
end

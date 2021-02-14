defmodule EshopClientWeb.Ecom.ProductView do
  use EshopClientWeb, :view

  @fields [
    :id,
    :battery_capacity,
    :bluetooth,
    :camera,
    :cpu,
    :description,
    :discount_price,
    :display,
    :display_resolution,
    :display_screen,
    :gpu,
    :material,
    :name,
    :new_feature,
    :os,
    :ports,
    :price,
    :ram,
    :rating_avg,
    :rating_count,
    :size,
    :sku,
    :sold,
    :storage,
    :video,
    :weight,
    :wifi,
    :is_available,
    :images
  ]

  @custom_fields []

  @relationships [
    category: EshopClientWeb.Ecom.CategoryView,
    brand: EshopClientWeb.Ecom.BrandView
  ]

  def render("index.json", %{products: products, paginate: paginate}) do
    data =
      Map.merge(
        %{entries: render_many(products, __MODULE__, "product.json")},
        render_one(paginate, EshopClientWeb.PaginateView, "paginate.json")
      )

    %{
      data: data,
      status: "OK"
    }
  end

  def render("product.json", %{product: product}) do
    render_json(product, @fields, @custom_fields, @relationships)
  end

  def render("show.json", %{product: product}) do
    %{
      data: render_one(product, __MODULE__, "product.json"),
      status: "OK"
    }
  end
end

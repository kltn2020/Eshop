defmodule EshopClientWeb.Checkout.VoucherView do
  use EshopClientWeb, :view

  @fields [
    :id,
    :code,
    :is_used,
    :valid_from,
    :valid_to,
    :value,
    :category_id
  ]

  @custom_fields []

  @relationships [
    category: EshopClientWeb.Ecom.CategoryView
  ]

  def render("voucher.json", %{voucher: voucher}) do
    render_json(voucher, @fields, @custom_fields, @relationships)
  end

  def render("show.json", %{voucher: voucher}) do
    %{
      data: render_one(voucher, __MODULE__, "voucher.json")
    }
  end

  def render("index.json", %{vouchers: vouchers, paginate: paginate}) do
    data =
      Map.merge(
        %{entries: render_many(vouchers, __MODULE__, "voucher.json")},
        render_one(paginate, EshopClientWeb.PaginateView, "paginate.json")
      )

    %{
      data: data
    }
  end
end

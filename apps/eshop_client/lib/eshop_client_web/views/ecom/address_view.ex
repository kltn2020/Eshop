defmodule EshopClientWeb.Checkout.AddressView do
  use EshopClientWeb, :view

  @fields [
    :id,
    :locate,
    :is_primary,
    :phone_number
  ]

  @custom_fields []

  @relationships []

  def render("index.json", %{addresses: addresses}) do
    %{
      data: render_many(addresses, __MODULE__, "address.json")
    }
  end

  def render("address.json", %{address: address}) do
    render_json(address, @fields, @custom_fields, @relationships)
  end

  def render("show.json", %{address: address}) do
    %{
      data: render_one(address, __MODULE__, "address.json")
    }
  end
end

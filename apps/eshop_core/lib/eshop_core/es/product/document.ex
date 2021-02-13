defimpl Elasticsearch.Document, for: EshopCore.Ecom.Product do
  def id(product), do: product.id

  def routing(_), do: false

  def encode(product) do
    %{
      id: product.id,
      name: product.name,
      brand: EshopCore.Map.query_map(product, [:brand, :name])
    }
  end
end

defmodule EshopCore.ES.Product.Store do
  @behaviour Elasticsearch.Store

  alias EshopCore.Repo
  alias EshopCore.ES.Cluster, as: EC

  @preloads [:brand]

  @index "products"

  @impl true
  def stream(schema) do
    schema
    |> Repo.stream()
    |> Repo.stream_preload(500, @preloads)
  end

  @impl true
  def transaction(fun) do
    {:ok, result} = Repo.transaction(fun, timeout: :infinity)
    result
  end

  def update_product_to_es(product, action) when action in [:create, :update] do
    product = product |> Repo.preload(@preloads)

    Elasticsearch.put_document(EC, product, @index)
  end

  def update_product_to_es(product, :delete),
    do: Elasticsearch.delete_document!(EC, product, @index)

  def search_products(query),
    do: Elasticsearch.post!(EC, "/#{@index}/_search/?size=1000", query)
end

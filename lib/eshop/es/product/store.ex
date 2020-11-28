defmodule Eshop.ES.Product.Store do
  @behaviour Elasticsearch.Store

  alias Eshop.Repo
  alias Eshop.ES.Cluster, as: EC

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

  def search_products(query),
    do: Elasticsearch.post!(EC, "/#{@index}/_search/?size=1000", query)
end

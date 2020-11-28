defmodule Eshop.ES.Product.Search do
  import Eshop.ES.Product.Store, only: [search_products: 1]

  def run(params) do
    %{
      "hits" => %{
        "hits" => collection
      }
    } =
      params
      |> convert_to_elastic_query
      |> search_products

    {:ok, collection}
  end

  defp convert_to_elastic_query(params) do
    %{
      "query" => filter_query(params)
    }
  end

  defp filter_query(nil), do: %{ "match_all" => %{} }

  defp filter_query(params) do
    if Map.get(params, "search_terms") in [nil, ""] do
      filter_query(nil)
    else
      %{
        "bool" => %{
          "should" => should_query(params)
        }
      }
    end
  end

  defp should_query(params) do
    []
    |> query_product_name(params)
    |> query_brand_name(params)
  end

  defp query_product_name(query, params) do
    [
      %{
        "match" => %{"name" => params["search_terms"]}
      }
    ] ++ query
  end

  defp query_brand_name(query, params) do
    [
      %{
        "match" => %{"brand" => params["search_terms"]}
      }
    ] ++ query
  end
end

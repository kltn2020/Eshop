defmodule EshopCore.Recommender.CollaborativeRecommend do
  def perform(user_id, limit) do
    with {:ok, %{body: body}} <- fetch_product_ids(user_id, limit) do
      {:ok, body}
    end
  end

  def fetch_product_ids(user_id, limit) do
    api_client()
    |> Tesla.get("/collaborative_recommend?user_id=#{user_id}&limit=#{limit}")
  end

  defp api_client() do
    middleware = [
      {Tesla.Middleware.BaseUrl, System.get_env("RECOMMENDER_HOST")},
      Tesla.Middleware.JSON,
      Tesla.Middleware.Logger
    ]

    Tesla.client(middleware)
  end
end

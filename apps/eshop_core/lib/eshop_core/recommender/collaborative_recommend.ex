defmodule EshopCore.Recommender.CollaborativeRecommend do
  use Tesla

  plug Tesla.Middleware.BaseUrl, System.get_env("RECOMMENDER_HOST")
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Logger

  require Logger

  def perform(user_id, limit) do
    with {:ok, res} <- fetch_product_ids(user_id, limit),
         ids <- res.body do
      Logger.info(ids, label: "CollaborativeRecommend")

      {:ok, ids}
    end
  end

  def fetch_product_ids(user_id, limit) do
    get("/collaborative_recommend?user_id=#{user_id}&limit=#{limit}")
  end
end

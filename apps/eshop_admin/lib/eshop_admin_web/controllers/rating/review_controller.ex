defmodule EshopAdminWeb.Rating.ReviewController do
  use EshopAdminWeb, :controller

  alias EshopCore.Rating
  alias EshopCore.Rating.Review

  action_fallback EshopAdminWeb.FallbackController

  def index(conn, params) do
    paging = Rating.admin_list_reviews_with_paging(params)

    entries =
      paging.entries
      |> EshopCore.Repo.preload([:user, [replies: :user]])
      |> EshopCore.Utils.StructHelper.to_map()
      |> Enum.map(fn review ->
        Map.put(
          review,
          :user,
          Map.take(review.user, [:email, :id])
        )
      end)
      |> Enum.map(fn review ->
        replies =
          review.replies
          |> Enum.map(fn reply ->
            Map.put(
              reply,
              :user,
              Map.take(reply.user, [:email, :id])
            )
          end)

        Map.put(review, :replies, replies)
      end)

    conn |> json(%{status: "OK", data: %{paging | entries: entries}})
  end

  def delete(conn, %{"id" => id}) do
    review = Rating.get_review!(id)

    product_id = review.product_id

    with {:ok, %Review{}} <- Rating.delete_review(review) do
      Rating.update_rating(product_id)
      conn |> json(%{status: "OK"})
    end
  end
end

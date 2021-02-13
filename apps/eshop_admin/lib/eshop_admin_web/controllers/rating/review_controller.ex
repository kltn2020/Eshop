defmodule EshopAdminWeb.Rating.ReviewController do
  use EshopAdminWeb, :controller

  alias EshopCore.Rating
  alias EshopCore.Rating.Review

  action_fallback EshopAdminWeb.FallbackController

  def index(conn, %{"product_id" => product_id} = params) do
    paging = Rating.list_reviews_with_paging(product_id, params)

    entries =
      paging.entries
      |> EshopCore.Repo.preload(:user)
      |> EshopCore.Repo.preload(replies: :user)
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

  def admin_index(conn, params) do
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

  def create(conn, %{"product_id" => product_id} = params) do
    user_id = conn.private[:user_id]

    case Rating.create_review(user_id, params) do
      {:ok, review} ->
        Rating.update_rating(product_id)

        conn
        |> put_status(:ok)
        |> json(%{status: "OK", data: EshopCore.Utils.StructHelper.to_map(review)})

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{
          status: "ERROR",
          code: "VALIDATION_FAILED",
          message:
            changeset
            |> EshopAdminWeb.ChangesetView.translate_errors()
            |> EshopCore.Utils.Validator.get_validation_error_message()
        })
    end
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

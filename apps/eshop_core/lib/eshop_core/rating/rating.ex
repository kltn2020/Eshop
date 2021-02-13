defmodule EshopCore.Rating do
  import Ecto.Query, warn: false
  alias EshopCore.Repo

  alias EshopCore.Rating.Review
  alias EshopCore.Rating.Reply

  def list_reviews_with_paging(product_id, params) do
    from(
      i in Review,
      where: i.product_id == ^product_id,
      order_by: [desc: :point],
      order_by: [desc: :inserted_at]
    )
    |> EshopCore.Utils.Filter.apply(params)
    |> EshopCore.Utils.Paginator.new(Repo, params)
  end

  def admin_list_reviews_with_paging(params) do
    from(
      r in Review,
      order_by: [desc: :inserted_at]
    )
    |> EshopCore.Utils.Filter.apply(params)
    |> EshopCore.Utils.Paginator.new(Repo, params)
  end

  def create_review(user_id, attrs \\ %{}) do
    attrs = Map.merge(attrs, %{"user_id" => user_id})

    %Review{}
    |> Review.changeset(attrs)
    |> Repo.insert()
  end

  def delete_review(%Review{} = review) do
    Repo.delete(review)
  end

  def create_reply(user_id, attrs \\ %{}) do
    attrs = Map.merge(attrs, %{"user_id" => user_id})

    %Reply{}
    |> Reply.changeset(attrs)
    |> Repo.insert()
  end

  def update_rating(product_id) do
    query = from(r in Review, where: r.product_id == ^product_id)

    count = Repo.aggregate(query, :count, :id)
    sum = Repo.aggregate(query, :sum, :point)

    product = EshopCore.Ecom.get_product!(product_id)

    EshopCore.Ecom.update_product(product, %{
      rating_count: count,
      rating_avg: (sum / count) |> Float.round(2)
    })
  end

  def get_review!(id), do: Repo.get!(Review, id)
end

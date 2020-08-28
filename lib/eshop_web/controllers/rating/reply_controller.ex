defmodule EshopWeb.Rating.ReplyController do
  use EshopWeb, :controller

  alias Eshop.Rating
  alias Eshop.Rating.Reply

  action_fallback EshopWeb.FallbackController

  def create(conn, params) do
    user_id = conn.private[:user_id]
    IO.inspect(params)

    case Rating.create_reply(user_id, params) do
      {:ok, reply} ->
        conn
        |> put_status(:ok)
        |> json(%{status: "OK", data: Eshop.Utils.StructHelper.to_map(reply)})

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{
          status: "ERROR",
          code: "VALIDATION_FAILED",
          message:
            changeset
            |> EshopWeb.ChangesetView.translate_errors()
            |> Eshop.Utils.Validator.get_validation_error_message()
        })
    end
  end
end

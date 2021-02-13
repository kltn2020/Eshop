defmodule EshopAdminWeb.Rating.ReplyController do
  use EshopAdminWeb, :controller

  alias EshopCore.Rating

  action_fallback EshopAdminWeb.FallbackController

  def create(conn, params) do
    user_id = conn.private[:user_id]
    IO.inspect(params)

    case Rating.create_reply(user_id, params) do
      {:ok, reply} ->
        conn
        |> put_status(:ok)
        |> json(%{status: "OK", data: EshopCore.Utils.StructHelper.to_map(reply)})

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
end

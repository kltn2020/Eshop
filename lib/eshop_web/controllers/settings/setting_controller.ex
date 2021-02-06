defmodule EshopWeb.Settings.SettingController do
  use EshopWeb, :controller

  alias Eshop.Settings

  def show(conn, _params) do
    setting = Settings.get_setting()

    conn
    |> put_status(:ok)
    |> json(%{status: "OK", data: Eshop.Utils.StructHelper.to_map(setting)})
  end

  def update(conn, params) do
    setting = Settings.get_setting()

    case Settings.update_setting(setting, params) do
      {:ok, setting} ->
        conn
        |> put_status(:ok)
        |> json(%{status: "OK", data: Eshop.Utils.StructHelper.to_map(setting)})

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

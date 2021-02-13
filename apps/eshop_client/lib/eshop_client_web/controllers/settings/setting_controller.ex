defmodule EshopClientWeb.Settings.SettingController do
  use EshopClientWeb, :controller

  alias EshopCore.Settings

  def show(conn, _params) do
    setting = Settings.get_setting()

    conn
    |> put_status(:ok)
    |> json(%{status: "OK", data: EshopCore.Utils.StructHelper.to_map(setting)})
  end

  def update(conn, params) do
    setting = Settings.get_setting()

    case Settings.update_setting(setting, params) do
      {:ok, setting} ->
        conn
        |> put_status(:ok)
        |> json(%{status: "OK", data: EshopCore.Utils.StructHelper.to_map(setting)})

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{
          status: "ERROR",
          code: "VALIDATION_FAILED",
          message:
            changeset
            |> EshopClientWeb.ChangesetView.translate_errors()
            |> EshopCore.Utils.Validator.get_validation_error_message()
        })
    end
  end
end

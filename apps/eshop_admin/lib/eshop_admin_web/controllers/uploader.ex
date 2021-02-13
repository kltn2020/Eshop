defmodule EshopAdminWeb.Uploader do
  use EshopAdminWeb, :controller

  action_fallback EshopAdminWeb.FallbackController

  def upload(conn, %{"image" => image}) do
    case EshopCore.Utils.CloudinaryUploader.upload(image.path) do
      {:ok, image_url} ->
        conn |> json(%{status: "OK", data: image_url})

      {:error, message} ->
        conn |> json(%{status: "ERROR", data: message})
    end
  end
end

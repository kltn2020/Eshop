defmodule EshopWeb.Controllers.Uploader do
  use EshopWeb, :controller

  action_fallback EshopWeb.FallbackController

  def upload(conn, %{"image" => image}) do
    case Eshop.Utils.CloudinaryUploader.upload(image.path) do
      {:ok, image_url} ->
        conn |> json(%{status: "OK", data: image_url})

      err ->
        conn |> json(%{status: "ERROR", data: err})
    end
  end
end

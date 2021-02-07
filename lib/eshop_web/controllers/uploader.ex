defmodule EshopWeb.Uploader do
  use EshopWeb, :controller

  action_fallback EshopWeb.FallbackController

  def upload(conn, %{"image" => image}) do
    case Eshop.Utils.CloudinaryUploader.upload(image.path) do
      {:ok, image_url} ->
        conn |> json(%{status: "OK", data: image_url})

      {:error, message} ->
        conn |> json(%{status: "ERROR", data: message})
    end
  end
end

defmodule Eshop.Tools.ImageTransfer do
  alias Eshop.Repo
  alias Eshop.Ecom.Product
  alias Eshop.Ecom
  alias Eshop.Utils.CloudinaryUploader
  import Ecto.Query, warn: false

  require Logger

  @spec perform :: list
  def perform do
    from(p in Product, order_by: p.id)
    |> Repo.all()
    |> Enum.map(fn product ->
      Logger.info("Excute product id #{product.id}")

      new_images =
        product.images
        |> Enum.map(fn image ->
          with url <- image["url"],
               {:ok, file_path} <- download_image(url),
               {:ok, image_url} <- CloudinaryUploader.upload(file_path) do
            %{"url" => image_url}
          else
            err ->
              Logger.info(inspect(err))
              image["url"]
          end
        end)

      Ecom.update_product(product, %{images: new_images})
    end)
  end

  defp download_image(url) do
    with {:ok, %HTTPoison.Response{body: body}} <- HTTPoison.get(url),
         file_path <- "/tmp/#{url |> String.split("/") |> Enum.at(-1)}",
         :ok <- File.write(file_path, body) do
      {:ok, file_path}
    else
      {:error, message} ->
        {:error, message}

      _ ->
        {:error, :download_image}
    end
  end
end

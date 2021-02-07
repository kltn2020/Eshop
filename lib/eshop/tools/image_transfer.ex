defmodule Eshop.Tools.ImageTransfer do
  alias Eshop.Repo
  alias Eshop.Ecom.Product
  alias Eshop.Ecom
  alias Eshop.Utils.CloudinaryUploader
  import Ecto.Query, warn: false

  @spec perform :: list
  def perform do
    Repo.all(Product)
    |> Enum.map(fn product ->
      new_images =
        product.images
        |> Enum.map(fn image ->
          with url <- image["url"],
               {:ok, file_path} <- download_image(url),
               {:ok, image_url} <- CloudinaryUploader.upload(file_path) do
            %{"url" => image_url}
          else
            _ -> ""
          end
        end)

      Ecom.update_product(product, %{images: new_images})
    end)
  end

  defp download_image(url) do
    %HTTPoison.Response{body: body} = HTTPoison.get!(url)

    file_path = "/tmp/#{url |> String.split("/") |> Enum.at(-1)}"

    case File.write(file_path, body) do
      :ok -> {:ok, file_path}
      _ -> {:error, :download_image}
    end
  end
end

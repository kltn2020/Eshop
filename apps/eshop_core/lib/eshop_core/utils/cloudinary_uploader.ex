defmodule EshopCore.Utils.CloudinaryUploader do
  def get_resource do
    System.get_env("CLOUDEX_CLOUD_ENV")
  end

  def upload(file_path) do
    now = EshopCore.Utils.DateTime.local_default()

    month = (now.month >= 10 && now.month) || "0#{now.month}"
    day = (now.day >= 10 && now.day) || "0#{now.day}"

    unix_now_letters = Integer.to_charlist(DateTime.to_unix(DateTime.utc_now()), 36)
    random_letters = Integer.to_charlist(Enum.random(50_000..1_600_000), 36)

    formated_file_name =
      "#{get_resource()}/#{now.year}/#{month}/#{day}/#{unix_now_letters}#{random_letters}"

    file_path
    |> Cloudex.upload(%{public_id: formated_file_name})
    |> case do
      {:ok, upload_image} -> {:ok, upload_image.secure_url}
      err -> {:error, inspect(err)}
    end
  end
end

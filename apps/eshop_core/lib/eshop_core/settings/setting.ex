defmodule EshopCore.Settings do
  import Ecto.Query, warn: false
  alias EshopCore.Repo

  alias EshopCore.Settings.GeneralSetting

  def get_setting do
    GeneralSetting
    |> Repo.one()
  end

  def update_setting(%GeneralSetting{} = setting, attrs \\ %{}) do
    setting
    |> GeneralSetting.changeset(attrs)
    |> Repo.update()
  end
end

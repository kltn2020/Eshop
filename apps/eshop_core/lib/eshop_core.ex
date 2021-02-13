defmodule EshopCore do
  def model do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
    end
  end

  def domain do
    quote do
      import Ecto.Query
      alias EshopCore.Repo
    end
  end

  def action do
    quote do
      import Ecto.Changeset
      import Ecto.Query
      alias EshopCore.Repo
    end
  end

  def repository do
    quote do
      import Ecto.Query
      alias EshopCore.Repo
    end
  end

  def query do
    quote do
      import Ecto.Query
      alias Querie.Filter
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end

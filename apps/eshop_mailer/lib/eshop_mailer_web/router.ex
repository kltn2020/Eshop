defmodule EshopMailerWeb.Router do
  use EshopMailerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", EshopMailerWeb do
    pipe_through :api
  end
end

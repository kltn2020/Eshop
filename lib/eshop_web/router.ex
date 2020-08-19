defmodule EshopWeb.Router do
  use EshopWeb, :router
  use Pow.Phoenix.Router

  pipeline :api do
    plug :accepts, ["json"]
    plug Eshop.Identity.AuthFlow, otp_app: :eshop
  end

  pipeline :api_protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: EshopWeb.AuthErrorHandler
  end

  pipeline :admin_protected do
    plug EshopWeb.Plug.EnsureAdmin
  end

  scope "/api/auth", EshopWeb.Controllers do
    pipe_through :api

    post "/register", Auth.UserRegistration, :register
    post "/login", Auth.UserLogin, :login
  end

  scope "/api/admin", EshopWeb.Controllers do
    pipe_through [:api, :api_protected, :admin_protected]

    get("/categories", Ecom.CategoryController, :index)
  end

  scope "/api", EshopWeb.Controllers do
    pipe_through [:api, :api_protected]

    get "/home/profile", Home, :home
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: EshopWeb.Telemetry
    end
  end
end

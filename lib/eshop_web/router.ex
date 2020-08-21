defmodule EshopWeb.Router do
  use EshopWeb, :router
  use Pow.Phoenix.Router

  pipeline :api do
    plug :accepts, ["json"]
    plug EshopCore.Identity.AuthFlow, otp_app: :eshop
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
    get("/brands", Ecom.BrandController, :index)

    post("/products", Ecom.ProductController, :create)
    put("/products/:id", Ecom.ProductController, :update)
    delete("/products/:id", Ecom.ProductController, :delete)

    post("/upload", Uploader, :upload)
  end

  scope "/api", EshopWeb.Controllers do
    pipe_through [:api, :api_protected]

    get "/home/profile", Home, :home

    get("/shopping/my-cart", Shopping.CartController, :my_cart)
    delete("/shopping/my-cart", Shopping.CartController, :clear_my_cart)
    post("/shopping/:product_id/increase", Shopping.CartController, :increase_item)
    put("/shopping/:product_id/decrease", Shopping.CartController, :decrease_item)
    delete("/shopping/:product_id/remove", Shopping.CartController, :remove_item)
  end

  scope "/api", EshopWeb.Controllers do
    pipe_through [:api]

    get("/products", Ecom.ProductController, :index)
    get("/products/:id", Ecom.ProductController, :show)
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: EshopWeb.Telemetry
    end
  end
end

defmodule EshopWeb.Router do
  use EshopWeb, :router
  use Pow.Phoenix.Router
  use Plug.ErrorHandler
  use Sentry.PlugCapture

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

  scope "/api/auth", EshopWeb do
    pipe_through :api

    post "/register", Auth.UserRegistration, :register
    post "/login", Auth.UserLogin, :login
  end

  scope "/api/admin", EshopWeb do
    pipe_through [:api, :api_protected, :admin_protected]

    get("/categories", Ecom.CategoryController, :index)
    get("/brands", Ecom.BrandController, :index)

    post("/products", Ecom.ProductController, :create)
    put("/products/:id", Ecom.ProductController, :update)
    delete("/products/:id", Ecom.ProductController, :delete)

    post("/vouchers", Checkout.VoucherController, :create)
    put("/vouchers/:id", Checkout.VoucherController, :update)
    delete("/vouchers/:id", Checkout.VoucherController, :delete)
    get("/vouchers", Checkout.VoucherController, :index)
    get("/vouchers/:id", Checkout.VoucherController, :show)

    post("/upload", Uploader, :upload)

    get("/orders", Checkout.OrderController, :index)
    put("/orders/:id", Checkout.OrderController, :update)
    get("/orders/:id", Checkout.OrderController, :show)

    delete("/reviews/:id", Rating.ReviewController, :delete)
    get("/reviews", Rating.ReviewController, :admin_index)
  end

  scope "/api", EshopWeb do
    pipe_through [:api, :api_protected]

    get "/home/profile", Home, :home

    get("/shopping/my-cart", Shopping.CartController, :my_cart)
    delete("/shopping/my-cart", Shopping.CartController, :clear_my_cart)
    put("/shopping/:product_id", Shopping.CartController, :update_quantity)

    get("/vouchers/check/:code", Checkout.VoucherController, :check)
    get("/address", Checkout.AddressController, :index)
    post("/address", Checkout.AddressController, :create)
    put("/address/:id", Checkout.AddressController, :update)
    delete("/address/:id", Checkout.AddressController, :delete)

    get("/orders", Checkout.OrderController, :index)
    post("/orders", Checkout.OrderController, :create)
    put("/orders/:id", Checkout.OrderController, :update)
    get("/orders/:id", Checkout.OrderController, :show)

    post("/products/:product_id/like", Ecom.FavoriteController, :create)
    delete("/products/:product_id/like", Ecom.FavoriteController, :delete)
    get("/products/like", Ecom.FavoriteController, :index)
    post("/products/:product_id/reviews", Rating.ReviewController, :create)
    post("/reviews/:review_id", Rating.ReplyController, :create)
  end

  scope "/api", EshopWeb do
    pipe_through [:api]

    get("/products", Ecom.ProductController, :index)
    get("/products/:id", Ecom.ProductController, :show)
    get("/products/:product_id/reviews", Rating.ReviewController, :index)
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: EshopWeb.Telemetry
    end
  end
end

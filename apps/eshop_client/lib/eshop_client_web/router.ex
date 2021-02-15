defmodule EshopClientWeb.Router do
  use EshopClientWeb, :router
  use Pow.Phoenix.Router
  use Plug.ErrorHandler
  use Sentry.PlugCapture

  pipeline :api do
    plug :accepts, ["json"]
    plug EshopCore.Identity.AuthFlow, otp_app: :eshop_core
  end

  pipeline :api_protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: EshopClientWeb.AuthErrorHandler
  end

  scope "/api/auth", EshopClientWeb do
    pipe_through :api

    post "/register", Auth.UserRegistration, :register
    post "/login", Auth.UserLogin, :login
    post "/confirm", Auth.UserConfirm, :confirm
  end

  scope "/api", EshopClientWeb do
    pipe_through [:api, :api_protected]

    get "/home/profile", Home, :home

    get("/shopping/my-cart", Shopping.CartController, :my_cart)
    delete("/shopping/my-cart", Shopping.CartController, :clear_my_cart)
    put("/shopping/:product_id", Shopping.CartController, :update_quantity)
    put("/shopping/:product_id/toggle", Shopping.CartController, :toggle_cart_product)

    get("/vouchers/check/:code", Checkout.VoucherController, :check)
    get("/vouchers", Checkout.VoucherController, :index)

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

    get("/products", Ecom.ProductController, :index)
    get("/products/content_based_recommend", Ecom.ProductController, :content_based_recommend)
    get("/products/collaborative_recommend", Ecom.ProductController, :collaborative_recommend)
    get("/products/:id", Ecom.ProductController, :show)
    get("/products/:product_id/reviews", Rating.ReviewController, :index)
  end

  forward("/api/admin", EshopAdminWeb.Router)
end

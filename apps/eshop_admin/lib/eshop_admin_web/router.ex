defmodule EshopAdminWeb.Router do
  use EshopAdminWeb, :router
  use Pow.Phoenix.Router
  use Plug.ErrorHandler
  use Sentry.PlugCapture

  pipeline :api do
    plug :accepts, ["json"]
    plug EshopCore.Identity.AuthFlow, otp_app: :eshop_core
  end

  pipeline :api_protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: EshopAdminWeb.AuthErrorHandler
  end

  pipeline :admin_protected do
    plug EshopAdminWeb.Plug.EnsureAdmin
  end

  scope "/", EshopAdminWeb do
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
    get("/reviews", Rating.ReviewController, :index)

    get("/setting", Settings.SettingController, :show)
    put("/setting", Settings.SettingController, :update)
  end
end

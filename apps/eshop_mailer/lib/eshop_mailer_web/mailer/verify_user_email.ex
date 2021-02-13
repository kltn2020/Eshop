defmodule EshopMailerWeb.VerifyUserEmail do
  import Bamboo.Email
  import Bamboo.Phoenix

  use Bamboo.Phoenix, view: EshopMailerWeb.EmailView

  alias EshopCore.Settings

  def sender_mail do
    setting = Settings.get_setting()

    setting.sender_email
  end

  def base_email do
    new_email()
    |> from({"Eshop", sender_mail()})
    |> put_html_layout({EshopMailerWeb.LayoutView, "email.html"})
    |> put_text_layout({EshopMailerWeb.LayoutView, "email.text"})
  end

  def perform(%{"user_id" => user_id}) do
    user = EshopCore.Identity.get_user!(user_id)

    email = user.email

    base_email()
    |> to(email)
    |> subject("Verify Email")
    |> render("verify_email.html", %{user: user})
    |> EshopMailerWeb.Mailer.deliver_now()
  end
end

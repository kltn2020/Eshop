defmodule EshopCore.Utils.Constants do
  @moduledoc """
  EshopCore.Utils.Constants
  """
  def get_default_timezone, do: "Asia/Ho_Chi_Minh"
  def currency_vnd, do: "VND"
  def currency_enum, do: ["VND"]
  def get_default_country, do: "Vietnam"
  def get_default_zipcode, do: "700000"
  def phone_regex, do: ~r/^0\d{9,10}$/

  def email_regex,
    do:
      ~r/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
end

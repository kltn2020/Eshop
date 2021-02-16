defmodule EshopClientWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use EshopClientWeb, :controller

  require Logger

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(EshopClientWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(EshopClientWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :server_error}) do
    conn
    |> put_status(:server_error)
    |> put_view(EshopClientWeb.ErrorView)
    |> render(:"500")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:not_found)
    |> put_view(EshopClientWeb.ErrorView)
    |> render(:unauthorized)
  end

  def call(conn, {:error, :no_credentials}) do
    conn
    |> put_status(:not_found)
    |> put_view(EshopClientWeb.ErrorView)
    |> render(:no_credentials)
  end

  def call(conn, {:error, %{error_code: _code} = error_data}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(error_data)
  end

  def call(conn, {:error, %{message: message}}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(EshopClientWeb.ChangesetView)
    |> render("error.json", message: message)
  end

  def call(conn, {:error, message}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(EshopClientWeb.ChangesetView)
    |> render("error.json", message: message)
  end

  def call(conn, {:ok, data}) do
    json(conn, %{
      status: "OK",
      data: data
    })
  end

  def call(conn, {:ok, data, nil}) do
    json(conn, %{
      status: "OK",
      data: data,
      next_url: nil
    })
  end

  def call(conn, {:ok, data, next_params}) do
    params = Enum.filter(next_params, fn {_k, v} -> !is_nil(v) end) |> Enum.into(%{})

    json(conn, %{
      status: "OK",
      data: data,
      next_url: current_url(conn, params)
    })
  end

  def call(conn, err) do
    Logger.error(inspect(err))

    conn
    |> put_status(:unprocessable_entity)
    |> render(EshopClientWeb.ChangesetView, "error.json", message: "#{inspect(err)}")
  end
end

defmodule ExauthWeb.AuthController do
  use ExauthWeb, :controller

  def ping(conn, _params) do
    conn
    |> render("ack.json", %{success: true, message: "pong"})
  end

  def register(conn, params) do
    IO.inspect(params)
    conn |> render("ack.json", %{success: true, message: "Regestration successful"})
  end
end

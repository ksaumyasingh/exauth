defmodule ExauthWeb.AuthController do
  use ExauthWeb, :controller
  alias Exauth.Accounts
  alias ExauthWeb.Utils
  def ping(conn, _params) do
    conn
    |> render("ack.json", %{success: true, message: "pong"})
  end

  def register(conn, params) do
    res = Accounts.create_user(params)
    IO.inspect(res)
    case res do
      {:ok, _user} ->
        conn |> render("ack.json", %{success: true, message: "Regestration successful"})
      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        conn |> render("errors.json", %{errors: Utils.format_changeset_errors(changeset)})
      _ -> conn |> render("error.json", %{error: Utils.internal_server_error()})
    end
  end
end

defmodule ExauthWeb.AuthController do
  use ExauthWeb, :controller
  alias Exauth.Accounts
  alias ExauthWeb.Utils
  alias Exauth.Accounts.User
  alias ExauthWeb.JwtToken
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

  def login(conn, %{"username" => username, "password" => password}) do
    with %User{id: id} = user <- Accounts.get_user_by_username(username),
        true <- Pbkdf2.verify_pass(password, user.password) do
        IO.inspect(user)
        signer = Joken.Signer.create(
          "HS256",
          "i++E7U5CisITlWc7ev7eGWI8bV59uFaTofuqumhHbeMZMpUFYxJsMOPZF6PLfC3u"
        )
        extra_claims = %{user_id: user.id}
        {:ok, token, _claims} = JwtToken.generate_and_sign(extra_claims, signer)
        IO.inspect("#token #{token}")
        {:ok, claims} = JwtToken.verify_and_validate(token, signer)
        conn |> render("login.json", %{status: "success", message: "Login Successful", data: %{id: id}, token: token})
        IO.inspect(claims)
      else
      _ ->
        conn |> render("error.json", %{error: Utils.invalid_credentials()})
    end
  end
end

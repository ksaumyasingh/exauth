defmodule ExauthWeb.AuthView do
  use ExauthWeb, :view
  def render("ack.json", %{success: success, message: message}) do
    %{success: success, message: message}
  end
  def render("errors.json", %{errors: errors}) do
    %{success: false, errors: errors}
  end
  def render("error.json", %{error: error}) do
    %{success: false, error: error}
  end
end

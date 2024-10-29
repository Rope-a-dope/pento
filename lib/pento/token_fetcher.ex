defmodule Pento.TokenFetcher do
  def client_id, do: Application.get_env(:pento, Pento.Repo)[:client_id]
  def client_secret, do: Application.get_env(:pento, Pento.Repo)[:client_secret]
  def refresh_token, do: Application.get_env(:pento, Pento.Repo)[:refresh_token]

  def get_access_token() do
    body =
      Jason.encode!(%{
        "client_id" => client_id(),
        "client_secret" => client_secret(),
        "grant_type" => "refresh_token",
        "refresh_token" => refresh_token()
      })

    body
    |> request()
    |> response()
    |> access_token()
  end

  defp response({:ok, %Finch.Response{body: body}}) do
    Jason.decode!(body)
  end

  defp request(body) do
    headers = headers()

    Finch.build(:post, "https://oauth2.googleapis.com/token", headers, body)
    |> Finch.request(Pento.Finch)
  end

  defp headers do
    [{"content-type", "application/json"}]
  end

  defp access_token(body) do
    Map.get(body, "access_token")
  end
end

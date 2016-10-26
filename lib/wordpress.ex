defmodule Wordpress do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://public-api.wordpress.com/rest/v1.2/"
  plug Tesla.Middleware.Headers,
    %{
      "Authorization" => "Bearer #{Application.get_env(:papersist, :wordpress)[:access_token]}",
      "Content-Type" => "application/x-www-form-urlencoded"
    }
  plug Tesla.Middleware.DebugLogger

  adapter Tesla.Adapter.Ibrowse

  def create_post(title, content) do
    payload =
      %{
        title: title,
        content: content,
        status: "draft"
      }
    post("/sites/#{site_id()}/posts/new/", form_encode(payload))
  end

  def site_id() do
    Application.get_env(:papersist, :wordpress)[:site_id]
  end

  def form_encode(payload) do
    payload
      |> Enum.map(fn({k, v}) -> "#{k}=#{URI.encode(v)}" end)
      |> Enum.join("&")
  end
end

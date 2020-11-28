defmodule Eshop.Repo do
  use Ecto.Repo,
    otp_app: :eshop,
    adapter: Ecto.Adapters.Postgres

  def stream_preload(stream, size, preloads) do
    stream
    |> Stream.chunk_every(size)
    |> Stream.flat_map(fn chunk ->
      Eshop.Repo.preload(chunk, preloads)
    end)
  end
end

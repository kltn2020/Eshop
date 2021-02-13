defmodule EshopCore.Repo do
  use Ecto.Repo,
    otp_app: :eshop_core,
    adapter: Ecto.Adapters.Postgres

  def stream_preload(stream, size, preloads) do
    stream
    |> Stream.chunk_every(size)
    |> Stream.flat_map(fn chunk ->
      EshopCore.Repo.preload(chunk, preloads)
    end)
  end
end

defmodule Rauversion.Workers.TrackProcessorWorker do
  use Oban.Worker, queue: :default, max_attempts: 1

  # alias MyApp.{Endpoint, Zipper}

  def perform(%_{args: %{"track_id" => track_id, "file" => file}}) do
    IO.inspect("PERFORM TrackProcessorWorker")
    struct = Rauversion.Tracks.get_track!(track_id) |> Rauversion.Tracks.change_track()

    Rauversion.Tracks.broadcast_change({:ok, struct.data}, [:tracks, :mp3_converting])

    file = file |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)

    %{path: path, blob: blob} = Rauversion.Tracks.Track.convert_to_mp3(struct, file)

    Rauversion.Tracks.Track.process_peaks(struct, blob, path)

    IO.inspect("FINISH PERFORM TrackProcessorWorker")

    :ok
  end

  # ...
end

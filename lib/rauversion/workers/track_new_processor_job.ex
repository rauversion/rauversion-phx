defmodule Rauversion.Workers.TrackNewProcessorWorker do
  use Oban.Worker, queue: :default, max_attempts: 1

  def perform(%_{args: %{"track_id" => track_id}}) do
    IO.inspect("PERFORM Track NEW ProcessorWorker")
    Rauversion.Tracks.post_process_uploaded(Rauversion.Tracks.get_track!(track_id))
    :ok
  end

  # ...
end

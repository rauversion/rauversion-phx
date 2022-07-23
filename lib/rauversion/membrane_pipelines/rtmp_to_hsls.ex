defmodule Rauversion.RtmpToHls do
  use Membrane.Pipeline

  @impl true
  def handle_init(_opts) do
    spec = %ParentSpec{
      children: %{
        src: %Membrane.RTMP.SourceBin{port: 9009},
        sink: %Membrane.HTTPAdaptiveStream.SinkBin{
          manifest_module: Membrane.HTTPAdaptiveStream.HLS,
          target_window_duration: 20 |> Membrane.Time.seconds(),
          muxer_segment_duration: 8 |> Membrane.Time.seconds(),
          persist?: false,
          storage: %Membrane.HTTPAdaptiveStream.Storages.FileStorage{
            directory: "output"
          }
        }
      },
      links: [
        link(:src)
        |> via_out(:audio)
        |> via_in(Pad.ref(:input, :audio), options: [encoding: :AAC])
        |> to(:sink),
        link(:src)
        |> via_out(:video)
        |> via_in(Pad.ref(:input, :video), options: [encoding: :H264])
        |> to(:sink)
      ]
    }

    {{:ok, spec: spec, playback: :playing}, %{}}
  end

  def child_spec(_opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [nil]}
    }
  end
end

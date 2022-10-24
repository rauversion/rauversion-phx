defmodule Rauversion.Events.StreamingProviders.Mux do
  defstruct [:app_id, :api_key]

  def new(attrs) do
    %__MODULE__{} |> Map.merge(Enum.into(attrs, %{}))
  end

  def perform(data) do
    process(data)
  end

  def process(_struct) do
    {:ok, nil}
  end

  def definitions() do
    [
      %{type: :text_input, name: :playback_id, wrapper_class: "", placeholder: "playback id"},
      %{type: :text_input, name: :title, wrapper_class: "", placeholder: "video title"}
    ]
  end
end

defmodule Rauversion.Events.Schemas.Mux do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field :playback_id, :string
    field :title, :string
  end

  def changeset(email, params) do
    # playback-id={"QAkXTqnlILp6MOfwp6n00zSSn00fjFnrIPeurkNykz34s"}
    # metadata-video-title="Test VOD"
    # metadata-viewer-user-id="user-id-007">
    email
    |> cast(params, ~w(playback_id title)a)
    |> validate_required([:playback_id, :title])

    # |> validate_length(:app_id, min: 4)
  end
end

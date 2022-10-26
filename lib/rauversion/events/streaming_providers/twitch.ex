defmodule Rauversion.Events.StreamingProviders.Twitch do
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
      %{
        name: :streaming_type,
        wrapper_class: "sm:col-span-2",
        type: :select,
        options: ["channel", "video", "collection"]
      },
      %{
        type: :text_input,
        name: :streaming_identifier,
        wrapper_class: "",
        hint: "channel, video or collection"
      }
    ]
  end
end

defmodule Rauversion.Events.Schemas.Twitch do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field :streaming_type, :string
    field :streaming_identifier
    # //channel: "<channel ID>",
    # video: "738688473",
    # //collection: "<collection ID>",
  end

  def changeset(email, params) do
    email
    |> cast(params, ~w(streaming_type streaming_identifier)a)
    |> validate_required([:streaming_type, :streaming_identifier])

    # |> validate_length(:app_id, min: 4)
  end
end

defmodule Rauversion.Events.StreamingProviders.Restream do
  defstruct [:app_id, :player_url]

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
        type: :text_input,
        name: :player_url,
        wrapper_class: "",
        placeholder: "The player url",
        hint: "Example: https://player.restream.io/?token=1234"
      }
    ]
  end
end

defmodule Rauversion.Events.Schemas.Restream do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field :player_url, :string
    field :app_id, :string
  end

  def changeset(email, params) do
    email
    |> cast(params, ~w(player_url app_id)a)
    |> validate_required(:player_url)
    |> validate_length(:app_id, min: 4)
  end
end

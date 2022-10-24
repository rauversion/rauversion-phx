defmodule Rauversion.Events.StreamingProviders.Whereby do
  alias RauversionWeb.Router.Helpers, as: Routes

  defstruct [:app_id, :api_key]

  def new(attrs) do
    %__MODULE__{} |> Map.merge(Enum.into(attrs, %{}))
  end

  def perform(data) do
    process(data)
  end

  def process(struct) do
    {:ok, nil}
  end

  def definitions() do
    [
      %{
        type: :text_input,
        name: :room_url,
        wrapper_class: "",
        placeholder: "the room url",
        hint: "like: https://user.whereby.com/abc"
      }
    ]
  end
end

defmodule Rauversion.Events.Schemas.Whereby do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field :room_url, :string
  end

  def changeset(email, params) do
    email
    |> cast(params, ~w(room_url)a)
    |> validate_required(:room_url)

    # |> validate_length(:app_id, min: 4)
  end
end

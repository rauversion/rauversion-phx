defmodule Rauversion.Events.StreamingProviders.Zoom do
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
      %{type: :text_input, name: :meeting_url, wrapper_class: "", placeholder: "meeting url"},
      %{type: :text_input, name: :password, wrapper_class: "", placeholder: "meeting password"}
    ]
  end
end

defmodule Rauversion.Events.Schemas.Zoom do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field :meeting_url, :string
    field :password, :string
  end

  def changeset(email, params) do
    email
    |> cast(params, ~w(meeting_url password)a)
    |> validate_required(:meeting_url)
  end
end

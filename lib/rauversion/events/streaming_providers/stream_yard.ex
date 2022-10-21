defmodule Rauversion.Events.StreamingProviders.StreamYard do
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
        name: :youtube_url,
        wrapper_class: "",
        placeholder: "youtube url",
        hint: "when you stream via streamyard you can use the youtube url"
      }
    ]
  end
end

defmodule Rauversion.Events.Schemas.StreamYard do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field :youtube_url, :string
  end

  def changeset(email, params) do
    email
    |> cast(params, ~w(youtube_url)a)
    |> validate_required(:youtube_url)
  end
end

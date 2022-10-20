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
      %{type: :text_input, name: :api_key, wrapper_class: "", placeholder: "your api_key"},
      %{type: :text_input, name: :app_id, wrapper_class: "", placeholder: "your app id"}
    ]
  end
end

defmodule Rauversion.Events.Schemas.Whereby do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field :api_key, :string
    field :app_id, :string
  end

  def changeset(email, params) do
    email
    |> cast(params, ~w(api_key app_id)a)
    |> validate_required(:api_key)
    |> validate_length(:app_id, min: 4)
  end
end

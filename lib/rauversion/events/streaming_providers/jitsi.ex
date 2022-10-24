defmodule Rauversion.Events.StreamingProviders.Jitsi do
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
      %{type: :text_input, name: :api_key, wrapper_class: "", placeholder: "your api_key"},
      %{type: :text_input, name: :app_id, wrapper_class: "", placeholder: "your app id"}
    ]
  end
end

defmodule Rauversion.Events.Schemas.Jitsi do
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

# api key
# rrom name

#  <!DOCTYPE html>
#  <html>
#    <head>
#      <script src='https://8x8.vc/external_api.js' async></script>
#      <style>html, body, #jaas-container { height: 100%; }</style>
#      <script type="text/javascript">
#        window.onload = () => {
#          const api = new JitsiMeetExternalAPI("8x8.vc", {
#            roomName: "vpaas-magic-cookie-524984aaf0ae4f2fb5e2cb422e430137/SampleAppDefiniteHorizonsBreedAlready",
#            parentNode: document.querySelector('#jaas-container')
#          });
#        }
#      </script>
#    </head>
#    <body><div id="jaas-container" /></body>
#  </html>

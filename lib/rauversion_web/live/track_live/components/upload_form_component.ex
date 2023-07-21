defmodule RauversionWeb.TrackLive.UploadFormComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  def render(
        %{
          # uploads: _uploads,
          target: _target,
          track: _track,
          current_user: _current_user,
          changeset: _changeset
        } = assigns
      ) do
    ~H"""
    <div>
      <div phx-hook="AudioUploader" id="aaa">
        <div class="uploader flex justify-center"></div>
      </div>
    </div>
    """
  end
end

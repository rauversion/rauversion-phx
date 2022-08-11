defmodule RauversionWeb.TrackLive.ShareFormTrackComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  def render(
        %{
          track: _track
        } = assigns
      ) do
    ~H"""

    <div class="mt-6 sm:mt-5 space-y-6 sm:space-y-5 flex justify-center">
      <div class="overflow-hidden p-6 mb-0 leading-4 text-left bg-white border border-solid border-zinc-300 text-zinc-900 rounded-md">
        <div class="flex text-left">
          <div class="mr-4 text-zinc-800">
            <div
              class="relative w-32 h-32 text-center bg-no-repeat"
              style="height: 120px; width: 120px;"
            >
              <%= img_tag(Rauversion.Tracks.variant_url(
                @track, "cover", %{resize_to_limit: "120x120"}),
                class: "block relative w-32 h-32 bg-cover")
              %>

            </div>
          </div>
          <div class="overflow-hidden flex-1 font-sans text-zinc-800">
            <div class="mx-0 mt-0 mb-3 text-base font-normal">
              <div class="leading-5"><%= @track.title %></div>
              <div class="text-sm font-thin leading-5 text-neutral-500">
                <%= @track.user.username %>
              </div>
            </div>
            <div class="hidden overflow-hidden mt-0 mr-1 mb-1 ml-0 h-5"></div>

            <div class="">
              <%= if @track.private do %>
                <span
                  class="inline-block relative p-1 mb-1 font-thin text-white bg-brand-600 rounded border border-transparent border-solid hover:bg-neutral-200 hover:text-neutral-400">
                  <%= gettext "Private" %>
                </span>
              <% end %>
            </div>

            <div class="flex justify-between items-center">
              <div class="text-sm font-thin leading-5">
                <div class="">Upload complete.</div>
                <%= live_redirect to: Routes.track_show_path(@socket, :show, @track), class: "font-normal text-blue-500 cursor-pointer hover:text-zinc-800" do %>
                <%= gettext "Go to your track" %>
                <% end %>
              </div>

            </div>
          </div>
          <div class="flex flex-col pl-4 w-56 font-thin bg-white border-l border-solid border-zinc-100 text-neutral-400">
            <div class="flex-1">
              <h3 class="mx-0 mt-0 mb-1 font-sans text-sm font-normal">
              <%= gettext "Share your new track" %>
              </h3>

              <div class="">
                <.live_component
                  module={RauversionWeb.TrackLive.SharerComponent}
                  id="hero"
                  track={@track}
                />
              </div>
            </div>

            <div class="table clear-both">

              <label
                for="shareLink__field"
                class="overflow-hidden absolute p-0 -m-px w-px h-px border-0 cursor-default">
                <%= gettext "Link" %>
              </label>

              <input
                type="text"
                value={Routes.track_show_url(@socket, :show, @track, utm_source: "clipboard", utm_medium: "text", utm_campaign: "social_sharing")}
                class="inline-block py-px px-2 my-0 mr-2 ml-0 w-full font-sans text-sm leading-5 rounded border border-solid cursor-text box-border border-stone-300 focus:border-neutral-400"
                id="shareLink__field"
                readonly="readonly"
              />
            </div>
          </div>
        </div>
      </div>

    </div>

    """
  end
end

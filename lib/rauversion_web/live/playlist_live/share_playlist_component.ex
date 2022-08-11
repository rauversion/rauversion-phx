defmodule RauversionWeb.PlaylistLive.SharePlaylistComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  def render(%{track: track} = assigns) do
    ~H"""
      <div class="space-y-8 divide-y divide-gray-200 dark:divide-gray-800 sm:space-y-5">
        <div class="mx-2 py-6">
          <div class="relative">

            <nav class="flex space-x-4" aria-label="Tabs" data-controller="tabs">
              <a href="#" data-tab="#share-tab" data-action="click->tabs#changeTab" class="tab-link bg-brand-100 text-brand-700 px-3 py-2 font-medium text-sm rounded-md"> Share </a>
              <a href="#" data-tab="#embed-tab" data-action="click->tabs#changeTab" class="tab-link text-brand-500 hover:text-brand-700 px-3 py-2 font-medium text-sm rounded-md"> Embed </a>
              <a href="#" data-tab="#message-tab" data-action="click->tabs#changeTab" class="tab-link text-brand-500 hover:text-brand-700 px-3 py-2 font-medium text-sm rounded-md"> Message </a>
            </nav>

            <section id="share-tab" class="tab-pane block py-4">
              <h2 class="mx-0 mt-0 mb-4 font-sans text-base font-bold leading-none">
                Private Share
              </h2>
              <div class="mb-4 text-zinc-800">
                <div class="flex space-x-3">
                  <label
                    for="shareLink__field"
                    class="overflow-hidden absolute p-0 -m-px w-px h-px border-0 cursor-default">
                    <%= gettext "Link" %>
                  </label>

                  <div class="flex items-center space-x-3">
                    <input
                      type="text"
                      value={Routes.playlist_show_url(@socket, :private, Rauversion.Playlists.signed_id(track), utm_source: "clipboard", utm_campaign: "social_sharing", utm_medium: "text" )}
                      class="shadow-sm focus:ring-brand-500 focus:border-brand-500 block w-full sm:text-sm border-gray-300 rounded-md"
                      readonly="readonly"/>

                    <label class="flex items-center space-x-2">
                      <input
                        type="checkbox"
                        id=""
                        name="share_from"
                        class="focus:ring-brand-500 h-4 w-4 text-brand-600 dark:text-brand-400 border-gray-300 rounded"
                      />
                      <span class=""><%= gettext "at" %></span>
                    </label>

                    <input
                      type="text"
                      value="0:00"
                      class="shadow-sm focus:ring-brand-500 focus:border-brand-500 block w-full sm:text-sm border-gray-300 rounded-md"
                    />
                  </div>
                </div>
              </div>
              <div class="text-sm text-gray-700 dark:text-gray-300 py-2">
                <%= gettext "This track is set to private and can only be shared using the secret link above." %>
                <br class="" />
                <%= gettext "You can reset the secret link if you want to revoke access." %>
              </div>
              <div class="hidden mb-4 text-brand-600 dark:text-brand-400">
              <%= gettext "Are you sure you want to reset this link?<br /> It will not be possible to access this track from any existing shares." %>
              </div>
              <div
                class="hidden visible py-1 px-0 mb-4 font-sans text-xs text-red-700 opacity-100">
                <%= gettext "There was a problem resetting the link. Please try again later." %>
              </div>
              <div class="text-zinc-800">
                <button
                  type="button"
                  class="inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-brand-600 hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500">
                  <%= gettext "Reset secret link" %>
                </button>

                <div class="hidden">
                  <button
                    type="button"
                    class="inline-block relative py-px pr-3 pl-2 m-0 h-6 font-sans text-sm font-thin leading-5 text-center text-white whitespace-nowrap bg-brand-600 rounded-sm border border-brand-600 border-solid cursor-pointer select-none box-border focus:border-brand-600 focus:bg-brand-600 focus:text-white hover:border-brand-600 hover:bg-brand-600 hover:text-white">
                    <%= gettext "Reset" %>
                  </button>
                  <button
                    type="button"
                    class="inline-block relative py-1 pr-3 pl-2 m-0 h-6 font-sans text-sm font-thin leading-5 text-center whitespace-nowrap bg-none rounded-sm border-0 border-solid cursor-pointer select-none box-border border-neutral-200 focus:border-0 focus:border-stone-300 focus:bg-none focus:py-1 focus:text-zinc-800 hover:border-0 hover:border-stone-300 hover:bg-none hover:py-1 hover:text-zinc-800">
                    <%= gettext "Cancel" %>
                  </button>
                </div>

              </div>

              <div class="hidden text-zinc-800">
              <%= gettext "The secret link has been successfully reset." %>
              </div>

            </section>

            <section id="embed-tab" class="tab-pane hidden py-4">
              <h2 class="mx-0 mt-0 mb-4 font-sans text-base font-bold leading-none">
              <%= gettext "Embed" %>
              </h2>
              <input type="text"
                value={Routes.embed_url(@socket, :show, track)}
                class="shadow-sm focus:ring-brand-500 focus:border-brand-500 block w-full sm:text-sm border-gray-300 rounded-md"
              />

              <input type="text"
                value={Routes.embed_url(@socket, :private_playlist, Rauversion.Playlists.signed_id(track) )}
                class="shadow-sm focus:ring-brand-500 focus:border-brand-500 block w-full sm:text-sm border-gray-300 rounded-md"
              />

              <iframe
                width="100%"
                height="200"
                scrolling="no"
                frameborder="no"
                allow="autoplay"
                src={Routes.embed_url(@socket, :show, track)}>
              </iframe>
              <div
                style="font-size: 10px;
                  color: #cccccc;
                  line-break: anywhere;
                  word-break: normal;
                  overflow: hidden;
                  white-space: nowrap;
                  text-overflow: ellipsis;
                  font-family: Interstate, Lucida Grande, Lucida Sans Unicode, Lucida Sans,
                  Garuda, Verdana, Tahoma, sans-serif;
                  font-weight: 100;">
                <a
                  href={Routes.profile_index_path(@socket, :index, track.user)}
                  title="waverzap"
                  target="_blank"
                  style="color: #cccccc; text-decoration: none;">
                  <%= track.user.username %>
                </a>
                ·
                <a
                  href={Routes.track_show_path(@socket, :show, track)}
                  title={track.title}
                  target="_blank"
                  style="color: #cccccc; text-decoration: none;">
                  <%= @track.title %>
                </a>
              </div>

              <p class="text-sm text-gray-700 dark:text-gray-300 py-2">
              <%= gettext "This player uses cookies in accordance with our Cookies policy.
                We may collect usage data for analytics purposes.
                It is your responsibility to disclose this to visitors of any site where you embed the player." %>
              </p>
            </section>

            <section id="message-tab" class="tab-pane hidden py-4">
              <h2 class="mx-0 mt-0 mb-4 font-sans text-base font-bold leading-none">
              <%= gettext "Message" %>
              </h2>
              Soon!
            </section>

          </div>
        </div>
      </div>
    """
  end
end

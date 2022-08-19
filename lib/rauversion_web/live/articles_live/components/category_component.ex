defmodule RauversionWeb.ArticlesLive.CategoryComponent do
  use RauversionWeb, :live_component

  alias Rauversion.Posts

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:posts, list_posts_on_category(assigns.category_slug))}
  end

  defp list_posts_on_category(slug) do
    category = Rauversion.Categories.get_category_by_slug!(slug)

    Posts.list_posts("published")
    |> Posts.with_category(category)
    |> Rauversion.Repo.paginate(page: 1, page_size: 3)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>

      <section class="pb-10 mb-10 text-black bg-gray-800">

        <div class="flex flex-row mb-6 justify-end">
          <div class="mx-4 pt-5 border-b border-purple-900 border-solid box-border w-full">
              <div class="flex justify-end">
                <div class="inline-block relative z-20 mr-5 text-purple-50">
                  <button class="overflow-visible relative z-10 py-6 px-8 m-0 w-full text-lg font-semibold tracking-wider leading-6 text-center uppercase bg-none border-0 cursor-pointer">
                    <svg class="inline-block relative mr-3 w-4 h-2 leading-4 uppercase box-border" x="0px" y="0px" viewBox="0 0 10 5.7" enable-background="new 0 0 10 5.7">
                      <path fill-rule="evenodd" clip-rule="evenodd" d="M1.3,0.2L5,4l3.8-3.8l0,0C8.9,0.1,9.1,0,9.3,0 C9.7,0,10,0.3,10,0.7c0,0.2-0.1,0.4-0.2,0.5l0,0L5.5,5.5l0,0C5.4,5.6,5.2,5.7,5,5.7l0,0c0,0,0,0,0,0c-0.2,0-0.4-0.1-0.5-0.2l0,0 L0.2,1.2l0,0C0.1,1.1,0,0.9,0,0.7C0,0.3,0.3,0,0.7,0C0.9,0,1.1,0.1,1.3,0.2z" class="uppercase box-border"></path>
                    </svg>
                    <span class="leading-4 uppercase box-border">Genres</span>
                  </button>
                </div>
              </div>
            </div>
        </div>

        <div class="table clear-both px-10 mx-auto max-w-screen-xl">
          <div class="box-border">
            <div class="-mx-5 box-border lg:flex">

              <a href="/thepitch/tiacorine-dipset-new-music-listen/"
                class="relative px-5 bg-transparent cursor-pointer md:float-left md:w-1/2 lg:flex lg:flex-col box-border text-zinc-800 hover:text-red-500"
                data-uri="724341fb2b678f104416767655f7b415">

                <img src="https://media.pitchfork.com/photos/62fd76ee4562e7a7a666c0d9/2:1/w_648/TiaCorine.jpg"
                  alt="TiaCorine"
                  class="block w-full h-auto border-0 box-border lg:flex-shrink lg:flex-grow lg:basis-full lg:object-cover"
                />

              </a>

              <div class="py-10 px-5 text-left md:py-0 lg:float-left- lg:w-1/2">

                <a href="/thepitch/tiacorine-dipset-new-music-listen/"
                  class="block bg-transparent cursor-pointer box-border text-zinc-800 hover:text-red-500"
                  data-uri="724341fb2b678f104416767655f7b415">
                  <h2 class="inline my-0 mr-5 ml-0 text-5xl font-bold text-white md:font-serif">
                    Listen to TiaCorine’s “Dipset”: The&nbsp;Ones
                  </h2>
                </a>

                <div class="my-5 mx-0 text-2xl leading-normal text-fuchsia-200 md:text-2xl">
                  <p class="m-0 text-base font-normal leading-5 box-border">
                  The must-hear rap song of the day
                  </p>
                </div>

                <div class="pt-0 box-border md:py-0 lg:pr-10">
                  <ul class="inline p-0 m-0 text-base font-semibold tracking-wider leading-loose list-none uppercase">
                    <li class="inline leading-5 text-left uppercase box-border">
                      <span class="text-purple-50 uppercase box-border">by:
                        <!-- -->Dylan Green
                      </span>
                    </li>
                  </ul>

                  <div class="text-base font-semibold tracking-wider leading-loose uppercase">
                    <time
                      class="text-purple-50 uppercase"
                      datetime="2022-08-17T20:30:07"
                      title="Wed Aug 17 2022 16:30:07 GMT-0400 (hora estándar de Chile)">
                      23 hrs ago
                    </time>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

      </section>



      <%= live_component(
        RauversionWeb.ArticlesLive.ArticlesHighlightsListComponent,
        id: "all-posts-published",
        page: 1,
        current_user: assigns[:current_user]
      )
      %>

    </div>
    """
  end
end

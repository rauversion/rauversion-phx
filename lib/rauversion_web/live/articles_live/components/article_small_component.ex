defmodule RauversionWeb.Live.ArticlesLive.ArticleSmallComponent do
  use RauversionWeb, :live_component

  def render(assigns) do
    ~H"""
      <div>
        <div class="grid items-center py-4 mb-0 leading-8 text-black border-b border-solid cursor-pointer box-border border-stone-300 lg:clear-both lg:table xl:clear-both xl:table md:pb-0">
          <div class="text-black lg:hidden xl:float-right xl:mt-0 xl:ml-4 box-border">
          </div>

          <div class="col-span-full p-0 mb-auto text-white box-border">
            <a
              classss="hidden mb-4 w-20 bg-transparent border-b border-red-500 border-solid duration-200 md:block box-border hover:text-black focus:text-black"
              href="/news/swizz-beatz-and-timbaland-sue-triller-for-dollar28-million-demand-payment-for-verzuz-sale/">
              <h2 class="mt-0 mb-2 font-sans text-base not-italic font-semibold leading-5 normal-case box-border lg:text-4xl-- lg:leading-5 md:mb-4 md:font-sans md:text-4xl-- md:font-bold md:normal-case md:not-italic md:leading-5">
                Swizz Beatz and Timbaland Sue Triller for $28 Million Over Verzuz Sale
              </h2>
            </a>
            <div class="cursor-pointer box-border">
              <div class="mb-1 box-border">
                <div class="box-border">
                  <div class="box-border text-zinc-900">
                    <p
                      class="block mx-0 mt-2 mb-0 font-sans text-sm not-italic font-normal leading-6 text-left normal-case box-border text-zinc-800"
                      itemprop="author"
                      itemtype="http://schema.org/Person"
                    >
                      <span itemprop="name" class="leading-5 box-border">
                        <span class="inline-block not-italic normal-case box-border text-gray-300">
                          <span class="m-0 not-italic normal-case box-border">By </span>
                            Evan Minsker
                          </span>
                        </span>
                    </p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    """
  end
end

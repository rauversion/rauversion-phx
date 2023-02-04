defmodule RauversionWeb.MerchLive.Index do
  use RauversionWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="px-4 sm:px-6 lg:px-8">

      <div class="sm:flex sm:items-center">
        <div class="sm:flex-auto">
          <h1 class="text-xl font-semibold text-gray-900 dark:text-gray-100"><%= gettext("Merch") %></h1>
          <p class="mt-2 text-sm text-gray-700 dark:text-gray-300"><%= gettext("Your merch") %></p>
        </div>
        <div class="mt-4 sm:mt-0 sm:ml-16 sm:flex-none">
          <a href="/events/new" class="inline-flex items-center justify-center rounded-md border border-transparent bg-brand-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-brand-500 focus:ring-offset-2 sm:w-auto" data-phx-link="redirect" data-phx-link-state="push">New event</a>
        </div>
      </div>

      <div class="mt-8 flex flex-col">
        <div class="-my-2 -mx-4 overflow-x-auto sm:-mx-6 lg:-mx-8">
          <div class="inline-block min-w-full py-2 align-middle md:px-6 lg:px-8">
            <div class="overflow-hidden shadow ring-1 ring-black ring-opacity-5 md:rounded-lg">
              <table class="min-w-full divide-y divide-gray-300 dark:text-gray-700">
                <thead class="bg-gray-50">
                  <tr>
                    <th scope="col" class="px-3 py-3 text-left text-xs font-medium uppercase tracking-wide text-gray-500 dark:text-gray-200 dark:bg-gray-900">Title</th>
                    <th scope="col" class="px-3 py-3 text-left text-xs font-medium uppercase tracking-wide text-gray-500 dark:text-gray-200 dark:bg-gray-900">Author</th>
                    <th scope="col" class="px-3 py-3 text-left text-xs font-medium uppercase tracking-wide text-gray-500 dark:text-gray-200 dark:bg-gray-900">Status</th>
                    <th scope="col" class="relative py-3 pl-3 pr-4 sm:pr-6 dark:text-gray-200 dark:bg-gray-900 ">
                      <span class="sr-only">Edit</span>
                    </th>
                  </tr>
                </thead>
                <tbody class="divide-y divide-gray-200 dark:divide-gray-800 bg-white dark:bg-black">

                    <tr>
                      <td class="whitespace-nowrap py-4 pl-4 pr-3 text-sm font-medium text-gray-900 dark:text-gray-200 dark:bg-gray-900 sm:pl-6">
                        otro viejo
                      </td>

                      <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500 dark:text-gray-200 dark:bg-gray-900">
                        oijoijoij
                      </td>
                      <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500 dark:text-gray-200 dark:bg-gray-900">
                        published
                      </td>
                      <td class="relative whitespace-nowrap py-4 pl-3 pr-4 text-right text-sm font-medium sm:pr-6 dark:text-gray-200 dark:bg-gray-900">
                        <a href="/events/edit/otro-viejo" class="text-brand-600 hover:text-brand-900" data-phx-link="redirect" data-phx-link-state="push">
                          Edit
                        </a>
                      </td>
                    </tr>

                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>

    </div>
    """
  end
end

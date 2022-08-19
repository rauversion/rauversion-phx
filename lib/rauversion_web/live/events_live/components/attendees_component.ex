defmodule RauversionWeb.Live.EventsLive.Components.AttendeesComponent do
  use RauversionWeb, :live_component

  def render(assigns) do
    ~H"""
      <div class="px-4 sm:px-6 lg:px-8 w-full">
        <div class="sm:flex sm:items-center">
          <div class="sm:flex-auto">
            <h1 class="text-xl font-semibold text-gray-900 dark:text-gray-100">Users</h1>
            <p class="mt-2 text-sm text-gray-700 dark:text-gray-300">A list of all the users in your account including their name, title, email and role.</p>
          </div>
          <div class="mt-4 sm:mt-0 sm:ml-16 sm:flex-none">
            <button type="button" class="inline-flex items-center justify-center rounded-md border border-transparent bg-brand-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-brand-500 focus:ring-offset-2 sm:w-auto">Add user</button>
          </div>
        </div>
        <div class="-mx-4 mt-8 overflow-hidden shadow ring-1 ring-black ring-opacity-5 sm:-mx-6 md:mx-0 md:rounded-lg">
          <table class="min-w-full divide-y divide-gray-300 dark:divide-gray-700">
            <thead class="bg-gray-50 dark:bg-gray-800">
              <tr>
                <th scope="col" class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 dark:text-gray-100 sm:pl-6">Name</th>
                <th scope="col" class="hidden px-3 py-3.5 text-left text-sm font-semibold text-gray-900 dark:text-gray-100 lg:table-cell">Title</th>
                <th scope="col" class="hidden px-3 py-3.5 text-left text-sm font-semibold text-gray-900 dark:text-gray-100 sm:table-cell">Email</th>
                <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900 dark:text-gray-100">Role</th>
                <th scope="col" class="relative py-3.5 pl-3 pr-4 sm:pr-6">
                  <span class="sr-only">Edit</span>
                </th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-200 bg-white dark:bg-gray-900">
              <tr>
                <td class="w-full max-w-0 py-4 pl-4 pr-3 text-sm font-medium text-gray-900 dark:text-gray-100 sm:w-auto sm:max-w-none sm:pl-6">
                  Lindsay Walton
                  <dl class="font-normal lg:hidden">
                    <dt class="sr-only">Title</dt>
                    <dd class="mt-1 truncate text-gray-700 dark:text-gray-300">Front-end Developer</dd>
                    <dt class="sr-only sm:hidden">Email</dt>
                    <dd class="mt-1 truncate text-gray-500 sm:hidden">lindsay.walton@example.com</dd>
                  </dl>
                </td>
                <td class="hidden px-3 py-4 text-sm text-gray-500 dark:text-gray-300 lg:table-cell">Front-end Developer</td>
                <td class="hidden px-3 py-4 text-sm text-gray-500 dark:text-gray-300 sm:table-cell">lindsay.walton@example.com</td>
                <td class="px-3 py-4 text-sm text-gray-500 dark:text-gray-300">Member</td>
                <td class="py-4 pl-3 pr-4 text-right text-sm font-medium sm:pr-6">
                  <a href="#" class="text-brand-600 hover:text-brand-900">Edit<span class="sr-only">, Lindsay Walton</span></a>
                </td>
              </tr>

              <!-- More people... -->
            </tbody>
          </table>
        </div>
      </div>
    """
  end
end

defmodule RauversionWeb.UserSettingsLive.NavBar do
  #use Phoenix.Component
  use RauversionWeb, :live_component


  def render(assigns) do
    ~H"""
    <nav aria-label="Sections" class="hidden flex-shrink-0 w-96 bg-white border-r border-blue-gray-200 xl:flex xl:flex-col">
      <div class="flex-shrink-0 h-16 px-6 border-b border-blue-gray-200 flex items-center">
        <p class="text-lg font-medium text-blue-gray-900">Settings</p>
      </div>

      <div class="flex-1 min-h-0 overflow-y-auto">
          <%= if @live_action == :contact do %>
          <a href="/users/settings" class="bg-blue-50 bg-opacity-50 flex p-6 border-b border-blue-gray-200" aria-current="page" x-state:on="Current" x-state:off="Default" x-state-description="Current: &quot;bg-blue-50 bg-opacity-50&quot;, Default: &quot;hover:bg-blue-50 hover:bg-opacity-50&quot;">
          <svg class="flex-shrink-0 -mt-0.5 h-6 w-6 text-blue-gray-400" x-description="Heroicon name: outline/cog" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"></path>
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
            </svg>
            <div class="ml-3 text-sm">
              <p class="font-medium text-blue-gray-900">Account</p>
              <p class="mt-1 text-blue-gray-500">Basic Account Information.</p>
            </div>
          </a>
          <% else %>
          <a href="/users/settings" class="hover:bg-blue-50 hover:bg-opacity-50 flex p-6 border-b border-blue-gray-200" x-state-description="undefined: &quot;bg-blue-50 bg-opacity-50&quot;, undefined: &quot;hover:bg-blue-50 hover:bg-opacity-50&quot;">
          <svg class="flex-shrink-0 -mt-0.5 h-6 w-6 text-blue-gray-400" x-description="Heroicon name: outline/cog" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"></path>
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
            </svg>
            <div class="ml-3 text-sm">
              <p class="font-medium text-blue-gray-900">Account</p>
              <p class="mt-1 text-blue-gray-500">Basic Account Information.</p>
            </div>
          </a>
          <% end %>


          <%= if @live_action == :email do %>
          <a href="/users/settings/email" class="bg-blue-50 bg-opacity-50 flex p-6 border-b border-blue-gray-200" aria-current="page" x-state:on="Current" x-state:off="Default" x-state-description="Current: &quot;bg-blue-50 bg-opacity-50&quot;, Default: &quot;hover:bg-blue-50 hover:bg-opacity-50&quot;">
            <svg class="flex-shrink-0 -mt-0.5 h-6 w-6 text-blue-gray-400" x-description="Heroicon name: outline/mail" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
               <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
            </svg>
            <div class="ml-3 text-sm">
              <p class="font-medium text-blue-gray-900">Change Email</p>
              <p class="mt-1 text-blue-gray-500">Change Email  information.</p>
            </div>
          </a>
          <% else %>
          <a href="/users/settings/email" class="hover:bg-blue-50 hover:bg-opacity-50 flex p-6 border-b border-blue-gray-200" x-state-description="undefined: &quot;bg-blue-50 bg-opacity-50&quot;, undefined: &quot;hover:bg-blue-50 hover:bg-opacity-50&quot;">
            <svg class="flex-shrink-0 -mt-0.5 h-6 w-6 text-blue-gray-400" x-description="Heroicon name: outline/mail" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
               <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
            </svg>
            <div class="ml-3 text-sm">
              <p class="font-medium text-blue-gray-900">Change Email</p>
              <p class="mt-1 text-blue-gray-500">Change Email  information.</p>
            </div>
          </a>
          <% end %>

          <%= if @live_action == :security do %>
          <a href="/users/settings/security" class="bg-blue-50 bg-opacity-50 flex p-6 border-b border-blue-gray-200" aria-current="page" x-state:on="Current" x-state:off="Default" x-state-description="Current: &quot;bg-blue-50 bg-opacity-50&quot;, Default: &quot;hover:bg-blue-50 hover:bg-opacity-50&quot;">
          <svg class="flex-shrink-0 -mt-0.5 h-6 w-6 text-blue-gray-400" x-description="Heroicon name: outline/key" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z"></path>
          </svg>
          <div class="ml-3 text-sm">
            <p class="font-medium text-blue-gray-900">Security</p>
            <p class="mt-1 text-blue-gray-500">Change your credentials.</p>
          </div>
        </a>
          <% else %>
          <a href="/users/settings/security" class="hover:bg-blue-50 hover:bg-opacity-50 flex p-6 border-b border-blue-gray-200" x-state-description="undefined: &quot;bg-blue-50 bg-opacity-50&quot;, undefined: &quot;hover:bg-blue-50 hover:bg-opacity-50&quot;">
            <svg class="flex-shrink-0 -mt-0.5 h-6 w-6 text-blue-gray-400" x-description="Heroicon name: outline/key" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z"></path>
            </svg>
            <div class="ml-3 text-sm">
              <p class="font-medium text-blue-gray-900">Security</p>
              <p class="mt-1 text-blue-gray-500">Change your credentials.</p>
            </div>
          </a>
          <% end %>
      </div>

    </nav>
    """
  end
end

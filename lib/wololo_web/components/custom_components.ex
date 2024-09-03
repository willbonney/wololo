defmodule WololoWeb.CustomComponents do
  use WololoWeb, :html
  # from https://fly.io/phoenix-files/phoenix-liveview-and-sqlite-autocomplete/
  attr(:id, :string, required: true)
  attr(:show, :boolean, default: false)
  attr(:on_cancel, JS, default: %JS{})
  slot(:inner_block, required: true)

  def search_modal(assigns) do
    ~H"""
    <div
      id={@id}
      phx-mounted={@show && show_modal(@id)}
      phx-remove={hide_modal(@id)}
      class="relative z-50 hidden"
    >
      <div id={"#{@id}-bg"} class="fixed inset-0 bg-zinc-50/90 transition-opacity" aria-hidden="true" />
      <div
        class="fixed inset-0 overflow-y-auto"
        aria-labelledby={"#{@id}-title"}
        aria-describedby={"#{@id}-description"}
        role="dialog"
        aria-modal="true"
        tabindex="0"
      >
        <div class="flex min-h-full justify-center">
          <div class="w-full min-h-12 max-w-3xl p-2 sm:p-4 lg:py-6">
            <.focus_wrap
              id={"#{@id}-container"}
              phx-mounted={@show && show_modal(@id)}
              phx-window-keydown={hide_modal(@on_cancel, @id)}
              phx-key="escape"
              phx-click-away={hide_modal(@on_cancel, @id)}
              class="hidden relative rounded-2xl bg-white p-2 shadow-lg shadow-zinc-700/10 ring-1 ring-zinc-700/10 transition min-h-[30vh] max-h-[50vh] overflow-y-scroll"
            >
              <div id={"#{@id}-content"}>
                <%= render_slot(@inner_block) %>
              </div>
            </.focus_wrap>
          </div>
        </div>
      </div>
    </div>
    """
  end

  attr(:players, :list)

  def search_results(assigns) do
    ~H"""
    <ul class="-mb-2 py-2 text-sm text-gray-800 flex flex-col space-y-2 " id="options" role="listbox">
      <li
        :if={@players == []}
        id="option-none"
        role="option"
        tabindex="-1"
        class="cursor-default select-none px-4 py-2 text-xl"
      >
        No Results
      </li>
      <%= for player <- @players do %>
        <li
          class="cursor-default select-none rounded-md px-4 py-2 text-xl bg-zinc-100 hover:bg-zinc-200 hover:cursor-pointer flex flex-row space-x-2 items-center"
          id={"option-#{player["name"]}"}
          role="option"
          tabindex="-1"
          phx-click="select-player"
          phx-value-id={player["profile_id"]}
        >
          <div>
            <img class="mr-2" src={player["avatars"]["medium"]} />
          </div>
          <div class="flex flex-col">
            <h2 class="text-xl font-bold"><%= player["name"] %></h2>
            <div class="flex flex-row">
              <p class="text-gray-400 mr-2">#<%= player["rank"] %></p>
              <p class="text-gray-400 mr-2"><%= player["rating"] %></p>
              <p class="text-gray-400 mr-2"><%= player["win_rate"] %>%</p>
            </div>
          </div>
        </li>
      <% end %>
    </ul>
    """
  end

  attr(:rest, :global)

  def search_input(assigns) do
    ~H"""
    <div class="relative ">
      <!-- Heroicon name: mini/magnifying-glass -->
      <input
        {@rest}
        type="text"
        class="h-12 w-full border-none focus:ring-0 pl-11 pr-4 text-gray-800 placeholder-gray-400 sm:text-sm"
        placeholder="Search the docs.."
        role="combobox"
        aria-expanded="false"
        aria-controls="options"
      />
    </div>
    """
  end
end
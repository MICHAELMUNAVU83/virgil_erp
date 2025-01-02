defmodule VirgilErpWeb.TodosComponents do
  use Phoenix.Component

  import VirgilErpWeb.CoreComponents

  def todos_component(assigns) do
    ~H"""
    <div>
      <p class="font-semibold  text-white text-xl">
        Your Todos
      </p>

      <div class="flex text-white justify-between items-center">
        <p class="font-medium">
          December 2024
        </p>

        <div class="w-[30%] text-white  border-[1px] border-gray-500 rounded-md  flex justify-between items-center">
          <div class=" border-r-[1px] border-gray-500 p-2">
            <i class="fa fa-chevron-left"></i>
          </div>

          <div class="w-[80%] p-2 flex justify-center items-center">
            The Date Today
          </div>
          <div class=" border-l-[1px] border-gray-500 p-2">
            <i class="fa fa-chevron-right"></i>
          </div>
        </div>
      </div>

      <.dates_navigation />
    </div>
    """
  end

  defp dates_navigation(assigns) do
    ~H"""
    <div class="flex flex-col gap-1">
      <div class="w-[100%] mt-6 grid grid-cols-7 gap-4">
        <%= for date <- sample_dates_navigation() do %>
          <.date_navigation_component date={date} />
        <% end %>
      </div>
      <p class="bg-gray-500 h-[1px] w-[100%]" />
    </div>
    """
  end

  defp date_navigation_component(assigns) do
    ~H"""
    <div class="flex justify-center items-center  text-white">
      {@date.name}
    </div>
    """
  end

  def new_todo_component(assigns) do
    ~H"""
    <.simple_new_todo_form
      for={@form}
      id="todo-form"
      class="border-[1px] border-gray-500 rounded-md  mt-8"
      phx-submit="save_todo"
    >
      <div class="p-2">
        <.new_todo_input
          field={@form[:name]}
          type="text"
          name="name"
          class="border-none w-[100%] focus:border-none text-white  focus:ring-0 bg-transparent placeholder-grey-500 border-transparent"
          placeholder="Enter todo name..."
          autocomplete="off"
        />
        <.new_todo_input
          field={@form[:description]}
          type="textarea"
          name="description"
          autocomplete="off"
          class="border-none w-[100%] focus:border-none text-white  focus:ring-0 bg-transparent placeholder-grey-500 border-transparent"
          placeholder="Description..."
        />

        <div class="flex gap-4 items-center">
          <div class="flex items-center border border-gray-500 p-2 text-xs rounded-md text-white cursor-pointer">
            <div id="date-picker-container" phx-hook="FlatpickrHook" class="relative cursor-pointer">
              <p id="togglePicker">
                <span class="mr-2"><i class="fa fa-calendar"></i></span> {@selected_date || "Today"}
              </p>

              <input
                type="text"
                id="datepicker"
                class="absolute top-0 left-0 w-full h-full opacity-0"
                phx-change="date_selected"
              />
            </div>
            <span phx-click="clear_date" class="ml-2"><i class="fa fa-times"></i></span>
          </div>

          <div
            id="priority-container"
            phx-hook="OutsideClickHook"
            class="flex relative cursor-pointer items-center border-[0.5px] p-2 text-xs border-gray-500 rounded-md text-white"
          >
            <p phx-click="toggle_priority_list">
              <%= if @selected_priority do %>
                <i
                  class={"fa fa-flag text-#{@selected_priority_color}"}
                  class="mr-2"
                  aria-hidden="true"
                >
                </i>
                {@selected_priority}
                <span phx-click="clear_priority" class="ml-2"><i class="fa fa-times"></i></span>
              <% else %>
                <i class="fa fa-flag" aria-hidden="true" class="mr-2"></i> Priority
              <% end %>
            </p>

            <div :if={@show_priority_list} class="absolute top-10 left-0  w-[120px] h-full">
              <.priority_list selected_priority={@selected_priority} />
            </div>
          </div>

          <div class="flex items-center border border-gray-500 p-2 text-xs rounded-md text-white cursor-pointer">
            <div
              id="date-picker-container"
              phx-hook="FlatpickrHookDateTime"
              class="relative cursor-pointer"
            >
              <p id="togglePickerDateTime">
                <span class="mr-2"><i class="fa fa-calendar"></i></span> {@selected_datetime ||
                  "Reminders"}
              </p>

              <input
                type="text"
                id="datetimepicker"
                class="absolute top-0 left-0 w-full h-full opacity-0"
                phx-change="datetime_selected"
              />
            </div>
            <span phx-click="clear_datetime" class="ml-2"><i class="fa fa-times"></i></span>
          </div>
        </div>
      </div>

      <p class="flex w-[100%] bg-gray-500 h-[1px]" />

      <div class="flex gap-2  p-2 justify-end text-gray-500 items-center">
        <p>
          Cancel
        </p>

        <button
          class="bg-dark_purple flex justify-center items-center text-xs  p-2 rounded-md text-white"
          phx-disable-with="Saving..."
        >
          Save Todo
        </button>
      </div>
    </.simple_new_todo_form>
    """
  end

  def priority_list(assigns) do
    ~H"""
    <div class="bg-white p-2 text-sm rounded-md text-black">
      <%= for priority <- priorities() do %>
        <p phx-click="select_priority" phx-value-priority-name={priority.name} class="cursor-pointer">
          <i class={"fa fa-flag text-#{priority.color}"} aria-hidden="true"></i> {priority.name}
          <i
            :if={@selected_priority == priority.name}
            class="fa fa-check text-green-500"
            aria-hidden="true"
          >
          </i>
        </p>
      <% end %>
    </div>
    """
  end

  defp sample_dates_navigation do
    [
      %{
        name: "Sun 29"
      },
      %{
        name: "Sun 29"
      },
      %{
        name: "Sun 29"
      },
      %{
        name: "Sun 29"
      },
      %{
        name: "Sun 29"
      },
      %{
        name: "Sun 29"
      },
      %{
        name: "Sun 29"
      }
    ]
  end

  defp priorities do
    [
      %{
        name: "Priority 1",
        color: "red-500"
      },
      %{
        name: "Priority 2",
        color: "yellow-500"
      },
      %{
        name: "Priority 3",
        color: "blue-500"
      },
      %{
        name: "Priority 4",
        color: "gray-300"
      }
    ]
  end
end

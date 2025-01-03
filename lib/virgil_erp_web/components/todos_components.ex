defmodule VirgilErpWeb.TodosComponents do
  use Phoenix.Component

  import VirgilErpWeb.CoreComponents
  alias VirgilErp.DateFormatter

  def todos_component(assigns) do
    ~H"""
    <div>
      <p class="font-semibold  text-white text-xl">
        Your Todos
      </p>

      <div class="flex text-white justify-between items-center">
        <p class="font-medium">
          {DateFormatter.get_month_and_year(@active_date)}
        </p>

        <div class="w-[20%] text-white  border-[1px] border-gray-500 rounded-md  flex justify-between items-center">
          <div class=" cursor-pointer border-r-[1px] border-gray-500 p-2" phx-click="previous_week">
            <i class="fa fa-chevron-left"></i>
          </div>

          <div class="w-[80%] p-2 flex justify-center items-center">
            {List.first(@dates_for_selection) |> Map.get(:day_number)} - {List.last(
              @dates_for_selection
            )
            |> Map.get(:day_number)}
          </div>
          <div class="cursor-pointer border-l-[1px] border-gray-500 p-2" phx-click="next_week">
            <i class="fa fa-chevron-right"></i>
          </div>
        </div>
      </div>

      <.dates_navigation active_date={@active_date} dates_for_selection={@dates_for_selection} />

      <.todos_for_date todos={@todos} />

      <div
        class="flex mt-4  text-lg font-medium text-white cursor-pointer  gap-2 items-center"
        phx-click="show_new_todo_form"
      >
        <p class="bg-dark_purple text-white w-[30px] h-[30px] rounded-md flex justify-center items-center">
          +
        </p>
        Add Todo
      </div>
    </div>
    """
  end

  defp todos_for_date(assigns) do
    ~H"""
    <div class="w-[100%] mt-6 grid grid-cols-1 gap-4">
      <%= for todo <- @todos do %>
        <.todo_component todo={todo} />
      <% end %>
    </div>
    """
  end

  defp todo_component(assigns) do
    ~H"""
    <div class="border-b-[1px] border-gray-500 p-2 ">
      <div class="flex gap-2 items-start ">
        <div
          class="w-[20px] h-[20px] mt-1 border-[1px] border-grey-500  cursor-pointer group rounded-full"
          phx-click="complete_todo"
          phx-value-id={@todo.id}
        >
          <p class="bg-dark_purple group-hover:flex justify-center items-center hidden w-[100%] h-[100%] rounded-full">
            <i class="fa fa-check text-white"></i>
          </p>
        </div>
        <div
          phx-click="edit_todo"
          phx-value-id={@todo.id}
          class="flex w-[100%] cursor-pointer text-white   flex-col gap-1"
        >
          <p>
            {@todo.name}
          </p>
          <p class="text-gray-500">
            {@todo.description}
          </p>
        </div>
      </div>
    </div>
    """
  end

  defp dates_navigation(assigns) do
    ~H"""
    <div class="flex flex-col gap-1">
      <div class="w-[100%] mt-6 grid grid-cols-7 gap-4">
        <%= for date <- @dates_for_selection do %>
          <.date_navigation_component date={date} active_date={@active_date} />
        <% end %>
      </div>
      <p class="bg-gray-500 h-[1px] w-[100%]" />
    </div>
    """
  end

  defp date_navigation_component(assigns) do
    ~H"""
    <div
      class={"flex justify-center items-center cursor-pointer gap-1  #{if @date.date == @active_date do "text-white font-bold" else "text-gray-500" end}"}
      phx-click="activate_date"
      phx-value-date={@date.date}
    >
      {@date.day}
      <span class={"#{if @date.date == @active_date do "bg-dark_purple p-1 w-[20px] h-[20px] text-xs flex justify-center items-center text-white rounded-md" else "" end}"}>
        {@date.number}
      </span>
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
          required
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
              <p id="togglePicker" class="cursor-pointer">
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
            <p phx-click="toggle_priority_list" class="cursor-pointer">
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
              <p id="togglePickerDateTime" class="cursor-pointer">
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
        <p phx-click="cancel_new_todo_form" class="cursor-pointer">
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

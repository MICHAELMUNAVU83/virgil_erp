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
            TYhe dfate Today
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
    <.simple_form for={@form} id="todo-form" phx-change="validate" phx-submit="save">
      <.input field={@form[:name]} type="text" label="Name" />
      <.input field={@form[:description]} type="text" label="Description" />
      <.input field={@form[:due_by]} type="datetime-local" label="Due by" />
      <.input field={@form[:remind_at]} type="datetime-local" label="Remind at" />
      <.input field={@form[:remind_by]} type="datetime-local" label="Remind by" />
      <.input field={@form[:is_completed]} type="checkbox" label="Is completed" />
      <:actions>
        <.button phx-disable-with="Saving...">Save Todo</.button>
      </:actions>
    </.simple_form>
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
end

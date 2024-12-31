defmodule VirgilErpWeb.DashboardComponents do
  use Phoenix.Component

  def dashboard_component(assigns) do
    ~H"""
    <div class="w-[100%] pb-8 mt-8 flex items-start justify-between">
      <div class="w-[70%] flex flex-col justify-between h-[90vh]">
        <.projects_components />

        <div class="w-[100%] h-[60%] gap-4 flex justify-between">
          <.expenses_and_invoices />

          <.expenses_and_invoices_graph />
        </div>
      </div>

      <div class="w-[25%] h-[90vh] flex flex-col justify-between">
        <.todos_components />
        <.project_tasks_components />
      </div>
    </div>
    """
  end

  defp expenses_and_invoices_graph(assigns) do
    ~H"""
    <div class="w-[100%] p-4 text-white h-[100%] bg-card_bg rounded-md">
      Graph Here
    </div>
    """
  end

  defp expenses_and_invoices(assigns) do
    ~H"""
    <div class="w-[47%] h-[100%]">
      <div class="w-[100%] flex flex-col h-[100%] items-start justify-between">
        <.expenses_component />
        <.invoices_component />
      </div>
    </div>
    """
  end

  defp expenses_component(assigns) do
    ~H"""
    <div class="w-[100%] rounded-md p-4 bg-card_bg h-[47%] text-white">
      Expenses Here
    </div>
    """
  end

  defp invoices_component(assigns) do
    ~H"""
    <div class="w-[100%] p-4 rounded-md bg-card_bg h-[47%] text-white">
      Invoices Here
    </div>
    """
  end

  defp todos_components(assigns) do
    ~H"""
    <div class="w-[100%] h-[47%] p-4 flex flex-col justify-between rounded-md bg-card_bg shadow-sm shadow-gray-500">
      <div class="w-[100%] h-[18%] text-white flex flex-col justify-between items-start">
        <p class="uppercase  text-white">
          tasks
        </p>
        <p class="font-medium uppercase text-2xl">
          Today
        </p>
      </div>

      <div class="w-[100%] h-[70%] flex flex-col gap-4 text-white items-start">
        <p>
          Meeting with x and y
        </p>

        <p>
          Your transaction can't be completed with the selected payment method. Please use another payment method and try again. [OR-FGEMF-82]

          To keep your Premium (X) subscription active, update your payment method or use a different one.
        </p>
      </div>

      <div class="w-[100%] h-[10%] flex justify-between items-center">
        <div class="w-[20%] ">
          <div class="w-[100%] flex text-white justify-between items-center">
            <i class="fa fa-chevron-left" aria-hidden="true"></i>
            <i class="fa fa-chevron-right" aria-hidden="true"></i>
          </div>
        </div>

        <div class="flex flex-col items-center justify-center">
          <p class="bg-dark_purple w-[40px]   h-[40px] flex justify-center items-center  p-2 uppercase text-light_purple">
            <i class="fa fa-plus" aria-hidden="true"></i>
          </p>
        </div>
      </div>
    </div>
    """
  end

  defp project_tasks_components(assigns) do
    ~H"""
    <div class="w-[100%] h-[47%] rounded-md p-4 bg-card_bg shadow-sm shadow-gray-500">
      <div class="w-[100%] h-[18%] text-white flex flex-col justify-between items-start">
        <p class="uppercase  text-white">
          tasks
        </p>
        <p class="font-medium uppercase text-2xl">
          Today
        </p>
      </div>

      <div class="w-[100%] h-[70%] flex flex-col gap-4 text-white items-start">
        <p>
          Meeting with x and y
        </p>

        <p>
          Your transaction can't be completed with the selected payment method. Please use another payment method and try again. [OR-FGEMF-82]

          To keep your Premium (X) subscription active, update your payment method or use a different one.
        </p>
      </div>

      <div class="w-[100%] h-[10%] flex justify-between items-center">
        <div class="w-[20%] ">
          <div class="w-[100%] flex text-white justify-between items-center">
            <i class="fa fa-chevron-left" aria-hidden="true"></i>
            <i class="fa fa-chevron-right" aria-hidden="true"></i>
          </div>
        </div>

        <div class="flex flex-col items-center justify-center">
          <p class="bg-dark_purple w-[40px]   h-[40px] flex justify-center items-center  p-2 uppercase text-light_purple">
            <i class="fa fa-plus" aria-hidden="true"></i>
          </p>
        </div>
      </div>
    </div>
    """
  end

  def projects_components(assigns) do
    ~H"""
    <div class="w-[100%]   grid grid-cols-3 gap-8">
      <%= for project <- demo_projects() do %>
        <.project_component project={project} />
      <% end %>
    </div>
    """
  end

  defp project_component(assigns) do
    ~H"""
    <div class="bg-card_bg h-[300px] gap-4 rounded-md flex flex-col justify-between p-4">
      <div class="flex flex-col gap-1">
        <div class="w-[100%] text-white flex justify-between items-center">
          <p class="font-semibold  text-xl">
            {@project.name}
          </p>

          <p>
            <i class="fa fa-ellipsis-h" aria-hidden="true"></i>
          </p>
        </div>

        <div class="w-[100%] flex justify-start">
          <p class="bg-dark_purple p-2 uppercase text-light_purple">
            {@project.number_of_tasks} tasks
          </p>
        </div>
      </div>
      <div class="w-[100%] h-[100%] ">
        <div
          class="w-[100%] h-[100%] object-cover"
          id={"project-#{@project.name}"}
          phx-hook="TestEachProject"
        >
          <canvas id={"testeachproject-#{@project.name}"} phx-update="ignore" />
        </div>
      </div>
    </div>
    """
  end

  defp demo_projects do
    [
      %{
        name: "Project 1",
        number_of_tasks: 3,
        timeline: "1 day"
      },
      %{
        name: "Project 2",
        number_of_tasks: 3,
        timeline: "1 day"
      },
      %{
        name: "Project 3",
        number_of_tasks: 3,
        timeline: "1 day"
      }
    ]
  end
end

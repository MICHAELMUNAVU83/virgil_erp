defmodule VirgilErpWeb.RevenueLive.FormComponent do
  use VirgilErpWeb, :live_component

  alias VirgilErp.Revenues
  alias VirgilErp.Projects
  alias VirgilErp.Invoices

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header class="ml-2">
        {@title}
      </.header>

      <.simple_form
        for={@form}
        id="revenue-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:amount]} type="number" label="Amount" step="any" />
        <.input field={@form[:paid_through]} type="text" label="Paid through" />
        <.input field={@form[:reason]} type="textarea" label="Reason" />
        <.input field={@form[:paid_at]} type="date" label="Paid At" />
        <.input
          field={@form[:project_id]}
          type="select"
          options={@projects}
          label="Project"
          prompt="Select Project"
        />
        <.input
          field={@form[:invoice_id]}
          type="select"
          options={@invoices}
          label="Project"
          prompt="Select Project"
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save Revenue</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{revenue: revenue} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:projects, Projects.list_projects_for_selection())
     |> assign(:invoices, Invoices.list_invoices_for_selection())
     |> assign_new(:form, fn ->
       to_form(Revenues.change_revenue(revenue))
     end)}
  end

  @impl true
  def handle_event("validate", %{"revenue" => revenue_params}, socket) do
    changeset = Revenues.change_revenue(socket.assigns.revenue, revenue_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"revenue" => revenue_params}, socket) do
    revenue_params = Map.put(revenue_params, "user_id", socket.assigns.current_user.id)
    save_revenue(socket, socket.assigns.action, revenue_params)
  end

  defp save_revenue(socket, :edit, revenue_params) do
    case Revenues.update_revenue(socket.assigns.revenue, revenue_params) do
      {:ok, revenue} ->
        notify_parent({:saved, revenue})

        {:noreply,
         socket
         |> put_flash(:info, "Revenue updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_revenue(socket, :new, revenue_params) do
    case Revenues.create_revenue(revenue_params) do
      {:ok, revenue} ->
        notify_parent({:saved, revenue})

        {:noreply,
         socket
         |> put_flash(:info, "Revenue created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

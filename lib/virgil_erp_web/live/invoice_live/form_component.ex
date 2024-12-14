defmodule VirgilErpWeb.InvoiceLive.FormComponent do
  use VirgilErpWeb, :live_component

  alias VirgilErp.Invoices

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage invoice records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="invoice-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:invoice_id]} type="text" label="Invoice" />
        <.input field={@form[:amount]} type="number" label="Amount" step="any" />
        <.input field={@form[:pay_by_date]} type="date" label="Pay by date" />
        <.input field={@form[:terms_and_conditions]} type="text" label="Terms and conditions" />
        <.input field={@form[:client]} type="text" label="Client" />
        <.input field={@form[:is_paid]} type="checkbox" label="Is paid" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Invoice</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{invoice: invoice} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Invoices.change_invoice(invoice))
     end)}
  end

  @impl true
  def handle_event("validate", %{"invoice" => invoice_params}, socket) do
    changeset = Invoices.change_invoice(socket.assigns.invoice, invoice_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"invoice" => invoice_params}, socket) do
    save_invoice(socket, socket.assigns.action, invoice_params)
  end

  defp save_invoice(socket, :edit, invoice_params) do
    case Invoices.update_invoice(socket.assigns.invoice, invoice_params) do
      {:ok, invoice} ->
        notify_parent({:saved, invoice})

        {:noreply,
         socket
         |> put_flash(:info, "Invoice updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_invoice(socket, :new, invoice_params) do
    case Invoices.create_invoice(invoice_params) do
      {:ok, invoice} ->
        notify_parent({:saved, invoice})

        {:noreply,
         socket
         |> put_flash(:info, "Invoice created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

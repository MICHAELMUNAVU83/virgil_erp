defmodule VirgilErpWeb.ClientContractLive.FormComponent do
  use VirgilErpWeb, :live_component

  alias VirgilErp.ClientContracts

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage client_contract records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="client_contract-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:signed_contract]} type="text" label="Signed contract" />
        <.input field={@form[:date]} type="date" label="Date" />
        <.input field={@form[:client]} type="text" label="Client" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:template_link]} type="text" label="Template link" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Client contract</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{client_contract: client_contract} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(ClientContracts.change_client_contract(client_contract))
     end)}
  end

  @impl true
  def handle_event("validate", %{"client_contract" => client_contract_params}, socket) do
    changeset = ClientContracts.change_client_contract(socket.assigns.client_contract, client_contract_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"client_contract" => client_contract_params}, socket) do
    save_client_contract(socket, socket.assigns.action, client_contract_params)
  end

  defp save_client_contract(socket, :edit, client_contract_params) do
    case ClientContracts.update_client_contract(socket.assigns.client_contract, client_contract_params) do
      {:ok, client_contract} ->
        notify_parent({:saved, client_contract})

        {:noreply,
         socket
         |> put_flash(:info, "Client contract updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_client_contract(socket, :new, client_contract_params) do
    case ClientContracts.create_client_contract(client_contract_params) do
      {:ok, client_contract} ->
        notify_parent({:saved, client_contract})

        {:noreply,
         socket
         |> put_flash(:info, "Client contract created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

defmodule VirgilErpWeb.ProposalLive.FormComponent do
  use VirgilErpWeb, :live_component

  alias VirgilErp.Proposals

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage proposal records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="proposal-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:client]} type="text" label="Client" />
        <.input field={@form[:pdf_attachment]} type="text" label="Pdf attachment" />
        <.input field={@form[:link_attachment]} type="text" label="Link attachment" />
        <.input field={@form[:client_type]} type="text" label="Client type" />
        <.input field={@form[:description]} type="text" label="Description" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Proposal</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{proposal: proposal} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Proposals.change_proposal(proposal))
     end)}
  end

  @impl true
  def handle_event("validate", %{"proposal" => proposal_params}, socket) do
    changeset = Proposals.change_proposal(socket.assigns.proposal, proposal_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"proposal" => proposal_params}, socket) do
    save_proposal(socket, socket.assigns.action, proposal_params)
  end

  defp save_proposal(socket, :edit, proposal_params) do
    case Proposals.update_proposal(socket.assigns.proposal, proposal_params) do
      {:ok, proposal} ->
        notify_parent({:saved, proposal})

        {:noreply,
         socket
         |> put_flash(:info, "Proposal updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_proposal(socket, :new, proposal_params) do
    case Proposals.create_proposal(proposal_params) do
      {:ok, proposal} ->
        notify_parent({:saved, proposal})

        {:noreply,
         socket
         |> put_flash(:info, "Proposal created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

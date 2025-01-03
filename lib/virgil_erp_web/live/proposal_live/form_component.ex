defmodule VirgilErpWeb.ProposalLive.FormComponent do
  use VirgilErpWeb, :live_component

  alias VirgilErp.Proposals

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header class="ml-2">
        {@title}
      </.header>

      <.simple_form
        for={@form}
        id="proposal-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:client]} type="text" label="Client" />
        <.input field={@form[:client_type]} type="text" label="Client type" />
        <.input field={@form[:description]} type="textarea" label="Description" />

        <.input field={@form[:link_attachment]} type="text" label="Link URL For Proposal" />

        <%= if @action == :edit && @proposal.pdf_attachment do %>
          <div>
            <p class="poppins-bold">
              PDF Added
            </p>
            <div class="mt-4 flex gap-3 items-center">
              <a
                href={@proposal.pdf_attachment}
                download
                class="bg-dark_purple text-white px-4 py-2 rounded-md"
              >
                <i class="fa fa-download"></i> Download PDF
              </a>

              <i
                class=" fa fa-trash text-red-500 cursor-pointer"
                phx-click="delete_pdf_attachment"
                phx-target={@myself}
                data-confirm="Are you sure?"
                aria-label="delete"
              >
              </i>
            </div>
          </div>
        <% end %>

        <div class="flex flex-col gap-1 ">
          <p class="block text-sm ml-2 font-semibold leading-6 text-white">
            Attach PDF
          </p>

          <.live_file_input upload={@uploads.pdf_attachment} />
        </div>

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
     |> assign(:uploaded_files, [])
     |> allow_upload(:pdf_attachment, accept: ~w(.pdf), max_entries: 1)
     |> assign_new(:form, fn ->
       to_form(Proposals.change_proposal(proposal))
     end)}
  end

  @impl true
  def handle_event("validate", %{"proposal" => proposal_params}, socket) do
    changeset = Proposals.change_proposal(socket.assigns.proposal, proposal_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("delete_attachment", _params, socket) do
    File.rm(socket.assigns.proposal.pdf_attachment)

    {:ok, proposal} = Proposals.update_proposal(socket.assigns.proposal, %{pdf_attachment: nil})

    {:noreply,
     socket
     |> assign(
       :proposal,
       proposal
     )
     |> assign_new(:form, fn ->
       to_form(Proposals.change_proposal(socket.assigns.proposal))
     end)}
  end

  def handle_event("save", %{"proposal" => proposal_params}, socket) do
    proposal_params = Map.put(proposal_params, "user_id", socket.assigns.current_user.id)
    save_proposal(socket, socket.assigns.action, proposal_params)
  end

  defp save_proposal(socket, :edit, proposal_params) do
    uploaded_files =
      consume_uploaded_entries(socket, :attached_receipt, fn %{path: path}, _entry ->
        dest = Path.join([:code.priv_dir(:virgil_erp), "static", "uploads", Path.basename(path)])
        File.cp!(path, dest)
        {:ok, "/uploads/" <> Path.basename(dest)}
      end)

    {:noreply, update(socket, :uploaded_files, &(&1 ++ uploaded_files))}

    case List.first(uploaded_files) do
      nil ->
        proposal_params =
          Map.put_new(
            proposal_params,
            "attached_receipt",
            socket.assigns.proposal.attached_receipt
          )

        case Proposals.update_proposal(socket.assigns.proposal, proposal_params) do
          {:ok, _proposal} ->
            {:noreply,
             socket
             |> put_flash(:info, "Proposal updated successfully")
             |> push_navigate(to: socket.assigns.patch)}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, form: to_form(changeset))}
        end

      attached_receipt ->
        File.rm(socket.assigns.proposal.attached_receipt)

        proposal_params =
          Map.put_new(proposal_params, "attached_receipt", attached_receipt)

        case Proposals.update_proposal(socket.assigns.proposal, proposal_params) do
          {:ok, _proposal} ->
            {:noreply,
             socket
             |> put_flash(:info, "Proposal updated successfully")
             |> push_navigate(to: socket.assigns.patch)}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, form: to_form(changeset))}
        end
    end
  end

  defp save_proposal(socket, :new, proposal_params) do
    uploaded_files =
      consume_uploaded_entries(socket, :pdf_attachment, fn %{path: path}, _entry ->
        dest = Path.join([:code.priv_dir(:virgil_erp), "static", "uploads", Path.basename(path)])
        File.cp!(path, dest)
        {:ok, "/uploads/" <> Path.basename(dest)}
      end)

    {:noreply, update(socket, :uploaded_files, &(&1 ++ uploaded_files))}
    url = List.first(uploaded_files)

    proposal_params = Map.put_new(proposal_params, "pdf_attachment", url)

    case Proposals.create_proposal(proposal_params) do
      {:ok, _proposal} ->
        {:noreply,
         socket
         |> put_flash(:info, "Proposal created successfully")
         |> push_navigate(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end

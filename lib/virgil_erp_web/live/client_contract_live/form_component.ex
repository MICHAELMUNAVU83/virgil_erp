defmodule VirgilErpWeb.ClientContractLive.FormComponent do
  use VirgilErpWeb, :live_component

  alias VirgilErp.ClientContracts

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header class="ml-2">
        {@title}
      </.header>

      <.simple_form
        for={@form}
        id="client_contract-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:client]} type="text" label="Client" />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <.input field={@form[:template_link]} type="text" label="Template link" />

        <%= if @action == :edit && @client_contract.signed_contract do %>
          <div>
            <p class="poppins-bold">
              PDF Added
            </p>
            <div class="mt-4 flex gap-3 items-center">
              <a
                href={@client_contract.signed_contract}
                download
                class="bg-dark_purple text-white px-4 py-2 rounded-md"
              >
                <i class="fa fa-download"></i> Download PDF
              </a>

              <i
                class=" fa fa-trash text-red-500 cursor-pointer"
                phx-click="delete_attachment"
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

          <.live_file_input upload={@uploads.signed_contract} />
        </div>

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
     |> assign(:uploaded_files, [])
     |> allow_upload(:signed_contract, accept: ~w(.pdf), max_entries: 1)
     |> assign_new(:form, fn ->
       to_form(ClientContracts.change_client_contract(client_contract))
     end)}
  end

  @impl true
  def handle_event("validate", %{"client_contract" => client_contract_params}, socket) do
    changeset =
      ClientContracts.change_client_contract(
        socket.assigns.client_contract,
        client_contract_params
      )

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("delete_attachment", _params, socket) do
    File.rm(socket.assigns.client_contract.signed_contract)

    {:ok, client_contract} =
      ClientContracts.update_client_contract(socket.assigns.client_contract, %{
        signed_contract: nil
      })

    {:noreply,
     socket
     |> assign(
       :client_contract,
       client_contract
     )
     |> assign_new(:form, fn ->
       to_form(ClientContracts.change_client_contract(socket.assigns.client_contract))
     end)}
  end

  def handle_event("save", %{"client_contract" => client_contract_params}, socket) do
    client_contract_params =
      Map.put(client_contract_params, "user_id", socket.assigns.current_user.id)

    save_client_contract(socket, socket.assigns.action, client_contract_params)
  end

  defp save_client_contract(socket, :edit, client_contract_params) do
    uploaded_files =
      consume_uploaded_entries(socket, :attached_receipt, fn %{path: path}, _entry ->
        dest = Path.join([:code.priv_dir(:virgil_erp), "static", "uploads", Path.basename(path)])
        File.cp!(path, dest)
        {:ok, "/uploads/" <> Path.basename(dest)}
      end)

    {:noreply, update(socket, :uploaded_files, &(&1 ++ uploaded_files))}

    case List.first(uploaded_files) do
      nil ->
        client_contract_params =
          Map.put_new(
            client_contract_params,
            "signed_contract",
            socket.assigns.client_contract.signed_contract
          )

        case ClientContracts.update_client_contract(
               socket.assigns.client_contract,
               client_contract_params
             ) do
          {:ok, _client_contract} ->
            {:noreply,
             socket
             |> put_flash(:info, "Client contract updated successfully")
             |> push_patch(to: socket.assigns.patch)}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, form: to_form(changeset))}
        end

      signed_contract ->
        client_contract_params =
          Map.put_new(client_contract_params, "signed_contract", signed_contract)

        case ClientContracts.update_client_contract(
               socket.assigns.client_contract,
               client_contract_params
             ) do
          {:ok, _client_contract} ->
            {:noreply,
             socket
             |> put_flash(:info, "Client contract updated successfully")
             |> push_patch(to: socket.assigns.patch)}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, form: to_form(changeset))}
        end
    end
  end

  defp save_client_contract(socket, :new, client_contract_params) do
    uploaded_files =
      consume_uploaded_entries(socket, :signed_contract, fn %{path: path}, _entry ->
        dest = Path.join([:code.priv_dir(:virgil_erp), "static", "uploads", Path.basename(path)])
        File.cp!(path, dest)
        {:ok, "/uploads/" <> Path.basename(dest)}
      end)

    {:noreply, update(socket, :uploaded_files, &(&1 ++ uploaded_files))}
    url = List.first(uploaded_files)

    client_contract_params = Map.put_new(client_contract_params, "signed_contract", url)

    case ClientContracts.create_client_contract(client_contract_params) do
      {:ok, _client_contract} ->
        {:noreply,
         socket
         |> put_flash(:info, "Client contract created successfully")
         |> push_navigate(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end

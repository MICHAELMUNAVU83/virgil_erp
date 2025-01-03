defmodule VirgilErpWeb.InvoiceLive.FormComponent do
  use VirgilErpWeb, :live_component

  alias VirgilErp.Invoices
  alias VirgilErp.Projects

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header class="ml-2">
        {@title}
      </.header>

      <.simple_form
        for={@form}
        id="invoice-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:invoice_id]} type="text" label="Invoice ID" />
        <.input field={@form[:amount]} type="number" label="Amount" step="any" />
        <.input field={@form[:client]} type="text" label="Client" />
        <.input
          field={@form[:project_id]}
          type="select"
          options={@projects}
          label="Project"
          prompt="Select Project"
        />
        <.input field={@form[:is_paid]} type="checkbox" label="Fully Paid" />

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
        <button
          class="bg-dark_purple flex justify-center items-center   p-2 rounded-md text-white"
          phx-disable-with="Saving..."
        >
          Save Invoice
        </button>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{invoice: invoice} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:uploaded_files, [])
     |> assign(:projects, Projects.list_projects_for_selection())
     |> allow_upload(:pdf_attachment, accept: ~w(.pdf), max_entries: 1)
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
    invoice_params =
      Map.put(invoice_params, "user_id", socket.assigns.current_user.id)

    save_invoice(socket, socket.assigns.action, invoice_params)
  end

  defp save_invoice(socket, :edit, invoice_params) do
    uploaded_files =
      consume_uploaded_entries(socket, :attached_receipt, fn %{path: path}, _entry ->
        dest = Path.join([:code.priv_dir(:virgil_erp), "static", "uploads", Path.basename(path)])
        File.cp!(path, dest)
        {:ok, "/uploads/" <> Path.basename(dest)}
      end)

    {:noreply, update(socket, :uploaded_files, &(&1 ++ uploaded_files))}

    case List.first(uploaded_files) do
      nil ->
        invoice_params =
          Map.put(invoice_params, "pdf_attachment", socket.assigns.invoice.pdf_attachment)

        case Invoices.update_invoice(socket.assigns.invoice, invoice_params) do
          {:ok, _invoice} ->
            {:noreply,
             socket
             |> put_flash(:info, "Invoice updated successfully")
             |> push_navigate(to: socket.assigns.patch)}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, form: to_form(changeset))}
        end

      url ->
        File.rm(socket.assigns.invoice.pdf_attachment)
        invoice_params = Map.put(invoice_params, "pdf_attachment", url)

        case Invoices.update_invoice(socket.assigns.invoice, invoice_params) do
          {:ok, _invoice} ->
            {:noreply,
             socket
             |> put_flash(:info, "Invoice updated successfully")
             |> push_navigate(to: socket.assigns.patch)}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, form: to_form(changeset))}
        end
    end
  end

  defp save_invoice(socket, :new, invoice_params) do
    uploaded_files =
      consume_uploaded_entries(socket, :pdf_attachment, fn %{path: path}, _entry ->
        dest = Path.join([:code.priv_dir(:virgil_erp), "static", "uploads", Path.basename(path)])
        File.cp!(path, dest)
        {:ok, "/uploads/" <> Path.basename(dest)}
      end)

    {:noreply, update(socket, :uploaded_files, &(&1 ++ uploaded_files))}
    url = List.first(uploaded_files)

    invoice_params = Map.put_new(invoice_params, "pdf_attachment", url)

    case Invoices.create_invoice(invoice_params) do
      {:ok, _invoice} ->
        {:noreply,
         socket
         |> put_flash(:info, "Invoice created successfully")
         |> push_navigate(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end

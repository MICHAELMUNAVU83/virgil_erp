defmodule VirgilErpWeb.ExpenseLive.FormComponent do
  use VirgilErpWeb, :live_component

  alias VirgilErp.Expenses

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header class="ml-2">
        {@title}
      </.header>

      <.simple_form
        for={@form}
        id="expense-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
        multipart
      >
        <.input field={@form[:amount]} type="number" label="Amount" step="any" />
        <.input field={@form[:reason]} type="text" label="Reason" />
        <.input field={@form[:paid_at]} type="date" label="Paid at" />

        <div class="flex flex-col gap-1 ">
          <p class="block text-sm ml-2 font-semibold leading-6 text-white">
            Attach Receipt
          </p>

          <.live_file_input upload={@uploads.attached_receipt} />
        </div>

        <%= if @action == :edit && @expense.attached_receipt && @expense.attached_receipt != nil do %>
          <%= if is_receipt_an_image?(@expense.attached_receipt) do %>
            <div>
              <p class="poppins-bold">
                Current Image:
              </p>
              <div class="flex items-end gap-2">
                <img src={@expense.attached_receipt} class="h-[200px] w-[200px] object-contain" />

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
          <% else %>
            <div>
              <p class="poppins-bold">
                PDF Added
              </p>
              <div class="mt-4 flex gap-3 items-center">
                <a
                  href={@expense.attached_receipt}
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
        <% end %>

        <section phx-drop-target={@uploads.attached_receipt.ref}>
          <article :for={entry <- @uploads.attached_receipt.entries} class="upload-entry">
            <figure>
              <%= if entry.client_type == "application/pdf" do %>
                <div class="flex gap-1 items-center">
                  <p>{entry.client_name}</p>
                  <button
                    type="button"
                    phx-click="cancel-upload"
                    phx-value-ref={entry.ref}
                    phx-target={@myself}
                    aria-label="cancel"
                  >
                    &times;
                  </button>
                </div>
              <% else %>
                <button
                  type="button"
                  phx-click="cancel-upload"
                  phx-value-ref={entry.ref}
                  phx-target={@myself}
                  aria-label="cancel"
                >
                  &times;
                </button>
                <.live_img_preview entry={entry} />
              <% end %>
            </figure>
          </article>
        </section>

        <button
          class="bg-dark_purple flex justify-center items-center   p-2 rounded-md text-white"
          phx-disable-with="Saving..."
        >
          Save Expenses
        </button>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{expense: expense} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:uploaded_files, [])
     |> allow_upload(:attached_receipt, accept: ~w(.jpg .png .jpeg .pdf), max_entries: 1)
     |> assign_new(:form, fn ->
       to_form(Expenses.change_expense(expense))
     end)}
  end

  @impl true
  def handle_event("validate", %{"expense" => expense_params}, socket) do
    changeset = Expenses.change_expense(socket.assigns.expense, expense_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("delete_attachment", _params, socket) do
    File.rm(socket.assigns.expense.attached_receipt)

    {:ok, expense} = Expenses.update_expense(socket.assigns.expense, %{attached_receipt: nil})

    {:noreply,
     socket
     |> assign(:expense, expense)
     |> assign_new(:form, fn ->
       to_form(Expenses.change_expense(expense))
     end)}
  end

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :attached_receipt, ref)}
  end

  def handle_event("save", %{"expense" => expense_params}, socket) do
    expense_params = Map.put_new(expense_params, "user_id", socket.assigns.current_user.id)

    save_expense(socket, socket.assigns.action, expense_params)
  end

  defp save_expense(socket, :edit, expense_params) do
    uploaded_files =
      consume_uploaded_entries(socket, :attached_receipt, fn %{path: path}, _entry ->
        dest = Path.join([:code.priv_dir(:virgil_erp), "static", "uploads", Path.basename(path)])
        File.cp!(path, dest)
        {:ok, "/uploads/" <> Path.basename(dest)}
      end)

    {:noreply, update(socket, :uploaded_files, &(&1 ++ uploaded_files))}

    case List.first(uploaded_files) do
      nil ->
        expense_params =
          Map.put_new(expense_params, "attached_receipt", socket.assigns.expense.attached_receipt)

        case Expenses.update_expense(socket.assigns.expense, expense_params) do
          {:ok, _expense} ->
            {:noreply,
             socket
             |> put_flash(:info, "Expense updated successfully")
             |> push_navigate(to: socket.assigns.patch)}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, form: to_form(changeset))}
        end

      attached_receipt ->
        expense_params =
          Map.put_new(expense_params, "attached_receipt", attached_receipt)

        case Expenses.update_expense(socket.assigns.expense, expense_params) do
          {:ok, _expense} ->
            {:noreply,
             socket
             |> put_flash(:info, "Expense updated successfully")
             |> push_navigate(to: socket.assigns.patch)}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, form: to_form(changeset))}
        end
    end
  end

  defp save_expense(socket, :new, expense_params) do
    uploaded_files =
      consume_uploaded_entries(socket, :attached_receipt, fn %{path: path}, _entry ->
        dest = Path.join([:code.priv_dir(:virgil_erp), "static", "uploads", Path.basename(path)])
        File.cp!(path, dest)
        {:ok, "/uploads/" <> Path.basename(dest)}
      end)

    {:noreply, update(socket, :uploaded_files, &(&1 ++ uploaded_files))}
    url = List.first(uploaded_files)

    expense_params = Map.put_new(expense_params, "attached_receipt", url)

    case Expenses.create_expense(expense_params) do
      {:ok, _expense} ->
        {:noreply,
         socket
         |> put_flash(:info, "Expense created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp is_receipt_an_image?(nil) do
    false
  end

  defp is_receipt_an_image?(receipt) do
    case FileType.from_path("priv/static" <> receipt) do
      {:ok, receipt_type} ->
        {type, _} = receipt_type

        if type == "pdf" do
          false
        else
          true
        end

      _ ->
        false
    end
  end
end

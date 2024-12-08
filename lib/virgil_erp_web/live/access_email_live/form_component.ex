defmodule VirgilErpWeb.AccessEmailLive.FormComponent do
  use VirgilErpWeb, :live_component

  alias VirgilErp.AcessEmails

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage access_email records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="access_email-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:active]} type="checkbox" label="Active" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Access email</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{access_email: access_email} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(AcessEmails.change_access_email(access_email))
     end)}
  end

  @impl true
  def handle_event("validate", %{"access_email" => access_email_params}, socket) do
    changeset = AcessEmails.change_access_email(socket.assigns.access_email, access_email_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"access_email" => access_email_params}, socket) do
    save_access_email(socket, socket.assigns.action, access_email_params)
  end

  defp save_access_email(socket, :edit, access_email_params) do
    case AcessEmails.update_access_email(socket.assigns.access_email, access_email_params) do
      {:ok, access_email} ->
        notify_parent({:saved, access_email})

        {:noreply,
         socket
         |> put_flash(:info, "Access email updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_access_email(socket, :new, access_email_params) do
    case AcessEmails.create_access_email(access_email_params) do
      {:ok, access_email} ->
        notify_parent({:saved, access_email})

        {:noreply,
         socket
         |> put_flash(:info, "Access email created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

defmodule VirgilErpWeb.AccessEmailLive.Index do
  use VirgilErpWeb, :live_view

  alias VirgilErp.AcessEmails
  alias VirgilErp.AcessEmails.AccessEmail

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :access_emails, AcessEmails.list_access_emails())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Access email")
    |> assign(:access_email, AcessEmails.get_access_email!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Access email")
    |> assign(:access_email, %AccessEmail{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Access emails")
    |> assign(:access_email, nil)
  end

  @impl true
  def handle_info({VirgilErpWeb.AccessEmailLive.FormComponent, {:saved, access_email}}, socket) do
    {:noreply, stream_insert(socket, :access_emails, access_email)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    access_email = AcessEmails.get_access_email!(id)
    {:ok, _} = AcessEmails.delete_access_email(access_email)

    {:noreply, stream_delete(socket, :access_emails, access_email)}
  end
end

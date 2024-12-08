defmodule VirgilErpWeb.AccessEmailLiveTest do
  use VirgilErpWeb.ConnCase

  import Phoenix.LiveViewTest
  import VirgilErp.AcessEmailsFixtures

  @create_attrs %{active: true}
  @update_attrs %{active: false}
  @invalid_attrs %{active: false}

  defp create_access_email(_) do
    access_email = access_email_fixture()
    %{access_email: access_email}
  end

  describe "Index" do
    setup [:create_access_email]

    test "lists all access_emails", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/access_emails")

      assert html =~ "Listing Access emails"
    end

    test "saves new access_email", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/access_emails")

      assert index_live |> element("a", "New Access email") |> render_click() =~
               "New Access email"

      assert_patch(index_live, ~p"/access_emails/new")

      assert index_live
             |> form("#access_email-form", access_email: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#access_email-form", access_email: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/access_emails")

      html = render(index_live)
      assert html =~ "Access email created successfully"
    end

    test "updates access_email in listing", %{conn: conn, access_email: access_email} do
      {:ok, index_live, _html} = live(conn, ~p"/access_emails")

      assert index_live |> element("#access_emails-#{access_email.id} a", "Edit") |> render_click() =~
               "Edit Access email"

      assert_patch(index_live, ~p"/access_emails/#{access_email}/edit")

      assert index_live
             |> form("#access_email-form", access_email: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#access_email-form", access_email: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/access_emails")

      html = render(index_live)
      assert html =~ "Access email updated successfully"
    end

    test "deletes access_email in listing", %{conn: conn, access_email: access_email} do
      {:ok, index_live, _html} = live(conn, ~p"/access_emails")

      assert index_live |> element("#access_emails-#{access_email.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#access_emails-#{access_email.id}")
    end
  end

  describe "Show" do
    setup [:create_access_email]

    test "displays access_email", %{conn: conn, access_email: access_email} do
      {:ok, _show_live, html} = live(conn, ~p"/access_emails/#{access_email}")

      assert html =~ "Show Access email"
    end

    test "updates access_email within modal", %{conn: conn, access_email: access_email} do
      {:ok, show_live, _html} = live(conn, ~p"/access_emails/#{access_email}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Access email"

      assert_patch(show_live, ~p"/access_emails/#{access_email}/show/edit")

      assert show_live
             |> form("#access_email-form", access_email: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#access_email-form", access_email: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/access_emails/#{access_email}")

      html = render(show_live)
      assert html =~ "Access email updated successfully"
    end
  end
end

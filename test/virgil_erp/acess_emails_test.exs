defmodule VirgilErp.AcessEmailsTest do
  use VirgilErp.DataCase

  alias VirgilErp.AcessEmails

  describe "access_emails" do
    alias VirgilErp.AcessEmails.AccessEmail

    import VirgilErp.AcessEmailsFixtures

    @invalid_attrs %{active: nil}

    test "list_access_emails/0 returns all access_emails" do
      access_email = access_email_fixture()
      assert AcessEmails.list_access_emails() == [access_email]
    end

    test "get_access_email!/1 returns the access_email with given id" do
      access_email = access_email_fixture()
      assert AcessEmails.get_access_email!(access_email.id) == access_email
    end

    test "create_access_email/1 with valid data creates a access_email" do
      valid_attrs = %{active: true}

      assert {:ok, %AccessEmail{} = access_email} = AcessEmails.create_access_email(valid_attrs)
      assert access_email.active == true
    end

    test "create_access_email/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = AcessEmails.create_access_email(@invalid_attrs)
    end

    test "update_access_email/2 with valid data updates the access_email" do
      access_email = access_email_fixture()
      update_attrs = %{active: false}

      assert {:ok, %AccessEmail{} = access_email} = AcessEmails.update_access_email(access_email, update_attrs)
      assert access_email.active == false
    end

    test "update_access_email/2 with invalid data returns error changeset" do
      access_email = access_email_fixture()
      assert {:error, %Ecto.Changeset{}} = AcessEmails.update_access_email(access_email, @invalid_attrs)
      assert access_email == AcessEmails.get_access_email!(access_email.id)
    end

    test "delete_access_email/1 deletes the access_email" do
      access_email = access_email_fixture()
      assert {:ok, %AccessEmail{}} = AcessEmails.delete_access_email(access_email)
      assert_raise Ecto.NoResultsError, fn -> AcessEmails.get_access_email!(access_email.id) end
    end

    test "change_access_email/1 returns a access_email changeset" do
      access_email = access_email_fixture()
      assert %Ecto.Changeset{} = AcessEmails.change_access_email(access_email)
    end
  end
end

defmodule GSGMS.Accounts.UserLogsTest do
  use GSGMS.DataCase

  alias GSGMS.Accounts.UserLogs

  describe "user_logs" do
    alias GSGMS.Accounts.UserLogs.UserLog

    @valid_attrs %{description: "some description"}
    @update_attrs %{description: "some updated description"}
    @invalid_attrs %{description: nil}

    def user_log_fixture(attrs \\ %{}) do
      {:ok, user_log} =
        attrs
        |> Enum.into(@valid_attrs)
        |> UserLogs.create_user_log()

      user_log
    end

    test "list_user_logs/0 returns all user_logs" do
      user_log = user_log_fixture()
      assert UserLogs.list_user_logs() == [user_log]
    end

    test "get_user_log!/1 returns the user_log with given id" do
      user_log = user_log_fixture()
      assert UserLogs.get_user_log!(user_log.id) == user_log
    end

    test "create_user_log/1 with valid data creates a user_log" do
      assert {:ok, %UserLog{} = user_log} = UserLogs.create_user_log(@valid_attrs)
      assert user_log.description == "some description"
    end

    test "create_user_log/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserLogs.create_user_log(@invalid_attrs)
    end

    test "update_user_log/2 with valid data updates the user_log" do
      user_log = user_log_fixture()
      assert {:ok, %UserLog{} = user_log} = UserLogs.update_user_log(user_log, @update_attrs)
      assert user_log.description == "some updated description"
    end

    test "update_user_log/2 with invalid data returns error changeset" do
      user_log = user_log_fixture()
      assert {:error, %Ecto.Changeset{}} = UserLogs.update_user_log(user_log, @invalid_attrs)
      assert user_log == UserLogs.get_user_log!(user_log.id)
    end

    test "delete_user_log/1 deletes the user_log" do
      user_log = user_log_fixture()
      assert {:ok, %UserLog{}} = UserLogs.delete_user_log(user_log)
      assert_raise Ecto.NoResultsError, fn -> UserLogs.get_user_log!(user_log.id) end
    end

    test "change_user_log/1 returns a user_log changeset" do
      user_log = user_log_fixture()
      assert %Ecto.Changeset{} = UserLogs.change_user_log(user_log)
    end
  end
end

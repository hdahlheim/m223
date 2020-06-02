defmodule GSGMS.Games.PlayerLogsTest do
  use GSGMS.DataCase

  alias GSGMS.Games.PlayerLogs

  describe "player_logs" do
    alias GSGMS.Games.PlayerLogs.PlayerLog

    @valid_attrs %{description: "some description"}
    @update_attrs %{description: "some updated description"}
    @invalid_attrs %{description: nil}

    def player_log_fixture(attrs \\ %{}) do
      {:ok, player_log} =
        attrs
        |> Enum.into(@valid_attrs)
        |> PlayerLogs.create_player_log()

      player_log
    end

    test "list_player_logs/0 returns all player_logs" do
      player_log = player_log_fixture()
      assert PlayerLogs.list_player_logs() == [player_log]
    end

    test "get_player_log!/1 returns the player_log with given id" do
      player_log = player_log_fixture()
      assert PlayerLogs.get_player_log!(player_log.id) == player_log
    end

    test "create_player_log/1 with valid data creates a player_log" do
      assert {:ok, %PlayerLog{} = player_log} = PlayerLogs.create_player_log(@valid_attrs)
      assert player_log.description == "some description"
    end

    test "create_player_log/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PlayerLogs.create_player_log(@invalid_attrs)
    end

    test "update_player_log/2 with valid data updates the player_log" do
      player_log = player_log_fixture()
      assert {:ok, %PlayerLog{} = player_log} = PlayerLogs.update_player_log(player_log, @update_attrs)
      assert player_log.description == "some updated description"
    end

    test "update_player_log/2 with invalid data returns error changeset" do
      player_log = player_log_fixture()
      assert {:error, %Ecto.Changeset{}} = PlayerLogs.update_player_log(player_log, @invalid_attrs)
      assert player_log == PlayerLogs.get_player_log!(player_log.id)
    end

    test "delete_player_log/1 deletes the player_log" do
      player_log = player_log_fixture()
      assert {:ok, %PlayerLog{}} = PlayerLogs.delete_player_log(player_log)
      assert_raise Ecto.NoResultsError, fn -> PlayerLogs.get_player_log!(player_log.id) end
    end

    test "change_player_log/1 returns a player_log changeset" do
      player_log = player_log_fixture()
      assert %Ecto.Changeset{} = PlayerLogs.change_player_log(player_log)
    end
  end
end

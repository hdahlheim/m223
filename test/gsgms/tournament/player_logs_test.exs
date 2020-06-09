defmodule GSGMS.Tournament.PlayerLogsTest do
  use GSGMS.DataCase

  alias GSGMS.Tournament.PlayerLogs

  describe "player_logs" do
    alias GSGMS.Tournament.PlayerLogs.PlayerLog
    alias GSGMS.Tournament.Players.Player

    @valid_attrs %{description: "some description"}
    @invalid_attrs %{description: nil}

    def player_fixture() do
      {:ok, player} =
        %Player{}
        |> Player.changeset(%{name: "some player", code: "some code"})
        |> Repo.insert()

      player
    end

    def add_player(map) do
      map
      |> Map.put(:player, player_fixture())
    end

    def player_log_fixture(attrs \\ %{}) do
      {:ok, player_log} =
        attrs
        |> Enum.into(@valid_attrs)
        |> add_player()
        |> PlayerLogs.create_player_log()

      player_log
    end

    @tag :player_logs
    test "list_player_logs/0 returns all player_logs" do
      player_log = player_log_fixture()
      assert PlayerLogs.list_player_logs() == [player_log]
    end

    @tag :player_logs
    test "get_player_log!/1 returns the player_log with given id" do
      player_log = player_log_fixture()
      assert PlayerLogs.get_player_log!(player_log.id) == player_log
    end

    @tag :player_logs
    test "create_player_log/1 with valid data creates a player_log" do
      attrs = add_player(@valid_attrs)

      assert {:ok, %PlayerLog{} = player_log} = PlayerLogs.create_player_log(attrs)
      assert player_log.description == "some description"
    end

    @tag :player_logs
    test "create_player_log/1 with invalid data returns error changeset" do
      attrs = add_player(@invalid_attrs)

      assert {:error, %Ecto.Changeset{}} = PlayerLogs.create_player_log(attrs)
    end

    @tag :player_logs
    test "delete_player_log/1 deletes the player_log" do
      player_log = player_log_fixture()
      assert {:ok, %PlayerLog{}} = PlayerLogs.delete_player_log(player_log)
      assert_raise Ecto.NoResultsError, fn -> PlayerLogs.get_player_log!(player_log.id) end
    end

    @tag :player_logs
    test "change_player_log/1 returns a player_log changeset" do
      player_log = player_log_fixture()

      assert %Ecto.Changeset{} = PlayerLogs.change_player_log(player_log)
    end
  end
end

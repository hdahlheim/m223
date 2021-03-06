defmodule GSGMS.Tournament.PlayersTest do
  use GSGMS.DataCase

  alias GSGMS.Tournament.Players

  describe "players" do
    alias GSGMS.Tournament.Players.Player

    @valid_attrs %{code: "some code", name: "some name"}
    @update_attrs %{code: "some updated code", name: "some updated name"}
    @invalid_attrs %{code: nil, name: nil}

    def player_fixture(attrs \\ %{}) do
      {:ok, player} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Players.create_player()

      player
    end

    @tag :player
    test "list_players/0 returns all players" do
      player = player_fixture()
      assert Players.list_players() == [player]
    end

    @tag :player
    test "get_player!/1 returns the player with given id" do
      player = player_fixture()
      assert Players.get_player!(player.id) == player
    end

    @tag :player
    test "create_player/1 with valid data creates a player" do
      assert {:ok, %Player{} = player} = Players.create_player(@valid_attrs)
      assert player.code == "some code"
      assert player.name == "some name"
    end

    @tag :player
    test "create_player/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Players.create_player(@invalid_attrs)
    end

    @tag :player
    test "update_player/2 with valid data updates the player" do
      player = player_fixture()
      assert {:ok, %Player{} = player} = Players.update_player(player, @update_attrs)
      assert player.code == "some updated code"
      assert player.name == "some updated name"
    end

    @tag :player
    test "update_player/2 with invalid data returns error changeset" do
      player = player_fixture()
      assert {:error, %Ecto.Changeset{}} = Players.update_player(player, @invalid_attrs)
      assert player == Players.get_player!(player.id)
    end

    @tag :player
    test "delete_player/1 deletes the player" do
      player = player_fixture()
      assert {:ok, %Player{}} = Players.delete_player(player)
      assert_raise Ecto.NoResultsError, fn -> Players.get_player!(player.id) end
    end

    @tag :player
    test "change_player/1 returns a player changeset" do
      player = player_fixture()
      assert %Ecto.Changeset{} = Players.change_player(player)
    end

    @tag :player
    @tag :player_lock
    test "Changing the player with stale information causes an error" do
      {:ok, player} = Players.create_player(%{code: "42424242", name: "Malte Dahlheim"})

      changeset_1 = Players.change_player(player, %{name: "Henning Dahlheim"})

      changeset_2 = Players.change_player(player, %{name: "Frans Dahlheim"})

      assert {:ok, %Player{}} = Repo.update(changeset_1, stale_error_field: :version)

      assert {:error, %Ecto.Changeset{} = changeset} =
               Repo.update(changeset_2, stale_error_field: :version)

      IO.inspect(changeset)
    end
  end
end

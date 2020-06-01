defmodule GSGMS.Attendenc.CheckinsTest do
  use GSGMS.DataCase

  alias GSGMS.Attendenc.Checkins

  describe "checkins" do
    alias GSGMS.Attendenc.Checkins.Checkin

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def checkin_fixture(attrs \\ %{}) do
      {:ok, checkin} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Checkins.create_checkin()

      checkin
    end

    test "list_checkins/0 returns all checkins" do
      checkin = checkin_fixture()
      assert Checkins.list_checkins() == [checkin]
    end

    test "get_checkin!/1 returns the checkin with given id" do
      checkin = checkin_fixture()
      assert Checkins.get_checkin!(checkin.id) == checkin
    end

    test "create_checkin/1 with valid data creates a checkin" do
      assert {:ok, %Checkin{} = checkin} = Checkins.create_checkin(@valid_attrs)
    end

    test "create_checkin/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Checkins.create_checkin(@invalid_attrs)
    end

    test "update_checkin/2 with valid data updates the checkin" do
      checkin = checkin_fixture()
      assert {:ok, %Checkin{} = checkin} = Checkins.update_checkin(checkin, @update_attrs)
    end

    test "update_checkin/2 with invalid data returns error changeset" do
      checkin = checkin_fixture()
      assert {:error, %Ecto.Changeset{}} = Checkins.update_checkin(checkin, @invalid_attrs)
      assert checkin == Checkins.get_checkin!(checkin.id)
    end

    test "delete_checkin/1 deletes the checkin" do
      checkin = checkin_fixture()
      assert {:ok, %Checkin{}} = Checkins.delete_checkin(checkin)
      assert_raise Ecto.NoResultsError, fn -> Checkins.get_checkin!(checkin.id) end
    end

    test "change_checkin/1 returns a checkin changeset" do
      checkin = checkin_fixture()
      assert %Ecto.Changeset{} = Checkins.change_checkin(checkin)
    end
  end
end

defmodule GSGMS.Attendenc.CheckOutsTest do
  use GSGMS.DataCase

  alias GSGMS.Attendenc.CheckOuts

  describe "check_outs" do
    alias GSGMS.Attendenc.CheckOuts.CheckOut

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def check_out_fixture(attrs \\ %{}) do
      {:ok, check_out} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CheckOuts.create_check_out()

      check_out
    end

    test "list_check_outs/0 returns all check_outs" do
      check_out = check_out_fixture()
      assert CheckOuts.list_check_outs() == [check_out]
    end

    test "get_check_out!/1 returns the check_out with given id" do
      check_out = check_out_fixture()
      assert CheckOuts.get_check_out!(check_out.id) == check_out
    end

    test "create_check_out/1 with valid data creates a check_out" do
      assert {:ok, %CheckOut{} = check_out} = CheckOuts.create_check_out(@valid_attrs)
    end

    test "create_check_out/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CheckOuts.create_check_out(@invalid_attrs)
    end

    test "update_check_out/2 with valid data updates the check_out" do
      check_out = check_out_fixture()
      assert {:ok, %CheckOut{} = check_out} = CheckOuts.update_check_out(check_out, @update_attrs)
    end

    test "update_check_out/2 with invalid data returns error changeset" do
      check_out = check_out_fixture()
      assert {:error, %Ecto.Changeset{}} = CheckOuts.update_check_out(check_out, @invalid_attrs)
      assert check_out == CheckOuts.get_check_out!(check_out.id)
    end

    test "delete_check_out/1 deletes the check_out" do
      check_out = check_out_fixture()
      assert {:ok, %CheckOut{}} = CheckOuts.delete_check_out(check_out)
      assert_raise Ecto.NoResultsError, fn -> CheckOuts.get_check_out!(check_out.id) end
    end

    test "change_check_out/1 returns a check_out changeset" do
      check_out = check_out_fixture()
      assert %Ecto.Changeset{} = CheckOuts.change_check_out(check_out)
    end
  end
end

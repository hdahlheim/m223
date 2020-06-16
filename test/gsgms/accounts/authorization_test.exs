defmodule GSGMS.Accounts.AuthorizationTest do
  use ExUnit.Case
  alias GSGMS.Accounts.Authorization
  alias GSGMS.Accounts.Users.User
  alias GSGMS.Tournament.Teams
  alias GSGMS.Tournament.Players

  describe "RBAC Authorization tests" do
    @tag :rbac
    test "Frontdesk role can read Players" do
      user = %User{role: "Frontdesk"}

      assert Authorization.can(user)
             |> Authorization.read?(Players)
    end

    @tag :rbac
    test "Frontdesk role can update Players" do
      user = %User{role: "Frontdesk"}

      assert Authorization.can(user)
             |> Authorization.update?(Players)
    end

    @tag :rbac
    test "Game Manager role can read Players and Teams" do
      user = %User{role: "Game Manager"}

      assert Authorization.can(user)
             |> Authorization.read?(Players)

      assert Authorization.can(user)
             |> Authorization.read?(Teams)
    end

    @tag :rbac
    test "Game Manager role can update Players and Teams" do
      user = %User{role: "Game Manager"}

      assert Authorization.can(user)
             |> Authorization.update?(Players)

      assert Authorization.can(user)
             |> Authorization.update?(Teams)
    end

    @tag :rbac
    test "Admin role can CRUD Players and Teams" do
      user = %User{role: "Admin"}

      assert Authorization.can(user)
             |> Authorization.read?(Players)

      assert Authorization.can(user)
             |> Authorization.update?(Players)

      assert Authorization.can(user)
             |> Authorization.create?(Players)

      assert Authorization.can(user)
             |> Authorization.delete?(Players)

      assert Authorization.can(user)
             |> Authorization.read?(Teams)

      assert Authorization.can(user)
             |> Authorization.update?(Teams)

      assert Authorization.can(user)
             |> Authorization.create?(Teams)

      assert Authorization.can(user)
             |> Authorization.delete?(Teams)
    end
  end
end

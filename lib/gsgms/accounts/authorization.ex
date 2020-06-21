defmodule GSGMS.Accounts.Authorization do
  alias GSGMS.Accounts.Users.User
  alias GSGMS.Tournament.Players
  alias GSGMS.Tournament.Teams

  defstruct role: "", create: %{}, read: %{}, update: %{}, delete: %{}

  def can(%User{role: "Frontdesk"} = user) do
    grant(user.role)
    |> read(Players)
    |> update(Players)
  end

  def can(%User{role: "Game Manager"} = user) do
    grant(user.role)
    |> read(Players)
    |> update(Players)
    |> read(Teams)
    |> update(Teams)
  end

  def can(%User{role: "Admin"} = user) do
    grant(user.role)
    |> all(Players)
    |> all(Teams)
  end

  def can(_) do
    %__MODULE__{}
  end

  def create?(%__MODULE__{} = role, resource) do
    Map.get(role.create, resource, false)
  end

  def read?(%__MODULE__{} = role, resource) do
    Map.get(role.read, resource, false)
  end

  def update?(%__MODULE__{} = role, resource) do
    Map.get(role.update, resource, false)
  end

  def delete?(%__MODULE__{} = role, resource) do
    Map.get(role.delete, resource, false)
  end

  defp grant(role), do: %__MODULE__{role: role}
  defp create(auth, resource), do: put_permission(auth, :create, resource)
  defp read(auth, resource), do: put_permission(auth, :read, resource)
  defp update(auth, resource), do: put_permission(auth, :update, resource)
  defp delete(auth, resource), do: put_permission(auth, :delete, resource)

  defp all(auth, resource) do
    auth
    |> create(resource)
    |> read(resource)
    |> update(resource)
    |> delete(resource)
  end

  defp put_permission(%__MODULE__{} = auth, action, resource) do
    updated_action =
      auth
      |> Map.get(action)
      |> Map.put(resource, true)

    Map.put(auth, action, updated_action)
  end
end

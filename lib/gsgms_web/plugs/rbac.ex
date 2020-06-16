defmodule GSGMSWeb.RBAC do
  import Plug.Conn
  import Phoenix.Controller
  import GSGMS.Accounts.Authorization
  alias GSGMSWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, opts) do
    user = conn.assigns.current_user
    resource = Keyword.get(opts, :resource)
    action = action_name(conn)

    result = check(action, user, resource)
    continue(result, conn)
  end

  defp continue(true, conn), do: conn

  defp continue(false, conn) do
    conn
    |> put_flash(:error, "You're not authorized to do that!")
    |> redirect(to: Routes.page_path(conn, :index))
    |> halt()
  end

  defp check(:index, user, resource) do
    can(user) |> read?(resource)
  end

  defp check(action, user, resource) when action in [:new, :create] do
    can(user) |> create?(resource)
  end

  defp check(action, user, resource) when action in [:edit, :update] do
    can(user) |> update?(resource)
  end

  defp check(:delete, user, resource) do
    can(user) |> delete?(resource)
  end

  defp check(_action, _user, _resource), do: false
end

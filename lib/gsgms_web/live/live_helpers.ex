defmodule GSGMSWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers
  import GSGMS.Accounts.Authorization
  alias Phoenix.LiveView

  @doc """
  Renders a component inside the `GSGMSWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal @socket, GSGMSWeb.UserLive.FormComponent,
        id: @user.id || :new,
        action: @live_action,
        user: @user,
        return_to: Routes.user_index_path(@socket, :index) %>
  """
  def live_modal(socket, component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(socket, GSGMSWeb.ModalComponent, modal_opts)
  end

  def assign_defaults(socket, session) do
    user = Map.get(session, "current_user")

    socket =
      LiveView.assign_new(socket, :current_user, fn ->
        user
      end)

    if(socket.assigns.current_user) do
      socket
    else
      LiveView.redirect(socket, to: "/login")
    end
  end

  def check_privilege(socket, resource) do
    if check(socket.assigns.live_action, socket.assigns.current_user, resource) do
      socket
    else
      socket
      |> LiveView.put_flash(:error, "You're not authorized to do that!")
      |> LiveView.redirect(to: "/")
    end
  end

  def has_privilege?(socket, action, resource) do
    if check(action, socket.assigns.current_user, resource) do
      {true, socket}
    else
      socket =
        socket
        |> LiveView.put_flash(:error, "You're not authorized to do that!")

      {false, socket}
    end
  end

  defp check(action, user, resource) when action in [:index, :show] do
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

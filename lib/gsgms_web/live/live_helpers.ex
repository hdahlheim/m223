defmodule GSGMSWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers
  alias GSGMS.Accounts
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

  @doc """
  Assigns the default values needed for every live view connection.
  """
  def assign_defaults(socket, session) do
    user_token = Map.get(session, "user_token")

    socket =
      LiveView.assign_new(socket, :current_user, fn ->
        Accounts.get_user_by_session_token(user_token)
      end)

    if(socket.assigns.current_user) do
      socket
    else
      LiveView.redirect(socket, to: "/login")
    end
  end

  @doc """
  Makes sure that the current user of the chanel has the correct accessright.
  """
  def check_privilege(socket, resource) do
    if check(socket.assigns.live_action, socket.assigns.current_user, resource) do
      socket
    else
      socket
      |> LiveView.put_flash(:error, "You're not authorized to do that!")
      |> LiveView.redirect(to: "/")
    end
  end

  @doc """
  Checks the accessright for actions that happen after the establishment of
  the connection.
  """
  def has_privilege(socket, action, resource) do
    if check(action, socket.assigns.current_user, resource) do
      {:ok, socket}
    else
      socket =
        socket
        |> LiveView.put_flash(:error, "You're not authorized to do that!")

      {:error, socket}
    end
  end

  @doc false
  defp check(action, user, resource) when action in [:index, :show] do
    Accounts.can(user)
    |> Accounts.read?(resource)
  end

  @doc false
  defp check(action, user, resource) when action in [:new, :create] do
    Accounts.can(user)
    |> Accounts.create?(resource)
  end

  @doc false
  defp check(action, user, resource) when action in [:edit, :update] do
    Accounts.can(user)
    |> Accounts.update?(resource)
  end

  @doc false
  defp check(:delete, user, resource) do
    Accounts.can(user)
    |> Accounts.delete?(resource)
  end

  defp check(_action, _user, _resource), do: false
end

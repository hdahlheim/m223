defmodule GSGMS.Accounts do
  alias __MODULE__.{Authorization, Users, UserLogs}

  @moduledoc """
  Accounts Facade
  """

  ## Delegation to Auth Module
  defdelegate can(user), to: Authorization
  defdelegate create?(role, resource), to: Authorization
  defdelegate read?(role, resource), to: Authorization
  defdelegate update?(role, resource), to: Authorization
  defdelegate delete?(role, resource), to: Authorization

  ## Delegation to Users Module
  defdelegate get_logs_for_user(id), to: UserLogs
  defdelegate get_user_by_email(email), to: Users
  defdelegate get_user_by_email_and_password(email, password), to: Users
  defdelegate get_user!(id), to: Users
  defdelegate register_user(attrs), to: Users
  defdelegate change_user_registration(user, attrs \\ %{}), to: Users
  defdelegate change_user_email(user, attrs \\ %{}), to: Users
  defdelegate apply_user_email(user, password, attrs), to: Users
  defdelegate update_user_email(user, token), to: Users

  defdelegate change_user_name(user, attrs \\ %{}), to: Users
  defdelegate update_user_name(user, attrs), to: Users

  defdelegate deliver_update_email_instructions(user, current_email, update_email_url_fun),
    to: Users

  defdelegate change_user_password(user, attrs \\ %{}), to: Users
  defdelegate update_user_password(user, password, attrs), to: Users
  defdelegate generate_user_session_token(user), to: Users
  defdelegate get_user_by_session_token(token), to: Users
  defdelegate delete_session_token(token), to: Users

  defdelegate deliver_user_confirmation_instructions(user, confirmation_url_fun),
    to: Users

  defdelegate confirm_user(token), to: Users
  defdelegate deliver_user_reset_password_instructions(user, reset_password_url_fun), to: Users
  defdelegate get_user_by_reset_password_token(token), to: Users
  defdelegate reset_user_password(user, attrs), to: Users
end

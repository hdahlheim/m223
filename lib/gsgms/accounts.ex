defmodule GSGMS.Accounts do
  alias __MODULE__.Users

  defdelegate list_all_users(), to: Users, as: :list_users
end

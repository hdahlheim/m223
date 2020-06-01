defmodule GSGMS.Attendenc.CheckOuts do
  @moduledoc """
  The Attendenc.CheckOuts context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias GSGMS.Games
  alias GSGMS.Repo
  alias GSGMS.Attendenc.CheckOuts.CheckOut

  @doc """
  Returns the list of check_outs.

  ## Examples

      iex> list_check_outs()
      [%CheckOut{}, ...]

  """
  def list_check_outs do
    Repo.all(CheckOut)
    |> Repo.preload(:player)
  end

  @doc """
  Gets a single check_out.

  Raises `Ecto.NoResultsError` if the Check out does not exist.

  ## Examples

      iex> get_check_out!(123)
      %CheckOut{}

      iex> get_check_out!(456)
      ** (Ecto.NoResultsError)

  """
  def get_check_out!(id), do: Repo.get!(CheckOut, id)

  @doc """
  Creates a check_out.

  ## Examples

      iex> create_check_out(%{field: value})
      {:ok, %CheckOut{}}

      iex> create_check_out(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_check_out(attrs \\ %{}) do
    player_id = Map.get(attrs, :player_id, nil)

    multi =
      Multi.new()
      |> Multi.run(:get_player, Games, :get_player_by_id, player_id)
      |> Multi.insert(:create_checkout, fn %{get_player: player} ->
        CheckOut.changeset(%CheckOut{}, %{player: player})
      end)

    case Repo.transaction(multi) do
      {:ok, changes} ->
        {:ok, changes.create_checkout}

      {:error, changes} ->
        {:error, changes.create_checkout}
    end

    # %CheckOut{}
    # |> CheckOut.changeset(attrs)
    # |> Repo.insert()
  end

  @doc """
  Updates a check_out.

  ## Examples

      iex> update_check_out(check_out, %{field: new_value})
      {:ok, %CheckOut{}}

      iex> update_check_out(check_out, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_check_out(%CheckOut{} = check_out, attrs) do
    check_out
    |> CheckOut.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a check_out.

  ## Examples

      iex> delete_check_out(check_out)
      {:ok, %CheckOut{}}

      iex> delete_check_out(check_out)
      {:error, %Ecto.Changeset{}}

  """
  def delete_check_out(%CheckOut{} = check_out) do
    Repo.delete(check_out)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking check_out changes.

  ## Examples

      iex> change_check_out(check_out)
      %Ecto.Changeset{data: %CheckOut{}}

  """
  def change_check_out(%CheckOut{} = check_out, attrs \\ %{}) do
    CheckOut.changeset(check_out, attrs)
  end
end

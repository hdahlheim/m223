defmodule GSGMS.Attendenc.CheckIns do
  @moduledoc """
  The Attendenc.CheckIns context.
  """

  import Ecto.Query, warn: false
  alias GSGMS.Repo

  alias GSGMS.Attendenc.CheckIns.CheckIn

  @doc """
  Returns the list of checkins.

  ## Examples

      iex> list_checkins()
      [%CheckIn{}, ...]

  """
  def list_check_ins do
    Repo.all(CheckIn)
    |> Repo.preload(:player)
  end

  @doc """
  Gets a single check-in.

  Raises `Ecto.NoResultsError` if the Check-in does not exist.

  ## Examples

      iex> get_check_in!(123)
      %CheckIn{}

      iex> get_check_in!(456)
      ** (Ecto.NoResultsError)

  """
  def get_check_in!(id), do: Repo.get!(CheckIn, id)

  @doc """
  Creates a check-in.

  ## Examples

      iex> create_check_in(%{field: value})
      {:ok, %CheckIn{}}

      iex> create_check_in(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_check_in(attrs \\ %{}) do
    %CheckIn{}
    |> CheckIn.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a check-in.

  ## Examples

      iex> update_check_in(check_in, %{field: new_value})
      {:ok, %CheckIn{}}

      iex> update_check_in(check_in, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_checkin(%CheckIn{} = check_in, attrs) do
    check_in
    |> CheckIn.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a check-in.

  ## Examples

      iex> delete_check_in(check_in)
      {:ok, %CheckIn{}}

      iex> delete_check_in(check_in)
      {:error, %Ecto.Changeset{}}

  """
  def delete_check_in(%CheckIn{} = check_in) do
    Repo.delete(check_in)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking check-in changes.

  ## Examples

      iex> change_check_in(check_in)
      %Ecto.Changeset{data: %Check_in{}}

  """
  def change_check_in(%CheckIn{} = check_in, attrs \\ %{}) do
    CheckIn.changeset(check_in, attrs)
  end
end

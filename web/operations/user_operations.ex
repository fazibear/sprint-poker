defmodule SprintPoker.UserOperations do
  @moduledoc """
  User related operations
  """
  alias SprintPoker.GameUser
  alias SprintPoker.Repo
  alias SprintPoker.User

  alias SprintPoker.GameUserOperations
  alias Ecto.UUID

  def connect(user, game) do
    case Repo.get_by(GameUser, game_id: game.id, user_id: user.id) do
      nil -> GameUserOperations.create(game, user)
      game_user -> GameUserOperations.update_state(game_user, "connected")
    end
  end

  def disconnect(user, game) do
    game_user = Repo.get_by(GameUser, game_id: game.id, user_id: user.id)
    if game_user do
      GameUserOperations.update_state(game_user, "disconnected")
    end
  end

  def get_or_create(nil) do
    Repo.insert!(%User{})
  end

  def get_or_create(auth_token) do
    case UUID.cast(auth_token) do
      {:ok, auth_token} ->
        Repo.get_by(User, auth_token: auth_token) || get_or_create(nil)
      _ -> get_or_create(nil)
    end
  end

  def update(user, params) do
    changeset = User.changeset(user, %{
      name: params["name"]
    })

    case changeset do
      {:error, errors} ->
        raise errors
      _ ->
        changeset |> Repo.update!
    end
  end
end

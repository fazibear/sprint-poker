defmodule SprintPoker.LobbyChannel do
  @moduledoc """
  Lobby channel messages handling
  """
  use Phoenix.Channel

  alias SprintPoker.Repo
  alias SprintPoker.User
  alias SprintPoker.Deck

  alias SprintPoker.GameOperations
  alias SprintPoker.UserOperations

  def join("lobby", message, socket) do
    send(self(), {:after_join, message})
    {:ok, socket}
  end

  def handle_info({:after_join, %{"game_id" => game_id}}, socket) do
    user = Repo.get!(User, socket.assigns.user_id)

    socket |> push("auth_token", %{auth_token: user.auth_token})
    socket |> push("user", %{user: user})
    socket |> push("decks", %{decks: Repo.all(Deck)})

    case GameOperations.find(game_id) do
      :no_id ->
        :nothing
      :error ->
        socket |> push("error", %{code: "GAME_ERR", message: "Game not exists"})
      game ->
        socket |> push("game", %{game: game})
    end

    {:noreply, socket}
  end

  def handle_in("user:update", %{"user" => user}, socket) do
    user = User
           |> Repo.get!(socket.assigns.user_id)
           |> UserOperations.update(user)

    socket |> push("user", %{user: user})
    {:noreply, socket}
  end

  def handle_in("game:create", %{"game" => game}, socket) do
    user = Repo.get!(User, socket.assigns.user_id)
    game = game
           |> GameOperations.create(user)
           |> Repo.preload([:owner, :deck])

    socket |> push("game", %{game: game})
    {:noreply, socket}
  end
end

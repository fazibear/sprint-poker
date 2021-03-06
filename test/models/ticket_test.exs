defmodule SprintPoker.TicketTest do
  use SprintPoker.ModelCase

  alias SprintPoker.Ticket
  alias SprintPoker.Game
  alias SprintPoker.User
  alias SprintPoker.Deck

  @test_user %User{}
  @test_deck %Deck{name: "test deck", cards: []}

  test "don't create empty ticket" do
    assert_raise Postgrex.Error, fn ->
      %Ticket{} |> Repo.insert!
    end
  end

  test "don't create ticket without name" do
    user = @test_user |> Repo.insert!
    deck = @test_deck |> Repo.insert!

    game = %Game{
      name: "sample name",
      owner_id: user.id,
      deck_id: deck.id
    } |> Repo.insert!


    assert_raise Postgrex.Error, fn ->
      %Ticket{
        game_id: game.id
      } |> Repo.insert!
    end
  end

  test "don't create ticket without game" do
    assert_raise Postgrex.Error, fn ->
      %Ticket{
        name: "test name"
      } |> Repo.insert!
    end
  end

  test "create ticket with name and game" do
    user = @test_user |> Repo.insert!
    deck = @test_deck |> Repo.insert!

    game = %Game{
      name: "sample name",
      owner_id: user.id,
      deck_id: deck.id
    } |> Repo.insert!


    ticket = %Ticket{
      name: "test name",
      game_id: game.id
    } |> Repo.insert! |> Repo.preload([:game])

    assert ticket
    assert ticket.game == game
  end

  test "empty ticket changeset is not valid" do
    changeset = %Ticket{} |> Ticket.changeset(%{})

    refute changeset.valid?
  end

  test "ticket changeset without name is not valid" do
    user = @test_user |> Repo.insert!
    deck = @test_deck |> Repo.insert!

    changeset = %Ticket{} |> Ticket.changeset(%{
      name: "sample name",
      owner_id: user.id,
      deck_id: deck.id
    })

    refute changeset.valid?
  end

  test "ticket changeset without game is not valid" do
    changeset = %Ticket{} |> Ticket.changeset(%{
      name: "test name"
    })
    refute changeset.valid?
  end

  test "ticket with name and game is valid" do
    user = @test_user |> Repo.insert!
    deck = @test_deck |> Repo.insert!

    game = %Game{
      name: "sample name",
      owner_id: user.id,
      deck_id: deck.id
    } |> Repo.insert!


    changeset = %Ticket{} |> Ticket.changeset(%{
      name: "test name",
      game_id: game.id
    })

    assert changeset.valid?
  end
end

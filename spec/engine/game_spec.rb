# frozen_string_literal: true

require 'spec_helper'

RSpec.describe(FollowTheJoker::Engine::Game) do
  subject { described_class.new }

  it 'starts with the correct number of users' do
    expect(subject.users.size).to(eq(6))
  end

  it 'splits the users into two teams' do
    teams = subject.users.partition { |u| u.team.name == 1 }
    expect(teams.size).to(eq(2))

    teams.each do |team|
      expect(team.size).to(eq(3))
    end
  end

  describe 'can play' do
    let(:game) { described_class.new(shuffle_seed: 0) }
    let(:user_1_team_1) { game.users[0] }
    let(:user_2_team_2) { game.users[1] }
    let(:user_3_team_1) { game.users[2] }
    let(:user_4_team_2) { game.users[3] }
    let(:user_5_team_1) { game.users[4] }
    let(:user_6_team_2) { game.users[5] }

    it 'one round with singles' do
      user = game.current_user
      expect(user).to(eq(user_1_team_1))
      cards = user.cards.first # 3 of Hearts
      game.play(user, action: :play, cards: cards)

      user = game.current_user
      expect(user).to(eq(user_2_team_2))
      cards = user.cards[4] # 4 of Spades
      game.play(user, action: :play, cards: cards)

      user = game.current_user
      expect(user).to(eq(user_3_team_1))
      game.play(user, action: :skip)

      user = game.current_user
      expect(user).to(eq(user_4_team_2))
      cards = user.cards[-1] # Big Joker
      game.play(user, action: :play, cards: cards)

      user = game.current_user
      expect(user).to(eq(user_5_team_1))
      game.play(user, action: :skip)

      user = game.current_user
      expect(user).to(eq(user_6_team_2))
      game.play(user, action: :skip)

      user = game.current_user
      expect(user).to(eq(user_1_team_1)) # loop back!
      game.play(user, action: :skip)

      user = game.current_user
      expect(user).to(eq(user_2_team_2)) # loop back!
      game.play(user, action: :skip)

      user = game.current_user
      expect(user).to(eq(user_3_team_1)) # loop back!
      game.play(user, action: :skip)

      user = game.current_user
      expect(user).to(eq(user_4_team_2)) # should be turn again
      expect(user.cards.count).to(eq(25))
    end

    context 'when one person finishes' do
      let(:game) { described_class.new(shuffle_seed: 0) }

      it 'considers that person "帮龙头"' do
        user = game.current_user

        user.cards.reverse.each do |card| # modifying the array in place, so do it opposite to array iteration direction
          game.play(user, action: :play, cards: card)

          (game.users - [user]).each do |other|
            game.play(other, action: :skip)
          end
        end

        expect(user.cards).to(be_empty)
      end
    end
  end
end

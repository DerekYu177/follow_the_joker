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

    def finish(user)
      user.cards.reverse.each do |card|
        game.turn(user, action: :play, cards: card)

        if !game.round.finished? && !user.finished?
          game.turn(game.current_user, action: :skip) until game.current_user == user
        end
      end

      expect(user.cards).to(be_empty)
    end

    it 'one round with singles' do
      user = game.current_user
      expect(user).to(eq(user_1_team_1))
      cards = user.cards.first # 3 of Hearts
      game.turn(user, action: :play, cards: cards)

      user = game.current_user
      expect(user).to(eq(user_2_team_2))
      cards = user.cards[4] # 4 of Spades
      game.turn(user, action: :play, cards: cards)

      user = game.current_user
      expect(user).to(eq(user_3_team_1))
      game.turn(user, action: :skip)

      user = game.current_user
      expect(user).to(eq(user_4_team_2))
      cards = user.cards[-1] # Big Joker
      game.turn(user, action: :play, cards: cards)

      user = game.current_user
      expect(user).to(eq(user_5_team_1))
      game.turn(user, action: :skip)

      user = game.current_user
      expect(user).to(eq(user_6_team_2))
      game.turn(user, action: :skip)

      user = game.current_user
      expect(user).to(eq(user_1_team_1)) # loop back!
      game.turn(user, action: :skip)

      user = game.current_user
      expect(user).to(eq(user_2_team_2)) # loop back!
      game.turn(user, action: :skip)

      user = game.current_user
      expect(user).to(eq(user_3_team_1)) # loop back!
      game.turn(user, action: :skip)

      user = game.current_user
      expect(user).to(eq(user_4_team_2)) # should be turn again
      expect(user.cards.count).to(eq(25))
    end

    context 'when one person finishes' do
      let(:game) { described_class.new(shuffle_seed: 0) }

      it 'considers that person "?????????"' do
        user = game.current_user
        finish(user)
        expect(user.team.dragon_head).to(eq(user_1_team_1))

        # check that the winner isn't called the next time around

        user = game.current_user
        expect(user).to(eq(user_2_team_2))
        card = user.cards.first
        game.turn(user, action: :play, cards: card)

        (game.users - [user, user_1_team_1]).each do |other|
          game.turn(other, action: :skip)
        end

        expect(user).to(eq(user_2_team_2))
      end
    end

    context 'when one team has finished' do
      before do
        game.users.each_slice(2).each do |winning_team_user, losing_team_user|
          finish(winning_team_user)

          unless game.round.finished?
            expect(game.current_user).to(eq(losing_team_user))
            game.turn(losing_team_user, action: :play, cards: losing_team_user.cards.first)
          end
        end
      end

      it 'locks the other team in' do
        winning_team = game.teams.first
        winning_team.users.each do |user|
          expect(user).to(be_finished)
        end

        losing_team = game.teams.last
        losing_team.users.each do |user|
          expect(user).not_to(be_finished)
        end

        expect(losing_team.jail).to(eq(losing_team.users))
      end

      it 'increments the priority_card' do
        winning_team = game.teams.first
        expect(winning_team.priority_card).to(eq(5))
      end

      it 'raises if the next user tries to play' do
        user = game.users.reject(&:finished?).first
        expect { game.turn(user, action: :play, cards: user.cards.first) }
          .to(raise_error(FollowTheJoker::Engine::RoundAlreadyFinishedError))
      end

      it 'resets for next round' do
        game.next_round!

        game.users.each do |user|
          expect(user.cards.count).to(eq(FollowTheJoker::Engine::Deck::CARDS_PER_HAND))
        end

        game.teams.each do |team|
          expect(team.dragon_head?).to(be_falsey)
          expect(team.jail).to(be_empty)
        end
      end
    end
  end
end

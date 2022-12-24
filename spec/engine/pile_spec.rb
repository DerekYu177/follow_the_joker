# frozen_string_literal: true

require 'spec_helper'

RSpec.describe(FollowTheJoker::Engine::Pile) do
  let(:pile) do
    described_class.new(
      current_round: current_round,
      previous_rounds: previous_rounds,
    )
  end
  let(:current_round) { [] }
  let(:previous_rounds) { [] }

  describe '#add' do
    let(:cards) { [FollowTheJoker::Engine::Card.new(suit: 'Spades', rank: 2)] }
    let(:team) { FollowTheJoker::Engine::Team.new('A') }
    let(:user) { FollowTheJoker::Engine::User.new('Derek', team: team, pile: pile) }

    subject do
      pile.add(cards: cards, user: user)
    end

    context 'when the round has not started' do
      let(:current_round) { [] }

      it 'adds to current round' do
        expect { subject }.to(change { pile.current_round.size }.by(+1))
        last_play = pile.current_round.last
        expect(last_play[:cards]).to(eq(cards))
        expect(last_play[:user]).to(eq(user))
      end
    end

    context 'when hands are different sizes' do

    end

    context 'when previous hand was greater' do
      context 'with one card' do

      end

      context 'with two cards' do

      end

      context 'with three cards' do

      end

      context 'with five cards' do

      end
    end
  end

  describe '#top' do

  end

  describe '#round_won!' do

  end
end

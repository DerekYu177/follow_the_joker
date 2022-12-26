# frozen_string_literal: true

require 'spec_helper'

RSpec.describe(FollowTheJoker::Engine::FiveCardsPlay) do
  subject do
    described_class.new(cards)
  end

  describe '#flush?' do
    let(:cards) do
      [
        FollowTheJoker::Engine::Card.new(2, suit: 'Spades'),
        FollowTheJoker::Engine::Card.new(5, suit: 'Spades'),
        FollowTheJoker::Engine::Card.new(8, suit: 'Spades'),
        FollowTheJoker::Engine::Card.new(9, suit: 'Spades'),
        FollowTheJoker::Engine::Card.new(3, suit: 'Spades'),
      ]
    end

    it { is_expected.to(be_a_flush) }
    it { is_expected.to(be_valid) }
    it { expect(subject.value).to(eq([described_class::FLUSH, 9])) }
  end

  describe '#straight?' do
    let(:cards) do
      [
        FollowTheJoker::Engine::Card.new(2, suit: 'Spades'),
        FollowTheJoker::Engine::Card.new(5, suit: 'Hearts'),
        FollowTheJoker::Engine::Card.new(6, suit: 'Diamonds'),
        FollowTheJoker::Engine::Card.new(4, suit: 'Clubs'),
        FollowTheJoker::Engine::Card.new(3, suit: 'Spades'),
      ]
    end

    it { is_expected.to(be_a_straight) }
    it { is_expected.to(be_valid) }
    it { expect(subject.value).to(eq([described_class::STRAIGHT, 6])) }
  end

  describe '#three_plus_two?' do
    let(:cards) do
      [
        FollowTheJoker::Engine::Card.new(2),
        FollowTheJoker::Engine::Card.new(2),
        FollowTheJoker::Engine::Card.new(7),
        FollowTheJoker::Engine::Card.new(7),
        FollowTheJoker::Engine::Card.new(7),
      ]
    end

    it { is_expected.to(be_a_three_plus_two) }
    it { is_expected.to(be_valid) }
    it { expect(subject.value).to(eq([described_class::THREE_PLUS_TWO, 7])) }
  end

  describe '#four_plus_one?' do
    let(:cards) do
      [
        FollowTheJoker::Engine::Card.new(2),
        FollowTheJoker::Engine::Card.new(9),
        FollowTheJoker::Engine::Card.new(9),
        FollowTheJoker::Engine::Card.new(9),
        FollowTheJoker::Engine::Card.new(9),
      ]
    end

    it { is_expected.to(be_a_four_plus_one) }
    it { is_expected.to(be_valid) }
    it { expect(subject.value).to(eq([described_class::FOUR_PLUS_ONE, 9])) }
  end

  describe '#straight_flush?' do
    let(:cards) do
      [
        FollowTheJoker::Engine::Card.new(9, suit: 'Spades'),
        FollowTheJoker::Engine::Card.new(10, suit: 'Spades'),
        FollowTheJoker::Engine::Card.new(11, suit: 'Spades'),
        FollowTheJoker::Engine::Card.new(12, suit: 'Spades'),
        FollowTheJoker::Engine::Card.new(13, suit: 'Spades'),
      ]
    end

    it { is_expected.to(be_a_straight_flush) }
    it { is_expected.to(be_valid) }
    it { expect(subject.value).to(eq([described_class::STRAIGHT_FLUSH, 13])) }
  end

  describe '#five_of_a_kind?' do
    let(:cards) do
      [
        FollowTheJoker::Engine::Card.new(2),
        FollowTheJoker::Engine::Card.new(2),
        FollowTheJoker::Engine::Card.new(2),
        FollowTheJoker::Engine::Card.new(2),
        FollowTheJoker::Engine::Card.new(2),
      ]
    end

    it { is_expected.to(be_a_five_of_a_kind) }
    it { is_expected.to(be_valid) }
    it { expect(subject.value).to(eq([described_class::FIVE_OF_A_KIND, 2])) }
  end
end

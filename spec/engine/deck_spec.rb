# frozen_string_literal: true

require 'spec_helper'

RSpec.describe(FollowTheJoker::Engine::Deck) do
  describe '.build' do
    subject do
      described_class.new.build
    end

    it 'contains 54 cards' do
      expect(subject.size).to(eq(54))
    end

    it 'contains 2 jokers, one big, one small' do
      jokers = subject.select(&:joker?).sort
      expect(jokers.size).to(eq(2))
      expect(jokers.map(&:rank)).to(eq([16, 17]))
    end

    it 'contains 13 of each suit' do
      regular = subject.reject(&:joker?)
      FollowTheJoker::Engine::Card::SUITS.each do |suit|
        suit_cards = regular.select { |card| card.suit == suit }
        expect(suit_cards.size).to(eq(13))
        suit_card_ranks = suit_cards.map(&:rank)
        expect(suit_card_ranks).to(eq([*2..FollowTheJoker::Engine::Card::ACE]))
      end
    end
  end
end

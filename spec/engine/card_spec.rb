# frozen_string_literal: true

require 'spec_helper'

RSpec.describe(FollowTheJoker::Engine::Card) do
  describe('rank comparison') do
    let(:suit) { 'Spades' }
    let(:card) { described_class.new(5, suit: suit) }

    it 'uses rank to compare different suit cards' do
      other = described_class.new(4, suit: suit)
      expect(card.rank).to(be > other.rank)
    end

    it 'uses rank to compare same suit cards' do
      other = described_class.new(5, suit: 'Clubs')
      expect(card.rank).to(eq(other.rank))
    end
  end
end

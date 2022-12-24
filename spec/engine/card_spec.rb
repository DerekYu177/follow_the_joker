# frozen_string_literal: true

require 'spec_helper'

RSpec.describe(FollowTheJoker::Engine::Card) do
  describe('rank comparison') do
    let(:suit) { 'Spades' }
    let(:card) { described_class.new(rank: 5, suit: suit) }

    it 'uses rank to compare different suit cards' do
      other = described_class.new(rank: 4, suit: suit)
      expect(card > other).to(be_truthy)
    end

    it 'uses rank to compare same suit cards' do
      other = described_class.new(rank: 5, suit: 'Clubs')
      expect(card == other).to(be_truthy)
    end
  end
end

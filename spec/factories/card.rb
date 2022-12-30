# frozen_string_literal: true

require_relative '../../lib/follow_the_joker/engine/deck'
require_relative '../../lib/follow_the_joker/cli/card'

FactoryBot.define do
  factory :card, class: "FollowTheJoker::Engine::Card" do
    suit { 'Spades' }
    rank { 2 }

    FollowTheJoker::Engine::Deck.build.each do |card|
      trait_shorthand = FollowTheJoker::CLI::Card.new(card).shorthand

      trait trait_shorthand.to_sym do
        suit { card.suit }
        rank { card.rank }
      end
    end

    initialize_with { new(rank, suit: suit) }
  end
end

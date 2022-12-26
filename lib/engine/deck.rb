# frozen_string_literal: true

require_relative 'card'

module FollowTheJoker
  module Engine
    class Deck
      CARDS_PER_DECK = 52
      CARDS_PER_HAND = CARDS_PER_DECK / 2

      class << self
        def build_with(user_count)
          cards = (user_count / 2).times.map { self.build }.flatten
          Deck.new(cards)
        end

        def build
          cards = []

          Card::SUITS.each do |suit|
            Card::SUIT_CARD_RANKS.each do |value|
              cards << Card.new(suit: suit, rank: value)
            end
          end

          Card::JOKER_CARD_RANKS.each do |value|
            cards << Card.new(rank: value)
          end

          cards
        end
      end

      attr_accessor :cards

      def initialize(cards)
        # assume already shuffled
        # correct with the number of users
        @cards = cards
      end

      def each_user(users)
        # each user gets half a deck
        cards_per_user = @cards.each_slice(CARDS_PER_HAND).to_a
        users.zip(cards_per_user) { |user, cards| yield(user, cards) }
      end
    end
  end
end

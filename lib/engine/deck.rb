# frozen_string_literal: true

require_relative 'card'

module FollowTheJoker
  module Engine
    class Deck
      CARDS_PER_DECK = 52
      CARDS_PER_HAND = CARDS_PER_DECK / 2

      class << self
        def deal!(users:)
          # reject if users is an odd number

          number_of_users = users.count
          number_of_decks = number_of_users / 2
          set = number_of_decks.times.map { self.new.build }.flatten
          set.shuffle!

          # each user gets half a deck
          dealt_cards = set.each_slice(CARDS_PER_HAND).to_a

          users.zip(dealt_cards).each do |user, hand|
            user.deal!(hand)
          end
        end
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
  end
end

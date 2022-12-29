# frozen_string_literal: true

module FollowTheJoker
  module CLI
    class Card
      SUIT_SHORTHANDS = {
        "d" => "Diamonds",
        "c" => "Clubs",
        "h" => "Hearts",
        "s" => "Spades",
      }

      class << self
        def expand_rank_shorthand(shorthand)
          case shorthand
          when "J" then JACK
          when "Q" then QUEEN
          when "K" then KING
          when "A" then ACE
          when "!" then LITTLE_JOKER
          when "!*" then BIG_JOKER
          else
            shorthand.to_i
          end
        end

        def find(input, user:)
          # input takes the rank-suit
          # i.e. Ace of Spades = A-S
          # ranks = [2, 3, 4, 5, 6, 7, 8, 9, 10, J, Q, K, A]
          # suits = [Diamonds = d, Clubs = c, Hearts = h, Spades = s)]
          # for Jokers, theres !, and !*, for little joker and big joker respectively
          cards = []

          input.split.each do |command|
            rank_shorthand, suit_shorthand = command.split("-")

            suit = SUIT_SHORTHANDS[suit_shorthand]
            rank = expand_rank_shorthand(rank_shorthand)

            card = user
              .cards
              .reject { |card| cards.include?(card) }
              .find { |card| card.original_rank == rank && card.suit == suit }

            cards << card
          end

          cards
        end
      end

      attr_reader :card

      def initialize(card)
        @card = card
      end

      def shorthand
        # rank-suit
        [rank_shorthand, suit_shorthand].compact.join("-")
      end

      private

      def rank_shorthand
        case card.original_rank
        when Engine::Card::JACK then "J"
        when Engine::Card::QUEEN then "Q"
        when Engine::Card::KING then "K"
        when Engine::Card::ACE then "A"
        when Engine::Card::LITTLE_JOKER then "!"
        when Engine::Card::BIG_JOKER then "!*"
        else
          card.original_rank.to_s
        end
      end

      def inspect
        card.inspect
      end
      alias_method :to_s, :inspect

      def suit_shorthand
        SUIT_SHORTHANDS.to_a.each(&:reverse!).to_h[card.suit]
      end
    end
  end
end

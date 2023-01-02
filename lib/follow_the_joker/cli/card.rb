# frozen_string_literal: true

require_relative '../engine/card'

module FollowTheJoker
  module CLI
    class Card
      SUIT_SHORTHANDS = {
        'd' => 'Diamonds',
        'c' => 'Clubs',
        'h' => 'Hearts',
        's' => 'Spades',
      }.freeze

      class << self
        def expand_rank_shorthand(shorthand)
          case shorthand
          when 'J'  then Engine::Card::JACK
          when 'Q'  then Engine::Card::QUEEN
          when 'K'  then Engine::Card::KING
          when 'A'  then Engine::Card::ACE
          when 'lJ' then Engine::Card::LITTLE_JOKER
          when 'bJ' then Engine::Card::BIG_JOKER
          else
            shorthand.to_i
          end
        end

        def to_engine_card(shorthand)
          rank_shorthand, suit_shorthand = shorthand.split('-')

          suit = SUIT_SHORTHANDS[suit_shorthand]
          rank = expand_rank_shorthand(rank_shorthand)

          Engine::Card.new(rank, suit: suit)
        end

        def find(input, user:)
          # input takes the rank-suit
          # i.e. Ace of Spades = A-S
          # ranks = [2, 3, 4, 5, 6, 7, 8, 9, 10, J, Q, K, A]
          # suits = [Diamonds = d, Clubs = c, Hearts = h, Spades = s)]
          # for Jokers, theres !, and !*, for little joker and big joker respectively
          found_cards = []

          input.split.each do |command|
            rank_shorthand, suit_shorthand = command.split('-')

            suit = SUIT_SHORTHANDS[suit_shorthand]
            rank = expand_rank_shorthand(rank_shorthand)

            found_card = user
              .cards
              .reject { |card| found_cards.include?(card) }
              .find { |card| card.original_rank == rank && card.suit == suit }

            found_cards << found_card
          end

          found_cards
        end

        def all
          @all ||= Engine::Deck.build.map do |card|
            new(card).shorthand
          end
        end
      end

      attr_reader :card

      def initialize(card)
        @card = card
      end

      def shorthand
        # rank-suit
        [rank_shorthand, suit_shorthand].compact.join('-')
      end

      private

      def rank_shorthand
        case card.original_rank
        when Engine::Card::JACK         then 'J'
        when Engine::Card::QUEEN        then 'Q'
        when Engine::Card::KING         then 'K'
        when Engine::Card::ACE          then 'A'
        when Engine::Card::LITTLE_JOKER then 'lJ'
        when Engine::Card::BIG_JOKER    then 'bJ'
        else
          card.original_rank.to_s
        end
      end

      def inspect
        card.inspect
      end
      alias to_s inspect

      def suit_shorthand
        SUIT_SHORTHANDS.to_a.each(&:reverse!).to_h[card.suit]
      end
    end
  end
end

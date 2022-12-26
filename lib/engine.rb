require_relative 'engine/card'
require_relative 'engine/user'
require_relative 'engine/game'
require_relative 'engine/deck'
require_relative 'engine/team'

module FollowTheJoker
  module Engine
    class EngineError < StandardError; end

    class CardsError < EngineError
      attr_reader :previous, :current
      def initialize(previous, current)
        @previous = previous
        @current = current
      end
    end

    class FourCardsError < CardsError; end

    class GreaterCardsRankRequiredError < CardsError
      def message
        previous_rank = previous.map(&:rank).uniq.first
        current_rank = current.map(&:rank).uniq.first

        "Previous hand was #{previous} with rank #{previous_rank}. " \
        "You'll need to play a card(s) with rank of at least #{previous_rank + 1}. " \
        "You currently played #{current} with rank #{current_rank}"
      end
    end

    class CardCountMismatchError < CardsError
      def message
        "Previous hand was #{previous} with size #{previous.size}. " \
        "Current hand was #{current}, with size #{current.size}"
      end
    end

    class CardRankNotSame < CardsError
      def message
        cards = current.group_by { |card| card.rank }.values
        minority = cards.min { |a, b| a.size <=> b.size }
        majority = cards.flatten - minority

        "Card(s) #{minority.map(&:to_s)} should be a #{majority.first.humanized_rank}"
      end
    end

    class CannotSkipError < EngineError
      def message
        "You cannot skip your turn if you're the first one playing!"
      end
    end
  end
end

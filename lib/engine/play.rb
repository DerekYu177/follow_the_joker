# frozen_string_literal: true

module FollowTheJoker
  module Engine
    class Play
      Record = Struct.new(:cards, :user, keyword_init: true) do
        def inspect
          "#{cards} played by #{user}"
        end
        alias_method :to_s, :inspect
      end

      class HandError < StandardError
        attr_reader :previous, :current
        def initialize(previous, current)
          @previous = previous
          @current = current
        end
      end

      class IllegalHandSizeError < HandError; end
      class GreaterHandRequiredError < HandError
        def message
          "Previous hand was #{previous} with rank #{previous.map(&:rank)}. " \
          "Current hand was #{current} with rank #{current.map(&:rank)}"
        end
      end
      class HandSizeMismatchError < HandError
        def message
          "Previous hand was #{previous} with size #{previous.size}. " \
          "Current hand was #{current}, with size #{current.size}"
        end
      end

      attr_reader :previous_cards, :cards

      def initialize(previous_cards, cards)
        @previous_cards = previous_cards
        @cards = cards
      end

      def valid?
        return true if previous_cards.empty?
        raise HandSizeMismatchError.new(previous_cards, cards) unless same_size_hand?

        case previous_cards.size
        when 1, 2, 3
          raise GreaterHandRequiredError.new(previous_cards, cards) unless greater_hand?
        when 4
          raise IllegalHandSizeError
        when 5
          raise 'not supported yet'
        end
      end

      def record_with(user)
        Record.new(cards: cards, user: user)
      end

      private

      def same_size_hand?
        previous_cards.size == cards.size
      end

      def greater_hand?
        previous_cards.first.rank < cards.first.rank
      end
    end
  end
end

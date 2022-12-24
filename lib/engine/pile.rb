# frozen_string_literal: true

module FollowTheJoker
  module Engine
    # represents the stack of cards that are currently in play
    class Pile
      class HandError < StandardError; end
      class IllegalHandSizeError < HandError; end
      class GreaterHandRequiredError < HandError; end
      class HandSizeMismatchError < HandError; end

      attr_reader :current_round

      def initialize(current_round: [], previous_rounds: [])
        @current_round = current_round
        @previous_rounds = previous_rounds
      end

      def add(cards:, user:)
        # check that it matches the current top frame
        valid?(cards)

        @current_round << { cards: cards, user: user }
      end

      def top
        @current_round.last
      end

      def round_won!
        @previous_rounds << @current_round
        @current_round = []
      end

      def current_play
        current_round.reverse.map { |play| "#{play[:cards]} by #{play[:user].name}"}
      end

      private

      def valid?(cards)
        @current_round.empty? || (correct_size?(cards) && greater_than_top?(cards))
      end

      def correct_size?(cards)
        raise HandSizeMismatchError unless cards.size == top.size
      end

      def greater_than_top?(cards)
        greater = case cards.size
        when 1, 2, 3
          cards.first.rank > top.first.rank
        when 4
          raise IllegalHandSizeError
        when 5
          raise 'not supported yet'
        end

        raise GreaterHandRequiredError unless greater
      end
    end
  end
end

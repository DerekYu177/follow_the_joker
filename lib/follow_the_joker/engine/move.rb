# frozen_string_literal: true

module FollowTheJoker
  module Engine
    class Move
      Record = Struct.new(:cards, :user, keyword_init: true) do
        def inspect
          "#{cards} played by #{user}"
        end
        alias_method :to_s, :inspect
      end

      attr_reader :previous_cards, :cards

      def initialize(previous_cards, cards)
        @previous_cards = previous_cards
        @cards = cards
      end

      def valid?
        case cards.size
        when 1, 2, 3
          raise CardRankNotSame.new(previous_cards, cards) unless equivalent_card_ranks?
        when 4
          raise FourCardsError
        when 5
          raise InvalidSetOfFiveError.new(previous_cards, cards) unless FiveCardsMove.new(cards).valid?
        end

        return true if previous_cards.empty?

        raise CardCountMismatchError.new(previous_cards, cards) unless same_size_hand?

        case previous_cards.size
        when 1, 2, 3
          raise GreaterCardsRankRequiredError.new(previous_cards, cards) unless greater_hand?
        when 4
          raise FourCardsError
        when 5
          raise GreaterFiveCardsRankRequiredError.new() unless greater_set_of_five?
        end

        true
      end

      def record_with(user)
        Record.new(cards: cards, user: user).to_s
      end

      private

      def greater_set_of_five?
        previous = FiveCardsMove.new(previous_cards).value
        current = FiveCardsMove.new(cards).value
        return false if previous == current

        [ previous, current ].max == current
      end

      def equivalent_card_ranks?
        cards.map(&:rank).uniq.size == 1 || cards.reject(&:joker?).uniq.size == 1
      end

      def same_size_hand?
        previous_cards.size == cards.size
      end

      def greater_hand?
        previous_cards.sort_by(&:rank).first.rank < cards.sort_by(&:rank).first.rank
      end
    end
  end
end

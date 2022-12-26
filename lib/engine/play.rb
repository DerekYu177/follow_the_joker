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
          raise 'not supported yet'
        end

        return true if previous_cards.empty?

        raise CardCountMismatchError.new(previous_cards, cards) unless same_size_hand?

        case previous_cards.size
        when 1, 2, 3
          raise GreaterCardsRankRequiredError.new(previous_cards, cards) unless greater_hand?
        when 4
          raise FourCardsError
        when 5
          raise 'not supported yet'
        end
      end

      def record_with(user)
        Record.new(cards: cards, user: user)
      end

      private

      def equivalent_card_ranks?
        cards.map(&:rank).uniq.size == 1
      end

      def same_size_hand?
        previous_cards.size == cards.size
      end

      def greater_hand?
        previous_cards.first.rank < cards.first.rank
      end
    end
  end
end

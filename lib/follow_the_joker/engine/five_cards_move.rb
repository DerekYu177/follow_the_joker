# frozen_string_literal: true

module FollowTheJoker
  module Engine
    class FiveCardsMove
      FLUSH = 1
      STRAIGHT = 2
      THREE_PLUS_TWO = 3
      FOUR_PLUS_ONE = 4
      STRAIGHT_FLUSH = 5
      FIVE_OF_A_KIND = 6

      attr_reader :cards

      def initialize(cards)
        @cards = cards
      end

      def value
        # always call valid before hand
        [ type, rank ]
      end

      def type
        return FIVE_OF_A_KIND if five_of_a_kind?
        return STRAIGHT_FLUSH if straight_flush?
        return FOUR_PLUS_ONE if four_plus_one?
        return THREE_PLUS_TWO if three_plus_two?
        return STRAIGHT if straight?
        return FLUSH if flush?
      end

      def rank
        case type
        when FIVE_OF_A_KIND
          group_of(5).first
        when STRAIGHT_FLUSH, STRAIGHT, FLUSH
          cards.map(&:original_rank).sort.last
        when FOUR_PLUS_ONE
          group_of(4, 1).first
        when THREE_PLUS_TWO
          group_of(3, 2).first
        end
      end

      def valid?
        !!type
      end

      def flush?
        cards.map(&:suit).uniq.size == 1
      end

      def straight?
        cards.map(&:original_rank).sort.each_cons(2).all? { |before, c| c == before + 1 }
      end

      def three_plus_two?
        group_of(3, 2)
      end

      def four_plus_one?
        group_of(4, 1)
      end

      def straight_flush?
        flush? && straight?
      end

      def five_of_a_kind?
        group_of(5)
      end

      private

      def group_of(big_count, small_count = nil)
        grouped_cards = cards.map(&:rank).group_by(&:itself).values
        return false unless grouped_cards.size == [big_count, small_count].compact.size

        big, small = grouped_cards.sort_by { |group| group.size }.reverse
        return false unless big.size == big_count
        return false unless big.uniq.size == 1
        return big if small.nil?

        return false unless small.size == small_count
        return false unless small.uniq.size == 1

        big
      end
    end
  end
end

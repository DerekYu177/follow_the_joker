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

        nil
      end

      def rank
        case type
        when FIVE_OF_A_KIND
          group_of(5).first
        when STRAIGHT_FLUSH, STRAIGHT, FLUSH
          cards.map(&:rank).sort.last
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
        jokers, regulars = cards.partition(&:joker?)

        if jokers.present?
          cast_jokers_to(:suit, regulars.first.suit) if same_suit?(regulars)
        end

        same_suit?(cards)
      end

      def straight?
        jokers, regulars = cards.partition(&:joker?)

        if jokers.present?
          missing = determine_missing_digits(regulars.map(&:original_rank))
          cast_jokers_to(:rank, missing) if jokers.count == missing.count
        end

        consecutive?(cards.map(&:rank))
      end

      def three_plus_two?
        jokers, regulars = cards.partition(&:joker?)

        if jokers.present?
          _minority_ranks, majority_ranks = regulars.group_by(&:rank).values.sort_by(&:size)
          majority_rank = majority_ranks.last.rank
          cast_jokers_to(:rank, majority_rank)
        end

        group_of(3, 2)
      end

      def four_plus_one?
        jokers, regulars = cards.partition(&:joker?)

        if jokers.present?
          _minority_ranks, majority_ranks = regulars.group_by(&:rank).values.sort_by(&:size)
          majority_rank = majority_ranks.last.rank
          cast_jokers_to(:rank, majority_rank)
        end

        group_of(4, 1)
      end

      def straight_flush?
        flush? && straight?
      end

      def five_of_a_kind?
        jokers, regulars = cards.partition(&:joker?)

        if jokers.present?
          jokers = jokers.sort_by(&:rank)
          regulars = regulars.sort_by(&:original_rank)

          # the lowest rank is either the smallest regular card
          # or in extreme circumstances where the whole hand is jokers
          # will be quivalent to the rank of the smallest joker

          cast_jokers_to(:rank, (regulars.first || jokers.first).rank) if jokers.count + regulars.count == 5
        end

        group_of(5)
      end

      private

      def consecutive?(list)
        list.sort.each_cons(2).all? { |a, b| b == a + 1 }
      end

      def same_suit?(list)
        list.map(&:suit).uniq.size == 1
      end

      def determine_missing_digits(input, missing = [])
        # FUN MINI CHALLENGE:
        # given an integer array of < 5
        # provide an output such that output is a consecutive list of five integers from a specified list
        # specified list = [*2..14]

        input.sort!
        return missing if input.size == 5

        if consecutive?(input)
          highest_value = input.last
          lowest_value = input.first

          if highest_value == FollowTheJoker::Engine::Card::SUIT_CARD_RANKS.last
            missing << lowest_value - 1
          else
            missing << highest_value + 1
          end
        else
          normalized_input = input.map { |i| i - input.first }
          gap = ([*0..4] - normalized_input).map { |i| i + input.first }
          missing.push(*gap)
        end

        if missing.size + input.size < 5
          run(input + missing, missing)
        end

        missing
      end

      def cast_jokers_to(type, values)
        jokers = cards.select(&:joker?)
        values = values.is_a?(Array) ? values : [values] * jokers.size

        if type == :rank
          jokers.zip(values).each { |joker, rank| joker.rank = rank }
        elsif type == :suit
          jokers.zip(values).each { |joker, suit| joker.suit = suit }
        end
      end

      def group_of(big_count, small_count = nil)
        grouped_cards = cards.map(&:rank).group_by(&:itself).values
        return false unless grouped_cards.size == [big_count, small_count].compact.size

        big, small = grouped_cards.sort_by(&:size).reverse
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

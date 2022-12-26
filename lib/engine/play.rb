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

      class CardsError < StandardError
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

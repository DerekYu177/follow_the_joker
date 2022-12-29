# frozen_string_literal: true

module FollowTheJoker
  module Engine
    class Card
      SUITS = %w(Diamonds Clubs Hearts Spades)

      NUMBER_CARD_RANKS = [*2..10]
      FACE_CARD_RANKS = [
        JACK = 11,
        QUEEN = 12,
        KING = 13,
        ACE = 14,
      ]
      SUIT_CARD_RANKS = NUMBER_CARD_RANKS + FACE_CARD_RANKS
      PROMOTED_RANK = 15
      JOKER_CARD_RANKS = [
        LITTLE_JOKER = 16,
        BIG_JOKER = 17
      ]

      include Comparable

      attr_reader :suit, :rank, :original_rank

      class << self
        def humanize_rank(card)
          case card.rank
          when JACK then "Jack"
          when QUEEN then "Queen"
          when KING then "King"
          when ACE then "Ace"
          when PROMOTED_RANK then "#{card.original_rank} (Promoted)"
          when LITTLE_JOKER then "Little Joker"
          when BIG_JOKER then "Big Joker"
          else
            card.rank.to_s
          end
        end
      end

      def initialize(rank, suit: nil)
        validate_rank!
        validate_suit!
        validate_current!

        @original_rank = rank.dup
        @rank = rank
        @suit = suit
      end

      def inspect
        "<#{[self.class.humanize_rank(self), suit].compact.join(" of ")}>"
      end
      alias_method :to_s, :inspect

      def promote!
        @rank = PROMOTED_RANK
      end

      def joker?
        suit.nil? && JOKER_CARD_RANKS.include?(rank)
      end

      def humanized_rank
        self.class.humanize_rank(self)
      end

      private

      def validate_rank!
      end

      def validate_suit!
      end

      def validate_current!
        # boolean
      end
    end
  end
end

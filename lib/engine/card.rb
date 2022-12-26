# frozen_string_literal: true

module FollowTheJoker
  module Engine
    class Card
      CURRENT = 2

      SUIT_SHORTHANDS = {
        "d" => "Diamonds",
        "c" => "Clubs",
        "h" => "Hearts",
        "s" => "Spades",
      }
      SUITS = SUIT_SHORTHANDS.values

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

        def expand_rank_shorthand(shorthand)
          case shorthand
          when "J" then JACK
          when "Q" then QUEEN
          when "K" then KING
          when "A" then ACE
          when "!" then LITTLE_JOKER
          when "!*" then BIG_JOKER
          else
            shorthand.to_i
          end
        end
      end

      def initialize(rank, suit: nil, current: nil)
        validate_rank!
        validate_suit!
        validate_current!

        @original_rank = rank.dup
        @rank = rank
        @suit = suit
        @current = current
      end

      def inspect
        "<#{[self.class.humanize_rank(self), suit].compact.join(" of ")}>"
      end
      alias_method :to_s, :inspect

      def promote!
        @current = true
        @rank = PROMOTED_RANK
      end

      def joker?
        suit.nil? && JOKER_CARD_RANKS.include?(rank)
      end

      def shorthand
        # rank-suit
        [rank_shorthand, suit_shorthand].compact.join("-")
      end

      def humanized_rank
        self.class.humanize_rank(self)
      end

      private

      def rank_shorthand
        case original_rank
        when JACK then "J"
        when QUEEN then "Q"
        when KING then "K"
        when ACE then "A"
        when LITTLE_JOKER then "!"
        when BIG_JOKER then "!*"
        else
          original_rank.to_s
        end
      end

      def suit_shorthand
        SUIT_SHORTHANDS.to_a.each(&:reverse!).to_h[suit]
      end

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

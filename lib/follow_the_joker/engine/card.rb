# frozen_string_literal: true

module FollowTheJoker
  module Engine
    class Card
      SUITS = %w(Diamonds Clubs Hearts Spades).freeze

      NUMBER_CARD_RANKS = [*2..10].freeze
      FACE_CARD_RANKS = [
        JACK = 11,
        QUEEN = 12,
        KING = 13,
        ACE = 14,
      ].freeze
      SUIT_CARD_RANKS = NUMBER_CARD_RANKS + FACE_CARD_RANKS
      PROMOTED_RANK = 15
      JOKER_CARD_RANKS = [
        LITTLE_JOKER = 16,
        BIG_JOKER = 17,
      ].freeze

      include Comparable

      attr_accessor :suit, :rank
      attr_reader :original_rank

      class << self
        def humanize_rank(card)
          humanized = case card.rank
                      when JACK           then 'Jack'
                      when QUEEN          then 'Queen'
                      when KING           then 'King'
                      when ACE            then 'Ace'
                      when PROMOTED_RANK  then card.original_rank.to_s
                      when LITTLE_JOKER   then 'Little Joker'
                      when BIG_JOKER      then 'Big Joker'
                      else
                        card.rank.to_s
                      end

          append = unless card.rank == card.original_rank
                     case card.original_rank
                     when PROMOTED_RANK  then '(Promoted)'
                     when LITTLE_JOKER   then '(as Little Joker)'
                     when BIG_JOKER      then '(as Big Joker)'
                     end
                   end

          [humanized, append].compact.join(' ')
        end
      end

      def initialize(rank, suit: nil)
        @original_rank = rank.dup
        @rank = rank
        @suit = suit
      end

      def inspect
        "<#{[self.class.humanize_rank(self), suit].compact.join(" of ")}>"
      end
      alias to_s inspect

      def promote!
        @rank = PROMOTED_RANK
      end

      def joker?
        JOKER_CARD_RANKS.include?(original_rank)
      end

      def humanized_rank
        self.class.humanize_rank(self)
      end
    end
  end
end

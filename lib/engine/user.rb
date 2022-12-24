# frozen_string_literal: true

module FollowTheJoker
  module Engine
    class User
      attr_accessor :name, :cards, :team, :pile

      def initialize(name, team:, pile:)
        @name = name

        @team = team
        @team.join!(self)

        @pile = pile
      end

      def deal!(cards)
        @original_cards = cards.dup
        @cards = cards.sort
      end

      def play!(cards)
        check_hand_is_subset_of_cards!

        pile.add(cards: cards, user: self)

        # adding the cards to the pile could raise, so we want to remove the cards later
        cards.each { |card| self.cards.delete(card) }
      end

      def inspect
        "<#{name} (team #{team.name}) with #{cards.count} cards remaining>"
      end

      def hand
        cards.map { |card| "\t#{card.shorthand}\t#{card}" }.join("\n")
      end

      def current_card=(current)
        cards.select { |card| card.rank == current }.map(&:promote!)
      end

      private

      def check_hand_is_subset_of_cards!
      end
    end
  end
end

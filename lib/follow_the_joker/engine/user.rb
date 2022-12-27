# frozen_string_literal: true

module FollowTheJoker
  module Engine
    class User
      attr_accessor :name, :cards, :team, :pile

      def initialize(name, team:)
        @name = name

        @team = team
        @team.join!(self)
      end

      def finished?
        @cards.empty?
      end

      def dragon_head!
        @team.dragon_head = self
      end

      def jail!
        @team.jail << self
      end

      def hand_cards!(cards)
        @original_cards = cards.dup
        @cards = cards.sort_by(&:rank)
      end

      def played!(cards)
        cards.each { |card| self.cards.delete(card) }
      end

      def inspect
        "<#{name} (team #{team.name}) with #{cards.count} cards remaining>"
      end
      alias_method :to_s, :inspect

      def hand
        cards
          .map { |card| "\t#{card.shorthand}\t\t#{card}" }
          .join("\n")
          .prepend("\tShorthand\tCard\n")
      end

      def current_card=(current)
        cards.select { |card| card.rank == current }.map(&:promote!)
        cards.sort_by!(&:rank)
      end
    end
  end
end

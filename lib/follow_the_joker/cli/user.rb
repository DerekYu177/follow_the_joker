# frozen_string_literal: true

require_relative 'card'

module FollowTheJoker
  module CLI
    class User
      attr_reader :user

      def initialize(user)
        @user = user
      end

      def hand
        user.cards
          .map { |card| Card.new(card) }
          .map { |card| "\t#{card.shorthand}\t\t#{card}" }
          .join("\n")
          .prepend("\tShorthand\tCard\n")
      end
    end
  end
end

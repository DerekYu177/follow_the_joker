# frozen_string_literal: true

require_relative 'deck'
require_relative 'card'
require_relative 'team'
require_relative 'pile'

module FollowTheJoker
  module Engine
    class Game
      NUMBER_OF_USERS = 6
      NUMBER_OF_DECKS = 3
      NAMES = %w(Ba Ma R RR RandomA RandomB)
      TEAM_NAMES = %w(1 2)

      attr_accessor :users, :pile

      def initialize(round: Card::CURRENT)
        @round = round
        @users = []
        @pile = Pile.new

        teams = TEAM_NAMES.map { |name| Team.new(name) }

        NAMES.each_with_index do |name, i|
          team = teams[i % 2]
          @users << User.new(name, team: team, pile: pile)
        end

        Deck.deal!(users: @users)
        @users.each { |user| user.current_card = round }
      end
    end
  end
end

# frozen_string_literal: true

require_relative 'deck'
require_relative 'card'
require_relative 'team'
require_relative 'move'
require_relative 'round'

module FollowTheJoker
  module Engine
    class Game
      FAMILY_MEMBERS = %w(Ba Ma R RR)

      attr_accessor :users
      attr_reader(
        :configuration,
        :teams,
        :round
      )

      def initialize(**configuration)
        configuration = {
          shuffle_seed: nil,
          number_of_users: 6,
          number_of_teams: 2,
        }.merge!(configuration)

        @configuration = configuration

        @teams = configuration[:number_of_teams].times.map { |i| Team.new(i+1) }
        @teams.first.initiative = true
        @users = build_users(configuration[:number_of_users], teams: @teams)

        @round = Round.new(self, priority_card: @teams.first.priority_card)
        @previous_rounds = []
      end

      def turn(...)
        @round.turn(...)
      end

      def current_user
        @round.current.user
      end

      def round_finished!
        @teams.each(&:round_finished!)
        @previous_rounds << @round

        winning_team = @teams.select(&:dragon_head?).first
      end

      def next_round!
        @round = Round.new(self, priority_card: winning_team.priority_card)
      end

      private

      def build_users(number_of_users, teams:)
        users = []

        names = FAMILY_MEMBERS[0...number_of_users] +
          (number_of_users - FAMILY_MEMBERS.size)
            .times.map { |i| "RandomUser-1" }

        names.each_with_index do |name, i|
          team = @teams[i % @teams.size]
          users << User.new(name, team: team)
        end

        users
      end
    end
  end
end

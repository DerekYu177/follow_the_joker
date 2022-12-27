# frozen_string_literal: true

require_relative 'deck'
require_relative 'card'
require_relative 'team'
require_relative 'play'

module FollowTheJoker
  module Engine
    class Game
      FAMILY_MEMBERS = %w(Ba Ma R RR)

      attr_accessor :users
      attr_reader :current_user, :current_pile, :current_play

      def initialize(**configuration)
        configuration = {
          round: Card::CURRENT,
          shuffle_seed: nil,
          number_of_users: 6,
          number_of_teams: 2,
        }.merge!(configuration)

        @configuration = configuration

        round = configuration[:round]
        @teams = configuration[:number_of_teams].times.map { |i| Team.new(i+1) }
        @users = build_users(configuration[:number_of_users], teams: @teams)

        @deck = Deck.build_with(@users.count)

        shuffle_seed = configuration[:shuffle_seed]
        shuffle_configuration = { random: (Random.new(shuffle_seed) if shuffle_seed) }.compact
        @deck.cards.shuffle!(**shuffle_configuration)

        @deck.each_user(@users) do |user, cards|
          user.hand_cards!(cards)
          user.current_card = round
        end

        @current_pile = []
        @current_play = []
        @current_user_index = 0
        @current_user = @users.first
        @current_skip_counter = 0
      end

      def play(user, action:, **kwargs)
        case action
        when :play
          cards = [*kwargs.delete(:cards)]

          play = Play.new([*@current_pile.last], cards)
          play.valid?

          # unless valid? raised
          @current_pile << cards.dup
          @current_play << play.record_with(user)
          user.played!(cards)

          user.dragon_head! if dragon_head?(user)
          end_round! if other_team_in_jail?
          @current_skip_counter = 0
        when :skip
          raise CannotSkipError if @current_pile.empty?
          @current_skip_counter += 1

          if everyone_skipped?
            @current_play = []
            @current_pile = []
            @current_skip_counter = 0
          end
        else
          raise "unknown action: #{action}"
        end

        next_user!
      end

      private

      def end_round!
        users.reject(&:finished?).each(&:jail!)
      end

      def other_team_in_jail?
        users.reject(&:finished?).map { |u| u.team.name }.uniq == 1
      end

      def dragon_head?(user)
        user.cards.empty? && (users - [user]).all? { |u| u.cards }
      end

      def everyone_skipped?
        @current_skip_counter == @users.count - 1
      end

      def next_user!
        unless defined?(@current_user_index)
          @current_user_index = 0
          return @users.first
        end

        @current_user_index = (@current_user_index + 1) % @users.count
        @current_user = @users[@current_user_index]

        next_user! if @current_user.finished?
      end

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

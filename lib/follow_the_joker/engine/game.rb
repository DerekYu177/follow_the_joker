# frozen_string_literal: true

require_relative 'deck'
require_relative 'card'
require_relative 'team'
require_relative 'play'

module FollowTheJoker
  module Engine
    class Game
      NUMBER_OF_USERS = 6
      NUMBER_OF_DECKS = 3
      USER_NAMES = %w(Ba Ma R RR RandomA RandomB)
      TEAM_NAMES = %w(1 2)

      attr_accessor :users
      attr_reader :current_user, :current_pile, :current_play

      def initialize(round: Card::CURRENT, shuffle_seed: nil, **kwargs)
        @round = round
        @users = []
        @teams = TEAM_NAMES.map { |name| Team.new(name) }
        @users = build_users(@teams)

        @deck = Deck.build_with(@users.count)

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
          @current_skip_counter = 0
        when :skip
          raise CannotSkipError if @current_pile.empty?
          @current_skip_counter += 1
        else
          raise "unknown action: #{action}"
        end

        end_game?

        if end_round?
          @current_play = []
          @current_pile = []
          @current_skip_counter = 0
        end

        @current_user = next_user
      end

      private

      def end_game?
        false
      end

      def end_round?
        @current_skip_counter == @users.count - 1
      end

      def next_user
        unless defined?(@current_user_index)
          @current_user_index = 0
          return @users.first
        end

        @current_user_index = (@current_user_index + 1) % @users.count
        @current_user = @users[@current_user_index]
      end

      def build_users(teams)
        users = []

        USER_NAMES.each_with_index do |name, i|
          team = @teams[i % @teams.size]
          users << User.new(name, team: team)
        end

        users
      end
    end
  end
end

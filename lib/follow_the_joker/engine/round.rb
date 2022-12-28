# frozen_string_literal: true

require_relative 'current'

module FollowTheJoker
  module Engine
    class Round
      # each game composes of multiple rounds

      attr_reader :game, :current

      def initialize(game, priority_card:)
        @game = game

        @users = game.users
        deck = Deck.build_with(@users.count)
        deck.cards.shuffle!(**shuffle_configuration)
        deck.each_user(@users) do |user, cards|
          user.hand_cards!(cards)
          user.current_card = priority_card
        end

        @finished = false
        @current = Current.new(self)
      end

      def turn(user, action:, **kwargs)
        raise RoundAlreadyFinishedError if finished?

        case action
        when :play
          play(user, cards: [*kwargs.delete(:cards)])
        when :skip
          skip(user)
        else
          raise "unknown action: #{action}"
        end

        self.current.next
      end

      def finished?
        @users.reject(&:finished?).map(&:team).uniq.size == 1
      end

      private

      def play(user, cards:)
        move = Move.new(@current.last_played, cards)
        move.valid?

        @current.record(move, user: user)
        user.played!(cards)
        @current.reset_skip_counter

        if user.finished?
          @current.flush!
          user.dragon_head! if dragon_head?(user)

          if finished?
            @users.reject(&:finished?).each(&:lost!)
            @game.round_finished!
          end
        end
      end

      def dragon_head?(user)
        other_users(user).all?(&:cards)
      end

      def other_users(user)
        @users - [user]
      end

      def skip(user)
        if @current.first_round?
          binding.pry
          raise CannotSkipError
        else
          @current.skip
        end

        @current.record_skip(user: user)
      end

      def shuffle_configuration
        configuration = game.configuration
        shuffle_seed = configuration[:shuffle_seed]

        return {} unless shuffle_seed

        { random: Random.new(shuffle_seed) }
      end
    end
  end
end

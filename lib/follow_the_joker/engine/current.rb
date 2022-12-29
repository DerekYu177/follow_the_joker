# frozen_string_literal: true

module FollowTheJoker
  module Engine
    class Current
      attr_reader :pile, :plays

      def initialize(round)
        @pile = []
        @plays = []
        @users = round.game.users
        @skip_counter = 0
        @previous_plays = []
      end

      def user
        @user_index ||= 0
        @users[@user_index]
      end

      def next
        @user_index ||= 0
        @user_index = (@user_index + 1) % @users.count

        self.next if user.finished?
      end

      def reset_skip_counter
        @skip_counter = 0
      end

      def skip
        @skip_counter += 1

        flush! if @skip_counter == @users.reject(&:finished?).count - 1
      end

      def record(move, user:)
        @pile << move.cards.dup
        @plays << move.record_with(user)
      end

      def record_skip(user:)
        @plays << "#{user} skipped their turn."
      end

      def last_played
        @pile.last.to_a
      end

      def first_move?
        @pile.empty?
      end

      def flush!
        reset_skip_counter
        @previous_plays << @plays
        @plays = []
        @pile = []
      end
    end
  end
end

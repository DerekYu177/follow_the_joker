# frozen_string_literal: true

module FollowTheJoker
  module Engine
    class Team
      attr_reader :name
      attr_accessor :users, :score

      def initialize(name, score: 0)
        @name = name
        @users = []
      end

      def join!(user)
        @users << user
      end
    end
  end
end

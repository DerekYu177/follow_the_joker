# frozen_string_literal: true

module FollowTheJoker
  module Engine
    class Team
      attr_reader :name
      attr_accessor :users, :priority_card, :dragon_head, :jail

      def initialize(name, priority_card: 2, initiative: false)
        @name = name
        @users = []
        @dragon_head = nil
        @jail = []
        @priority_card = priority_card
        @initiative = initiative
      end

      def dragon_head?
        !!@dragon_head
      end

      def join!(user)
        @users << user
      end
    end
  end
end

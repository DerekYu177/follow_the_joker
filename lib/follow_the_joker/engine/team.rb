# frozen_string_literal: true

module FollowTheJoker
  module Engine
    class Team
      attr_reader :name
      attr_accessor :users, :priority_card, :dragon_head, :jail, :initiative

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

      def round_finished!
        if dragon_head?
          score = @users.count - @jail.count

          score -= 1 if @initiative == false

          @initiative = true
          @priority_card += score
        else
          @initiative = false
        end
      end

      def reset!
        @jail = []
        @dragon_head = nil
      end
    end
  end
end

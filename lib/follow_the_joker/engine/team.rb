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

          if @initiative == false
            score -= 1
          end

          @initiative = true
          @priority_card += score
        else
          @initiative = false
        end
      end
    end
  end
end

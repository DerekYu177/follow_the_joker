# frozen_string_literal: true

require 'pry'
require 'pry-byebug'
require_relative '../engine'
require_relative '../engine/game'
require_relative 'card'
require_relative 'user'

module FollowTheJoker
  module CLI
    class Game < Engine::Game
      def initialize(**configuration)
        if configuration[:cards_for_users].any?
          configuration[:cards_for_users] = configuration[:cards_for_users].map do |shorthands|
            shorthands.split(" ").map { |shorthand| CLI::Card.to_engine_card(shorthand) }
          end
        end

        super
      end

      def start!
        loop do
          puts
          puts "Current player: #{current_user}"
          puts available_commands

          input = gets.chomp.strip
          action, info = parse_action(input)

          turn(current_user, action: action, **info)

          break if @game_finished
        end

      puts "Thank you for playing!"
      rescue Interrupt
        puts
        puts "Exiting, thanks for playing!"
      end

      def round_finished!
        super
        puts "The winner is Team #{@last_round_winner.name} with members: #{@last_round_winner.users}"
        @game_finished = true
      end

      private

      def available_commands
        "Type '?' for your cards | " \
          "Type '*' to see cards played this round | " \
          "Type '...' to skip your turn | " \
          "Type the shorthand for your card to play it"
      end

      def parse_action(input)
        if input == "?"
          [:help, {}]
        elsif CLI::Card.all.include?(input) || input.include?(" ") # assume cards
          [:play, { cards: CLI::Card.find(input, user: current_user) }]
        elsif input == "*"
          [:pile, {}]
        elsif input == "..."
          [:skip, {}]
        elsif input == "debug"
          [:debug, {}]
        else
          [input.to_sym, {}]
        end
      end

      def turn(user, action:, **kwargs)
        case action
        when :help
          puts
          puts "#{user.inspect}"
          puts "#{CLI::User.new(user).hand}"
          return
        when :pile
          puts
          if round.current.first_move?
            puts "You're the first to play this round!"
          else
            puts "Most recent first:"
            puts round.current.plays.reverse
          end

          return
        when :play, :skip
          begin
            super
          rescue FollowTheJoker::Engine::EngineError => e
            puts "**ERROR** #{e.message.to_s}"
            return
          end
        when :debug
          binding.pry
          # random statement here
          puts
        else
          puts "unknown action: #{action}"
          return
        end
      end

      def end_round?
        super.tap do |result|
          puts "No one challenged you! You may go again" if result
        end
      end
    end
  end
end

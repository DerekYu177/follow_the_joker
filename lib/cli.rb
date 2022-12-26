# frozen_string_literal: true

require 'pry'
require_relative 'engine'
require_relative 'engine/game'

module FollowTheJoker
  class Cli < Engine::Game
    def start!
      loop do
        puts
        puts "Current player: #{current_user}"
        puts available_commands

        input = gets.chomp
        action, info = parse_action(input)

        play(current_user, action: action, **info)
      end
    rescue Interrupt
      puts
      puts "Exiting, thanks for playing!"
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
      elsif input.include?(" ") || input.include?("-") # assume cards
        [:play, { cards: find_cards(input) }]
      elsif input == "*"
        [:pile, {}]
      elsif input == "..."
        [:skip, {}]
      else
        [input.to_sym, {}]
      end
    end

    def play(user, action:, **kwargs)
      case action
      when :help
        puts
        puts "#{user.inspect}"
        puts "#{user.hand}"
        return
      when :pile
        puts
        if current_pile.empty?
          puts "You're the first to play this round!"
        else
          puts "Most recent first:"
          puts current_play.reverse
        end

        return
      when :play, :skip
        begin
          super
        rescue FollowTheJoker::Engine::EngineError => e
          puts "**ERROR** #{e.message.to_s}"
          return
        end
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

    def find_cards(input)
      # input takes the rank-suit
      # i.e. Ace of Spades = A-S
      # ranks = [2, 3, 4, 5, 6, 7, 8, 9, 10, J, Q, K, A]
      # suits = [Diamonds = d, Clubs = c, Hearts = h, Spades = s)]
      # for Jokers, theres !, and !*, for little joker and big joker respectively

      input.split.map do |command|
        rank_shorthand, suit_shorthand = command.split("-")

        suit = Engine::Card::SUIT_SHORTHANDS[suit_shorthand]
        rank = Engine::Card.expand_rank_shorthand(rank_shorthand)

        current_user.cards.find { |card| card.original_rank == rank && card.suit == suit }
      end
    end
  end
end

FollowTheJoker::Cli.new.start!

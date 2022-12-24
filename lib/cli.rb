# frozen_string_literal: true

require 'pry'
require_relative 'engine'
require_relative 'engine/game'

module FollowTheJoker
  class Cli
    def initialize
      @game = Engine::Game.new
    end

    def start!
      while true do
        @game.users.each { |user| complete_turn!(user) }
      end
    rescue Interrupt
      puts
      puts "Exiting, thanks for playing!"
    end

    private

    def complete_turn!(user)
      while true do
        puts "#{user.inspect}'s turn"
        puts "Type ? for help"

        input = gets.chomp

        if input == "?"
          puts "#{user.inspect}"
          puts "#{user.hand}"
        elsif input == "skip"
          break
        elsif input == "pile"
          puts @game.pile.current_play
        else # assume valid move?
          cards = parse(input, user.cards)
          begin
            user.play!(cards)
            break
          rescue Engine::Pile::HandError => e
            puts e.class.name
          end
        end
      end
    end

    def parse(input, cards)
      # input takes the rank-suit
      # i.e. Ace of Spades = A-S
      # ranks = [2, 3, 4, 5, 6, 7, 8, 9, 10, J, Q, K, A]
      # suits = [Diamonds = d, Clubs = c, Hearts = h, Spades = s)]
      # for Jokers, theres !, and !*, for little joker and big joker respectively

      input.split.map do |command|
        rank_shorthand, suit_shorthand = command.split("-")

        suit = Engine::Card::SUIT_SHORTHANDS[suit_shorthand]
        rank = Engine::Card.expand_rank_shorthand(rank_shorthand)

        cards.find { |card| card.original_rank == rank && card.suit == suit }
      end
    end
  end
end

FollowTheJoker::Cli.new.start!

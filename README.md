# Follow the Joker

A game engine with a separate CLI frontend for the popular chinese game 大怪路子。

## Rules
The game centers around two opposing three-person teams racing to score more than five points.
Points are influenced by two mechanisms: becoming the Dragon's Head, which is given to the player who discards their cards first, and becoming Locked Up, which is given to players who are unable to discard all of their cards before the opposing team.
A team may simulataneously be able to become the Dragon's Head but also have the remainder of their team be locked up.
A team that has the Dragon's Head will automatically gain the iniative for the next round.
The initiative means that the player can go first.
When a team has both the Dragon's Head and is able to lock up the opposing team, they can gain points.
The score is incremented by the number of people on the opposing team that are locked up.
If one team has simultaneously the Dragon's Head and locks up the entire opposing team, then their score goes from two to five.

## Moves
The game is turn-based round-robin style.
Starting clockwise, each player can either play cards or skip their turn.
Cards must be greater in value to the cards that were played before.
If everyone skips their turn, then the player who played the highest card is able to play again.
Valid moves are single cards, pairs, threes, or five cards.
Single cards, pairs, and sets of three must all be of the same rank.
There are many variations of five card hands, with different relative ranks.

### Five card ranks (from highest to lowest)
1. _Five of a kind_: All five cards must be the same rank
2. _Straight Flush_: All five cards must be consecutive and of the same suit. There is no wrap around, but Ace's may be used either as rank 1 or rank 14.
3. _Four plus one_: Four cards of the same rank coupled with any single card.
4. _Three plus two_: Three cards of the same rank couple with any pair.
5. _Straight_: Five cards of consecutive rank.
6. _Flush_: All five cards of the same suit.

Between the five card ranks mentioned above, the highest rank of the hand dictates the rank of the set.
i.e. 4 Aces with one 2 beats out 4 Kings with one 5.

For Straight Flush, Flush, and Straight, the highest individual card dictates the rank of the set.
i.e. 2, 3, 4, 5, 6 loses to 5, 6, 7, 8, 9.

# Engine
The `FollowTheJoker::Engine::Game` is the primary entry point for running the game.
The game instance creates two teams and the round.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add follow_the_joker

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install follow_the_joker

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the FollowTheJoker project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/DerekYu177/follow_the_joker/blob/master/CODE_OF_CONDUCT.md).

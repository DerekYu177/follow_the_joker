# frozen_string_literal: true

require 'spec_helper'

RSpec.describe(FollowTheJoker::Engine::Move) do
  describe 'with one joker' do
    let(:previous) { [] }
    subject { described_class.new(previous, cards) }

    context 'two cards' do
      let(:cards) do
        [
          build(:card, :lJ),
          build(:card, :'5-s'),
        ]
      end

      it { is_expected.to(be_valid) }

      context 'when previous is higher' do
        let(:previous) do
          [
            build(:card, :'6-s'),
            build(:card, :'6-s'),
          ]
        end

        it { expect { subject.valid? }.to(raise_error(FollowTheJoker::Engine::GreaterCardsRankRequiredError)) }
      end

      context 'when previous is lower' do
        let(:previous) do
          [
            build(:card, :'3-s'),
            build(:card, :'3-h'),
          ]
        end

        it { is_expected.to(be_valid) }
      end
    end
  end
end

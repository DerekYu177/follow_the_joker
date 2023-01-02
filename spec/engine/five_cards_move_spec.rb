# frozen_string_literal: true

require 'spec_helper'

RSpec.describe(FollowTheJoker::Engine::FiveCardsMove) do
  subject do
    described_class.new(cards)
  end

  describe '#flush?' do
    let(:cards) do
      [
        build(:card, rank: 2),
        build(:card, rank: 5),
        build(:card, rank: 8),
        build(:card, rank: 9),
        build(:card, rank: 3),
      ]
    end

    it { is_expected.to(be_a_flush) }
    it { is_expected.to(be_valid) }
    it { expect(subject.value).to(eq([described_class::FLUSH, 9])) }
  end

  describe '#straight?' do
    let(:cards) do
      [
        build(:card, '2-s'),
        build(:card, '5-h'),
        build(:card, '6-d'),
        build(:card, '4-c'),
        build(:card, '3-s'),
      ]
    end

    it { is_expected.to(be_a_straight) }
    it { is_expected.to(be_valid) }
    it { expect(subject.value).to(eq([described_class::STRAIGHT, 6])) }

    context 'when the number of jokers' do
      context 'is one' do
        let(:cards) do
          [
            build(:card, '2-s'),
            build(:card, '5-h'),
            build(:card, '6-d'),
            build(:card, '4-c'),
            build(:card, :lJ),
          ]
        end

        it { is_expected.to(be_a_straight) }
        it { is_expected.to(be_valid) }
        it { expect(subject.value).to(eq([described_class::STRAIGHT, 6])) }
      end

      context 'is two' do
        let(:cards) do
          [
            build(:card, '2-s'),
            build(:card, '5-h'),
            build(:card, '6-d'),
            build(:card, :bJ),
            build(:card, :lJ),
          ]
        end

        it { is_expected.to(be_a_straight) }
        it { is_expected.to(be_valid) }
        it { expect(subject.value).to(eq([described_class::STRAIGHT, 6])) }
      end
    end
  end

  describe '#three_plus_two?' do
    let(:cards) do
      [
        build(:card, rank: 2),
        build(:card, rank: 2),
        build(:card, rank: 7),
        build(:card, rank: 7),
        build(:card, rank: 7),
      ]
    end

    it { is_expected.to(be_a_three_plus_two) }
    it { is_expected.to(be_valid) }
    it { expect(subject.value).to(eq([described_class::THREE_PLUS_TWO, 7])) }

    context 'when the number of jokers' do
      context 'is one' do
        let(:cards) do
          [
            build(:card, rank: 2),
            build(:card, rank: 2),
            build(:card, :bJ),
            build(:card, rank: 7),
            build(:card, rank: 7),
          ]
        end

        it { is_expected.to(be_a_three_plus_two) }
        it { is_expected.to(be_valid) }
        it { expect(subject.value).to(eq([described_class::THREE_PLUS_TWO, 7])) }
      end
    end
  end

  describe '#four_plus_one?' do
    let(:cards) do
      [
        build(:card, rank: 2),
        build(:card, rank: 9),
        build(:card, rank: 9),
        build(:card, rank: 9),
        build(:card, rank: 9),
      ]
    end

    it { is_expected.to(be_a_four_plus_one) }
    it { is_expected.to(be_valid) }
    it { expect(subject.value).to(eq([described_class::FOUR_PLUS_ONE, 9])) }

    describe 'when the number of jokers' do
      context 'is one' do
        let(:cards) do
          [
            build(:card, rank: 2),
            build(:card, :lJ),
            build(:card, rank: 9),
            build(:card, rank: 9),
            build(:card, rank: 9),
          ]
        end

        it { is_expected.to(be_a_four_plus_one) }
        it { is_expected.to(be_valid) }
        it { expect(subject.value).to(eq([described_class::FOUR_PLUS_ONE, 9])) }
      end

      context 'is three' do
        let(:cards) do
          [
            build(:card, rank: 2),
            build(:card, rank: 10),
            build(:card, :lJ),
            build(:card, :bJ),
            build(:card, :lJ),
          ]
        end

        it { is_expected.to(be_a_four_plus_one) }
        it { is_expected.to(be_valid) }
        it { expect(subject.value).to(eq([described_class::FOUR_PLUS_ONE, 10])) }
      end
    end
  end

  describe '#straight_flush?' do
    let(:cards) do
      [
        build(:card, rank: 9),
        build(:card, rank: 10),
        build(:card, rank: 11),
        build(:card, rank: 12),
        build(:card, rank: 13),
      ]
    end

    it { is_expected.to(be_a_straight_flush) }
    it { is_expected.to(be_valid) }
    it { expect(subject.value).to(eq([described_class::STRAIGHT_FLUSH, 13])) }

    context 'when the number of jokers' do
      context 'is one' do
        context 'in the middle of the straight' do
          let(:cards) do
            [
              build(:card, rank: 9),
              build(:card, rank: 10),
              build(:card, :lJ),
              build(:card, rank: 12),
              build(:card, rank: 13),
            ]
          end

          it { is_expected.to(be_a_straight_flush) }
          it { is_expected.to(be_valid) }
          it { expect(subject.value).to(eq([described_class::STRAIGHT_FLUSH, 13])) }
        end

        context 'at the end of the straight' do
          let(:cards) do
            [
              build(:card, rank: 10),
              build(:card, rank: 11),
              build(:card, rank: 12),
              build(:card, rank: 13),
              build(:card, :lJ),
            ]
          end

          it { is_expected.to(be_a_straight_flush) }
          it { is_expected.to(be_valid) }
          it { expect(subject.value).to(eq([described_class::STRAIGHT_FLUSH, 14])) }
        end
      end

      context 'is two' do
        let(:cards) do
          [
            build(:card, rank: 9),
            build(:card, rank: 10),
            build(:card, :bJ),
            build(:card, rank: 12),
            build(:card, :lJ),
          ]
        end

        it { is_expected.to(be_a_straight_flush) }
        it { is_expected.to(be_valid) }
        it { expect(subject.value).to(eq([described_class::STRAIGHT_FLUSH, 13])) }
      end
    end
  end

  describe '#five_of_a_kind?' do
    let(:cards) do
      [
        build(:card, rank: 2),
        build(:card, rank: 2),
        build(:card, rank: 2),
        build(:card, rank: 2),
        build(:card, rank: 2),
      ]
    end

    it { is_expected.to(be_a_five_of_a_kind) }
    it { is_expected.to(be_valid) }
    it { expect(subject.value).to(eq([described_class::FIVE_OF_A_KIND, 2])) }

    context 'when the number of jokers' do
      context 'is one' do
        let(:cards) do
          [
            build(:card, rank: 2),
            build(:card, rank: 2),
            build(:card, rank: 2),
            build(:card, rank: 2),
            build(:card, :lJ),
          ]
        end

        it { is_expected.to(be_a_five_of_a_kind) }
        it { is_expected.to(be_valid) }
        it { expect(subject.value).to(eq([described_class::FIVE_OF_A_KIND, 2])) }
      end

      context 'is two' do
        let(:cards) do
          [
            build(:card, rank: 2),
            build(:card, rank: 2),
            build(:card, rank: 2),
            build(:card, :lJ),
            build(:card, :lJ),
          ]
        end

        it { is_expected.to(be_a_five_of_a_kind) }
        it { is_expected.to(be_valid) }
        it { expect(subject.value).to(eq([described_class::FIVE_OF_A_KIND, 2])) }
      end

      context 'is three' do
        let(:cards) do
          [
            build(:card, rank: 2),
            build(:card, rank: 2),
            build(:card, :bJ),
            build(:card, :lJ),
            build(:card, :lJ),
          ]
        end

        it { is_expected.to(be_a_five_of_a_kind) }
        it { is_expected.to(be_valid) }
        it { expect(subject.value).to(eq([described_class::FIVE_OF_A_KIND, 2])) }
      end

      context 'is four' do
        let(:cards) do
          [
            build(:card, rank: 2),
            build(:card, :bJ),
            build(:card, :bJ),
            build(:card, :lJ),
            build(:card, :lJ),
          ]
        end

        it { is_expected.to(be_a_five_of_a_kind) }
        it { is_expected.to(be_valid) }
        it { expect(subject.value).to(eq([described_class::FIVE_OF_A_KIND, 2])) }
      end

      context 'is five' do
        let(:cards) do
          [
            build(:card, :lJ),
            build(:card, :bJ),
            build(:card, :bJ),
            build(:card, :lJ),
            build(:card, :lJ),
          ]
        end

        it { is_expected.to(be_a_five_of_a_kind) }
        it { is_expected.to(be_valid) }

        it do
          expect(subject.value)
            .to(eq([described_class::FIVE_OF_A_KIND, FollowTheJoker::Engine::Card::LITTLE_JOKER]))
        end
      end
    end
  end
end

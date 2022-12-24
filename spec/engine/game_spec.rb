# frozen_string_literal: true

require 'spec_helper'

RSpec.describe(FollowTheJoker::Engine::Game) do
  subject { described_class.new }

  it 'starts with the correct number of users' do
    expect(subject.users.size).to(eq(6))
  end

  it 'splits the users into two teams' do
    teams = subject.users.partition { |u| u.team.name == described_class::TEAM_NAMES.first }
    expect(teams.size).to(eq(2))

    teams.each do |team|
      expect(team.size).to(eq(3))
    end
  end
end

require 'spec_helper'

describe Competition do
  let!(:now) { DateTime.now }
  let!(:competition) { Competition.create!(name: "Test", start_time: now, duration: 180) }

  it "has the proper end time" do
    expect(competition.end_time).to eq(now + 180.minutes)
  end
end

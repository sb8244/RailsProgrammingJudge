require 'spec_helper'

describe CompetitionsController do

  let!(:user) { User.create!(email: "steve@cool.com", password: "password") }
  let(:competition) { Competition.create!(name: "competition", start_time: Time.now, duration: 180) }

  before(:each) { sign_in(user) }

  describe "POST join" do
    it "adds a competition to a user" do
      expect {
        post :join, id: competition.id
        user.reload
      }.to change{ user.competitions.count }.by(1)
    end

    it "doesn't repeat competitions" do
      user.competitions << competition
      user.save!
      expect {
        post :join, id: competition.id
        user.reload
      }.not_to change{ user.competitions.count }
    end
  end
end

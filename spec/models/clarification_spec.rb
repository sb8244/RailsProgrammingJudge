require "spec_helper"

describe Clarification do
  let!(:user) { User.create!(email: "steve@cool.com", password: "password") }
  let!(:competition) { Competition.create!(name: "competition", start_time: Time.now, duration: 180) }
  let!(:problem) { competition.problems.create!(name: "problem", html: "stuff", input_example: "input", output_example: "output") }
  let!(:clarification) { Clarification.new(user: user, problem: problem, question: "Test question") }

  before(:each) do
    user.competitions << competition
  end

  context "without answer" do
    it "doesn't send pusher" do
      expect{
        clarification.save
      }.not_to change{ PusherWorker.jobs.size }
    end
  end

  context "with answer" do
    it "sends a pusher for the user" do
      clarification.answer = "Test answer"
      expect{
        clarification.save
      }.to change{ PusherWorker.jobs.size }.by(1)
    end

    it "sends a pusher to multiple users" do
      users = []
      5.times do |i|
        users << User.create!(email: "steve#{i}@cool.com", password: "password")
      end
      users.each do |user|
        user.competitions << competition
      end
      user.competitions.delete(competition) # remove our original user to have a user not in the competition

      clarification.answer = "Test answer"
      expect {
        clarification.save
      }.to change{ PusherWorker.jobs.size }.by(users.size)
    end
  end
end

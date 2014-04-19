require 'spec_helper'

describe SubmissionsController do
  let!(:user) { User.create!(email: "steve@cool.com", password: "password") }
  let!(:competition) { Competition.create!(name: "competition", start_time: Time.now, duration: 180) }
  let!(:problem) { competition.problems.create!(name: "problem", html: "stuff", input_example: "input", output_example: "output") }
  before(:each) { sign_in(user) }

  describe 'POST :create' do
    it "adds a new submission" do
      expect {
        post :create, problem_id: problem, competition_id: competition, submission: { language: "java", code: "code" }
      }.to change{ Submission.count }.by(1)
    end

    it "sets the user" do
      post :create, problem_id: problem, competition_id: competition, submission: { language: "java", code: "code" }
      expect(Submission.last.user).to eq(user)
    end

    it "queues a background job" do
      expect {
        post :create, problem_id: problem, competition_id: competition, submission: { language: "java", code: "code" }
      }.to change{ SubmissionWorker.jobs.size }.by(1)
    end

    it "doesn't allow submission for expired competition" do
      competition.update_attributes!(start_time: Time.now + 3.days)
      expect {
        post :create, problem_id: problem, competition_id: competition, submission: { language: "java", code: "code" }
      }.not_to change{ Submission.count }
    end
  end
end

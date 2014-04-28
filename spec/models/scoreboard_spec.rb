require 'spec_helper'

describe Scoreboard do
  let!(:now) { DateTime.now }
  let!(:user) { User.create!(email: "steve@cool.com", password: "password") }
  let!(:user2) { User.create!(email: "steve2@cool.com", password: "password") }
  let!(:competition) { Competition.create!(name: "Test", start_time: now, duration: 180) }

  subject { Scoreboard.new(competition) }

  before do
    competition.users << [user, user2]
  end
  
  it "doesn't count not_started" do
      user.submissions.create!(code: "doesn't matter", language: "java", status: "not_started", competition: competition, created_at: now + 5.minutes, problem_id: 1)
      scores = subject.get_scores
      expect(scores[1][:failures]).to eq({})
      expect(scores[1][:successes]).to eq({})
      expect(scores[1][:score]).to eq(0)
  end

  context "with no failures" do
    it "single success" do
      user.submissions.create!(code: "doesn't matter", language: "java", status: "success", competition: competition, created_at: now + 5.minutes, problem_id: 1)
      scores = subject.get_scores
      expect(scores[1][:failures]).to eq({})
      expect(scores[1][:successes]).to eq({1 => 5})
      expect(scores[1][:score]).to eq(5)
    end

    it "many success on same problem only uses first success" do
      user.submissions.create!(code: "doesn't matter", language: "java", status: "success", competition: competition, created_at: now + 5.minutes, problem_id: 1)
      user.submissions.create!(code: "doesn't matter", language: "java", status: "success", competition: competition, created_at: now + 10.minutes, problem_id: 1)
      scores = subject.get_scores
      expect(scores[1][:failures]).to eq({})
      expect(scores[1][:successes]).to eq({1 => 5})
      expect(scores[1][:score]).to eq(5)
    end

    it "many success on many problems uses all success" do
      user.submissions.create!(code: "doesn't matter", language: "java", status: "success", competition: competition, created_at: now + 5.minutes, problem_id: 1)
      user.submissions.create!(code: "doesn't matter", language: "java", status: "success", competition: competition, created_at: now + 10.minutes, problem_id: 2)
      scores = subject.get_scores
      expect(scores[1][:failures]).to eq({})
      expect(scores[1][:successes]).to eq({1 => 5, 2 => 10})
      expect(scores[1][:score]).to eq(15)
    end
  end

  context "with failures" do
    it "one failure" do
      user.submissions.create!(code: "doesn't matter", language: "java", status: "wrong_answer", competition: competition, created_at: now + 5.minutes, problem_id: 1)
      scores = subject.get_scores
      expect(scores[1][:failures]).to eq({1 => 1})
      expect(scores[1][:successes]).to eq({})
      expect(scores[1][:score]).to eq(20)
    end

    it "many failures" do
      user.submissions.create!(code: "doesn't matter", language: "java", status: "wrong_answer", competition: competition, created_at: now + 5.minutes, problem_id: 1)
      user.submissions.create!(code: "doesn't matter", language: "java", status: "compile_error", competition: competition, created_at: now + 50.minutes, problem_id: 1)
      scores = subject.get_scores
      expect(scores[1][:failures]).to eq({1 => 2})
      expect(scores[1][:successes]).to eq({})
      expect(scores[1][:score]).to eq(40)
    end

    it "many problems many failures" do
      user.submissions.create!(code: "doesn't matter", language: "java", status: "wrong_answer", competition: competition, created_at: now + 5.minutes, problem_id: 1)
      user.submissions.create!(code: "doesn't matter", language: "java", status: "compile_error", competition: competition, created_at: now + 50.minutes, problem_id: 1)
      user.submissions.create!(code: "doesn't matter", language: "java", status: "wrong_answer", competition: competition, created_at: now + 5.minutes, problem_id: 2)
      scores = subject.get_scores
      expect(scores[1][:failures]).to eq({1 => 2, 2 => 1})
      expect(scores[1][:successes]).to eq({})
      expect(scores[1][:score]).to eq(60)
    end
  end

  context "with failures and success" do
    it "doesn't count failures after success" do
      user.submissions.create!(code: "doesn't matter", language: "java", status: "wrong_answer", competition: competition, created_at: now + 5.minutes, problem_id: 1)
      user.submissions.create!(code: "doesn't matter", language: "java", status: "compile_error", competition: competition, created_at: now + 50.minutes, problem_id: 1)
      user.submissions.create!(code: "doesn't matter", language: "java", status: "success", competition: competition, created_at: now + 25.minutes, problem_id: 1)
      scores = subject.get_scores
      expect(scores[1][:failures]).to eq({1 => 1})
      expect(scores[1][:successes]).to eq({1 => 25})
      expect(scores[1][:score]).to eq(20 + 25)
    end
  end

  it "scores many users" do
      user.submissions.create!(code: "doesn't matter", language: "java", status: "wrong_answer", competition: competition, created_at: now + 5.minutes, problem_id: 1)
      user2.submissions.create!(code: "doesn't matter", language: "java", status: "compile_error", competition: competition, created_at: now + 50.minutes, problem_id: 1)
      user2.submissions.create!(code: "doesn't matter", language: "java", status: "success", competition: competition, created_at: now + 5.minutes, problem_id: 2)
      scores = subject.get_scores
      expect(scores[1][:failures]).to eq({1 => 1})
      expect(scores[1][:successes]).to eq({})
      expect(scores[1][:score]).to eq(20)
      expect(scores[2][:failures]).to eq({1 => 1})
      expect(scores[2][:successes]).to eq({2 => 5})
      expect(scores[2][:score]).to eq(20 + 5)
  end
end

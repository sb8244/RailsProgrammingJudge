require 'spec_helper'

describe SubmissionWorker do

  let!(:user) { User.create!(email: "steve@cool.com", password: "password") }
  let!(:competition) { Competition.create!(name: "competition", start_time: Time.now, duration: 180) }
  let!(:problem) { competition.problems.create!(name: "problem", html: "stuff", input_example: "input", output_example: "output") }
  let!(:submission) { problem.submissions.create(language: 'java', code: "contents", competition: competition) }

  context "when competition is ended" do
    before(:each) { competition.update_attributes!(start_time: Time.now + 3.days) }
    it "still processes" do
      JavaMind.any_instance.should_receive(:compile!)
      JavaMind.any_instance.should_receive(:run!).and_return("1")
      problem.test_cases.create(input: "1", output: "1")
      expect {
        SubmissionWorker.new.perform(submission.id)
        submission.reload
      }.to change{ submission.status }.to('success')
    end
  end

  context "when java language with real JavaMind" do
    let!(:submission) {
      contents = File.read('spec/java_source/Solution.java')
      problem.submissions.create(language: 'java', code: contents, competition: competition)
    }

    it "sets correct with a correct input/output" do
      problem.test_cases.create(input: "1", output: "1\noutput")
      expect {
        SubmissionWorker.new.perform(submission.id)
        submission.reload
      }.to change{ submission.status }.to('success')
    end

    it "doesn't shit up my tmp space" do
      expect{
        SubmissionWorker.new.perform(submission.id)
      }.not_to change{ Dir['tmp/*'].count }
    end

    it "catches wrong answer" do
      problem.test_cases.create(input: "1", output: "wrong")
      expect {
        SubmissionWorker.new.perform(submission.id)
        submission.reload
      }.to change{ submission.status }.to('wrong_answer')
    end

    context "when bad compilation" do
      let!(:submission) {
        contents = File.read('spec/java_source_error/Solution.java')
        problem.submissions.create(language: 'java', code: contents, competition: competition)
      }
      it "catches compile errors" do
        problem.test_cases.create(input: "1", output: "wrong")
        expect {
          SubmissionWorker.new.perform(submission.id)
          submission.reload
        }.to change{ submission.status }.to('compile_error')
      end
    end
  end

end
require 'spec_helper'

describe SubmissionWorker do
  let!(:user) { User.create!(email: "steve@cool.com", password: "password") }
  let!(:competition) { Competition.create!(name: "competition", start_time: Time.now, duration: 180) }
  let!(:problem) { competition.problems.create!(name: "problem", html: "stuff", input_example: "input", output_example: "output") }
  let!(:submission) { user.submissions.create!(language: 'java', code: "contents", competition: competition, problem: problem) }

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
    before(:each) {
      contents = File.read('spec/java_source/Solution.java')
      submission.update_attributes!(code: contents)
    }

    it "doesn't shit up my tmp space" do
      expect{
        SubmissionWorker.new.perform(submission.id)
      }.not_to change{ Dir['tmp/*'].count }
    end

    context "when answer is right" do
      before(:each) { problem.test_cases.create(input: "1", output: "1\noutput\n") }
      it "sets correct with a correct input/output" do
        expect {
          SubmissionWorker.new.perform(submission.id)
          submission.reload
        }.to change{ submission.status }.to('success')
      end

      it "sets correct test case results" do
        SubmissionWorker.new.perform(submission.id)
        expect(TestCaseResult.count).to eq(1)
        expect(TestCaseResult.last.status).to eq("success")
        expect(TestCaseResult.last.output).to eq(problem.test_cases.first.output)
      end
    end

    context "when answer is wrong" do
      before(:each) { problem.test_cases.create(input: "1", output: "wrong") }
      it "has correct status" do
        expect {
          SubmissionWorker.new.perform(submission.id)
          submission.reload
        }.to change{ submission.status }.to('wrong_answer')
      end

      it "sets correct test case results" do
        SubmissionWorker.new.perform(submission.id)
        expect(TestCaseResult.count).to eq(1)
        expect(TestCaseResult.last.status).to eq("wrong_answer")
      end
    end

    context "when bad compilation" do
      before(:each) {
        contents = File.read('spec/java_source_error/Solution.java')
        submission.update_attributes!(code: contents)
        problem.test_cases.create(input: "1", output: "wrong")
      }
      it "catches compile errors" do
        expect {
          SubmissionWorker.new.perform(submission.id)
          submission.reload
        }.to change{ submission.status }.to('compile_error')
      end
      it "has no test case results" do
        expect {
          SubmissionWorker.new.perform(submission.id)
        }.not_to change{ TestCaseResult.count }
      end
    end
  end
end

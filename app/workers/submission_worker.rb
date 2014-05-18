class SubmissionWorker
  include Sidekiq::Worker

  @dir = nil
  @mind = nil

  # Save the code to a special directory as CLASS_NAME.java or main.c
  # Execute the code using the input cases for the problem
  # Make sure (program)input-N == output-N
  # If all passes, good, else break immediately
  def perform(submission_id)
    @submission = Submission.find(submission_id)
    @problem = @submission.problem

    if @submission.language == "java"
      @submission.status = handle_java!
      clean!
    end

    if @submission.save
      PusherWorker.perform_async("user-#{@submission.user.id}", 'submission-update', { problem: @problem.name, id: @submission.id, status: @submission.status.to_s.humanize })
    end
  end

  private

  def clean!
    FileUtils.remove_dir(@dir)
  end

  def handle_java!
    # Create Solution.java
    @dir = "#{Rails.root}/tmp/#{SecureRandom.uuid}"
    Dir.mkdir(@dir)
    open("#{@dir}/Solution.java", 'wb') do |file|
      file.write @submission.code
    end

    @mind = JavaMind.new(@dir)

    begin
      @mind.compile!
    rescue CompileTimeError
      return :compile_error
    end

    final_status = :success

    @problem.test_cases.each do |test_case|
      if test_case.active?
        output = @mind.run!({input: test_case.input})
        status = Comparer.compare({output: output, expected: test_case.output})
        @submission.test_case_results.create!(output: output, status: status, test_case_id: test_case.id)
        if final_status == :success
          final_status = status
        end
      end
    end

    final_status
  end
end

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
      result = handle_java!
      clean!

      @submission.result = Result.create!(status: result)
      @submission.save!
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
    @problem.test_cases.each do |test_case|
      output = @mind.run!({input: test_case.input})
      status = Comparer.compare({output: output, expected: test_case.output})
      if status != :success
        return status
      end
    end

    :success
  end
end
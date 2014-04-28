class Scoreboard
  def initialize(competition)
    @scores = {}
    @competition = competition
    process_submissions
  end

  # Returns the scoreboard in the following format
  # { user_id: {
  #   failures: { id: count }, 
  #   successes: [p1.id, p2.id],
  #   score } 
  # }
  # Score is the sum of success minutes into the competition
  #  plus failures which are 20 minutes per failure.
  # Successes is the list of problem_ids which have been solved by this user
  # Failures is the hash c
  def get_scores
    @scores
  end

  def get_places
    raise StandardError.new("Not yet implemented")
  end

  private

  def process_submissions
    submissions = @competition.submissions.order("created_at ASC")

    @competition.users.each do |user|
      @scores[user.id] = { failures: {}, successes: {}, score: 0 }
    end

    submissions.each do |submission|
      next if @scores[submission.user_id][:successes].include?(submission.problem_id)

      if submission.status != "success" && submission.status != "not_started"
        @scores[submission.user_id][:failures].merge!({ submission.problem_id => 0 }) unless @scores[submission.user_id][:failures].key?(submission.problem_id)
        @scores[submission.user_id][:failures][submission.problem_id] += 1
        @scores[submission.user_id][:score] += 20
      elsif submission.status == "success"
        minutes_in = ((submission.created_at - @competition.start_time) / 60).floor
        @scores[submission.user_id][:successes].merge!({ submission.problem_id => minutes_in })
        @scores[submission.user_id][:score] += minutes_in
      end
    end
  end
end
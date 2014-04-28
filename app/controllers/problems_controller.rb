class ProblemsController < ApplicationController
  before_filter :authenticate_user!
  
  def show
    @problem = Problem.find(params[:id])
    @submission = Submission.new
    @submissions = current_user.submissions.where(problem: @problem).order("updated_at DESC").limit(3)
    @clarifications = @problem.clarifications.where("answer IS NOT NULL AND (user_id = ? OR global = ?)", current_user.id, true)
    @clarification = Clarification.new
  end
end

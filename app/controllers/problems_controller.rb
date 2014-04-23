class ProblemsController < ApplicationController
  before_filter :authenticate_user!
  
  def show
    @problem = Problem.find(params[:id])
    @submission = Submission.new
    @submissions = current_user.submissions.where(problem: @problem, competition: @problem.competition).order("updated_at DESC").limit(3)
  end
end

class ProblemsController < ApplicationController
  before_filter :authenticate_user!
  
  def show
    @problem = Problem.find(params[:id])
    @submission = Submission.new
    @submissions = Submission.where(problem: @problem, user: current_user).order("updated_at DESC").limit(3)
  end
end

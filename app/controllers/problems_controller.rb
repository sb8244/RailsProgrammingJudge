class ProblemsController < ApplicationController
  before_filter :authenticate_user!
  
  def show
    @problem = Problem.find(params[:id])
    @submission = Submission.new
  end
end

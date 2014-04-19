class ProblemsController < ApplicationController
  def show
    @problem = Problem.find(params[:id])
    @submission = Submission.new
  end
end

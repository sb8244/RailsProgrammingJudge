class ClarificationsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @problem = Problem.find(params[:problem_id])
    @clarification = Clarification.new(clarification_params)
    @clarification.user = current_user
    @clarification.problem = @problem
    if @clarification.save
      redirect_to @problem, notice: "Clarification submitted to judge"
    else
      redirect_to @problem, error: "Error asking for clarification"
    end
  end

  private

  def clarification_params
    params.require(:clarification).permit(:question)
  end
end

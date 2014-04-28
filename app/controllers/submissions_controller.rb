class SubmissionsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @submissions = current_user.submissions.order("updated_at DESC")
  end

  def show
    @submission = current_user.submissions.find(params[:id])
  end

  def create
    @problem = Problem.find(params[:problem_id])
    unless @problem.competition.running?
      return redirect_to @problem, error: "This competition has ended"
    end
    @submission = @problem.submissions.build(submission_params)
    @submission.user = current_user
    @submission.competition = @problem.competition

    if @submission.save
      SubmissionWorker.perform_in(2.seconds,@submission.id)
      redirect_to @problem, notice: "Submission Received"
    else
      redirect_to @problem, error: "Error occurred, please try again"
    end
  end

  private

  def submission_params
    params.require(:submission).permit(:language, :code)
  end
end

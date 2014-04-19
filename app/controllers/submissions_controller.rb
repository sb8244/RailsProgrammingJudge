class SubmissionsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @submissions = Submission.where(user: current_user).order("updated_at DESC")
  end

  def show
    @submission = Submission.where(user: current_user, id: params[:id])
  end

  def create
    @problem = Problem.find(params[:problem_id])
    unless @problem.competition.running?
      return redirect_to [@problem.competition, @problem], error: "This competition has ended"
    end
    @submission = @problem.submissions.create(submission_params)
    @submission.user = current_user

    if @submission.save
      SubmissionWorker.perform_async(@submission.id)
      redirect_to [@problem.competition, @problem], notice: "Submission Received"
    else
      redirect_to [@problem.competition, @problem], error: "Error occurred, please try again"
    end
  end

  private

  def submission_params
    params.require(:submission).permit(:language, :code)
  end
end

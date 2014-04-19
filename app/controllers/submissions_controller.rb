class SubmissionsController < ApplicationController
  def create
    @problem = Problem.find(params[:problem_id])
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

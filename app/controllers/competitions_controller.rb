class CompetitionsController < ApplicationController

  before_filter :authenticate_user!

  def index
    @competitions = Competition.all
    @active = @competitions.select { |c| c.running? }
  end

  def show
    @competition = Competition.find(params[:id])
    # @submissions = current_user.submissions.joins(:problem).where(problems: {competition_id: @competition}).order("updated_at DESC").limit(3)
  end

  def join
    @competition = Competition.find(params[:id])

    current_user.competitions << @competition unless current_user.competitions.exists?(@competition)
    current_user.save!

    redirect_to @competition, notice: "You have joined this competition."
  end
end

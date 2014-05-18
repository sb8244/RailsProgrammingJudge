class Clarification < ActiveRecord::Base
  belongs_to :problem
  belongs_to :user

  after_save :after_save

  def after_save
    unless self.answer.nil? || self.problem.competition.nil?
      self.problem.competition.users.each do |user|
        payload = { question: self.question, answer: self.answer, problem: self.problem.name }
        PusherWorker.perform_async("user-#{user.id}", 'clarification-answered', payload)
      end
    end
  end
end

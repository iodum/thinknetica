class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    midnight = Time.now.utc.midnight
    @questions = Question.where(created_at: (midnight - 1.day..midnight)).to_a

    unless @questions.empty?
      User.find_each do |user|
        DailyMailer.digest(user, @questions).deliver_later
      end
    end
  end
end

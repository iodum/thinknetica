class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    unless answer.question.blank?
      answer.question.subscriptions.find_each do |subscription|
        AnswerSubscriptionMailer.notify(subscription.user, answer).deliver_later
      end
    end
  end
end

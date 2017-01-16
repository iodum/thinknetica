class AnswerSubscriptionMailer < ApplicationMailer
  def notify(user, answer)
    @user = user
    @answer = answer
    mail(to: @user.email, subject: "New answer to #{answer.question.title}")
  end
end

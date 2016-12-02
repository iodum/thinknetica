class AnswersChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "question_#{data['question_id']}"
  end

  def unfollow
    stop_all_streams
  end
end

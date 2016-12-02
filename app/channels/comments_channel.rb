# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class CommentsChannel < ApplicationCable::Channel
    def follow(data)
      stream_from "comments_#{data['question_id']}"
    end

    def unfollow
      stop_all_streams
    end
end

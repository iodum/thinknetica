require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  include ActiveJob::TestHelper

  let(:job) { NewAnswerNotificationJob.perform_now(answer) }

  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }
  let(:subscriptions) { create_pair(:subscription, question: question) }

  it 'does not perform job' do
    question.subscriptions.each do |subscription|
      expect(AnswerSubscriptionMailer).to receive(:notify).with(subscription.user, answer).and_call_original
    end
    job
  end


end

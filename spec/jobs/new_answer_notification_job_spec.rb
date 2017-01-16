require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  include ActiveJob::TestHelper

  let(:job) { NewAnswerNotificationJob.perform_now(answer) }


  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }

  it 'does not perform job' do
    expect(AnswerSubscriptionMailer).to receive(:notify).with(question.user, answer).and_call_original
    job
  end

end

require 'rails_helper'

RSpec.describe Search, type: :model do

  describe '.search' do
    %w(question answer comment user).each do |resource|
      it "call search method for #{resource}s" do
        expect(resource.classify.constantize).to receive(:search).with('123')
        Search.search('123', resource)
      end
    end

    it 'should call global search' do
      expect(ThinkingSphinx).to receive(:search).with('123')
      Search.search('123', 'all')
    end

    it 'not valid value' do
      expect(ThinkingSphinx).to receive(:search).with('123')
      Search.search('123', 'not_valid_value')
    end
  end

end

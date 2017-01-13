shared_examples_for 'API Attachmentable' do
  context 'attachments' do
    it 'included in answer object' do
      expect(response.body).to have_json_size(1).at_path("#{path}/attachments")
    end

    %w(id created_at updated_at).each do |attr|
      it "contains #{attr}" do
        expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("#{path}/attachments/0/#{attr}")
      end
    end

    it 'contains url' do
      expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("#{path}/attachments/0/url")
    end
  end
end
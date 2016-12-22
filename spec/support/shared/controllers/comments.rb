shared_examples_for 'Controller Comments' do

  context 'with valid attributes' do
    it 'saves the new comment in the database' do
      expect { post :create, params: {comment: attributes_for(:comment), format: :js}.merge(params) }.to change(commentable.comments, :count).by(1)
    end

    it 'saves the new user\'s comment in the database' do
      expect { post :create, params: {comment: attributes_for(:comment), format: :js}.merge(params) }.to change(@user.comments, :count).by(1)
    end
  end

  context 'with invalid attributes' do
    it 'does not save the new answer in the database' do
      expect { post :create, params: {comment: attributes_for(:invalid_comment), format: :js}.merge(params) }.to_not change(Comment, :count)
    end
  end
end
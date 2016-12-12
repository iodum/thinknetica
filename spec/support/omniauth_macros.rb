module OmniauthMacros
  def mock_auth_facebook
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
                                                                    provider: 'facebook',
                                                                    uid: '123',
                                                                    info: {
                                                                      email: 'facebook-test@example.com',
                                                                    }
                                                                  })
  end

  def mock_auth_twitter
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
                                                                   provider: 'twitter',
                                                                   uid: '456',
                                                                   info: {}
                                                                 })
  end

end
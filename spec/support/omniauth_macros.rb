module OmniauthMacros

  def mock_auth_hash_vk
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new({
      provider: :vkontakte,
      uid: '6785686 ',
      info: {
        email: "test_shevtsovav@bk.ru"
      },
      credentials: {
        token: "test_token",
        secret: "test_secret"
      }
    })
  end

  def mock_auth_hash_github
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      provider: :github,
      uid: '777777 ',
      info: {
        email: nil
      },
      credentials: {
        token: "test_token",
        secret: "test_secret"
      }
    })
  end
end
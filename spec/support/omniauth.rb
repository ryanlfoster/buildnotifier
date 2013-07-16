module OmniAuthRspecMacros
  extend ActiveSupport::Concern

  module ClassMethods
    def login!(user = nil)
      before(:each) { login!(user) }
    end

    def logout!
      before(:each) { logout! }
    end
  end

  def login!(user = nil)
    user ||= FactoryGirl.create(:user, with_identity: true)
    user.add_role 'admin'
    session[:user_id] = user.id
    @user = user
  end

  def logout!
    session.delete :user_id
    @user = nil
  end

  def omniauth_mock_clear
    # clean all mock auth except :default
    OmniAuth.config.mock_auth.delete_if { |(k, v)| k != :default }
    OmniAuth.config.test_mode = false
  end

  def omniauth_mock(provider, mock)
    OmniAuth.config.add_mock(provider, mock)
    OmniAuth.config.test_mode = true
  end

  def omniauth_mock_for(provider)
    OmniAuth.mock_auth_for(provider)
  end

  def omniauth_mock_identity(user)
    omniauth_mock(:identity,
                  uid: user.email,
                  user_info: {
                    name: user.name,
                    email: user.email
                    })
  end
end

RSpec.configure do |config|
  config.include OmniAuthRspecMacros

  config.after(:each) { omniauth_mock_clear }
end

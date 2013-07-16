require 'spec_helper'

describe SessionsController do
  let(:user) { create(:user) }
  let(:identity) { Identity.find_by_email(user.email) }

  describe '#new' do
    it 'renders new' do
      get :new
      response.should render_template('new')
    end
  end

  describe '#failure' do
    it 'displays alert message' do
      get :failure
      flash[:alert].should include('Incorrect username or password.')
    end

    it 'redirects to login path' do
      get :failure
      response.should redirect_to(login_path)
    end
  end

  describe '#create' do
    before { request.env['omniauth.auth'] = omniauth_mock_identity(user) }

    it 'logs the user in' do
      User.should_receive(:find_or_create_by_auth).with(request.env['omniauth.auth']).and_return(user)

      post :create
      session[:user_id].should eq(user.id)
    end
  end

  describe '#destroy' do
    login!

    it 'clears all session' do
      request.session[:foo] = 'bar'
      delete :destroy
      session[:foo].should be_nil
      session[:user_id].should be_nil
    end
  end
end

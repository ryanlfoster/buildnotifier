require 'spec_helper'

describe UsersController do
  let(:user) { create(:user) }
  
  describe '#new' do
    it 'assigns a new identity by default' do
      get :new
      assigns(:identity).should be_kind_of(Identity)
      assigns(:identity).should be_new_record
    end

    it 'renders new' do
      get :new
      response.should render_template('new')
    end

    context 'on omniauth registration failure' do
      let(:identity) { build(:identity) }
      before { identity.errors.add(:base, 'omniauth failure') }
      before { request.env['omniauth.identity'] = identity }

      it 'assigns the identity returned from omniauth' do
        get :new
        assigns(:identity).should eq(identity)
        flash[:alert].should include('omniauth failure')
      end
    end
  end
end

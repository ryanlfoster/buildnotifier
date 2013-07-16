require 'spec_helper'

describe User do
  # fields
  it { should have_fields(:name, :email).of_type(String) }

  # associations
  it { should have_many :authorizations }
  it { should have_and_belong_to_many :groups }
  it { should have_many(:releases).as_inverse_of(:creator) }
  it { should have_many :approval_statuses }
  it { should have_one(:invitation).with_dependent(:destroy) }
  it { should have_one(:password_reset).with_dependent(:destroy) }

  # validations
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of :email }

  #indexes
  it { should have_index_for(email: 1) }

  let(:user) { create(:user) }

  let(:auth_match) {
    {
      'uid' => user.email,
      'provider' => 'identity',
      'info' => {
        'name' => user.name,
        'email' => user.email
      }
    }
  }

  let(:auth_not_match) {
    {
      'uid' => 'whoami',
      'provider' => 'identity',
      'info' => {
        'name' => 'Unknown',
        'email' => 'non.exist@who.cares'
      }
    }
  }

  describe '#email' do
    it_behaves_like 'a case insensitive unique field'
  end

  describe '.find_by_auth' do
    before { user }

    context 'when a matched authorization exists' do
      let(:auth) { auth_match }
      let!(:authorization) {
        create(:authorization,
               provider: 'identity',
               uid: user.email,
               user_id: user.id)
      }

      it 'returns the user' do
        User.find_or_create_by_auth(auth).should eq(user)
      end
      it 'does not create a Authorization' do
        expect {
          User.find_or_create_by_auth(auth)
        }.not_to change(Authorization, :count).by(1)
      end
    end

    context 'when no authorization is matched' do
      context 'when user with the email exists' do
        let(:auth) { auth_match }

        it 'returns the user' do
          User.find_or_create_by_auth(auth).should eq(user)
        end
        it 'creates a Authorization' do
          expect {
            User.find_or_create_by_auth(auth)
          }.to change(Authorization, :count).by(1)
        end
      end
      context 'when user with the email does not exist' do
        let(:auth) { auth_not_match }

        it 'creates a user' do
          expect {
            User.find_or_create_by_auth(auth)
          }.to change(User, :count).by(1)
        end
        it 'creates a Authorization' do
          expect {
            User.find_or_create_by_auth(auth)
          }.to change(Authorization, :count).by(1)
        end
        it 'returns the created user' do
          created_user = User.find_or_create_by_auth(auth)
          created_user.id.should_not eq(user.id)
          created_user.email.should eq('non.exist@who.cares')
        end
      end
    end
  end

  describe '.build_by_auth' do
    it 'returns a new user' do
      User.build_by_auth(auth_not_match).should be_a_new(User)
    end
    it 'initializes the name from auth' do
      User.build_by_auth(auth_not_match).name.should eq('Unknown')
    end
    it 'initializes the email from auth' do
      User.build_by_auth(auth_not_match).email.should eq('non.exist@who.cares')
    end
  end

  describe '.create_by_auth' do
    it 'creates the user' do
      expect {
        User.create_by_auth(auth_not_match)
      }.to change(User, :count).by(1)
    end

    it 'initializes the name from auth' do
      User.create_by_auth(auth_not_match).name.should eq('Unknown')
    end
    it 'initializes the email from auth' do
      User.create_by_auth(auth_not_match).email.should eq('non.exist@who.cares')
    end
  end

  describe '.save_auth' do
    it 'creates a new instance of Authorization' do
      expect {
        user.save_auth('provider' => 'twitter', 'uid' => 'intridea')
      }.to change(Authorization, :count).by(1)
    end
  end
end

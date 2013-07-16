require "spec_helper"

describe PasswordResetMailer do
  let(:user) { FactoryGirl.create(:user) }
  let(:password_reset) { FactoryGirl.create(:password_reset, user: user) }

  describe "#password_reset" do
    subject { PasswordResetMailer.password_reset(password_reset) }
    its(:subject) { should == I18n.t(:build_notifier_password_reset) }
    its(:to) { should include(user.email) }
  end
end

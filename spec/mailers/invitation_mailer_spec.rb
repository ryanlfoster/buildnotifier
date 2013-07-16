require "spec_helper"

describe InvitationMailer do
  let(:user) { FactoryGirl.create(:user) }
  let(:invitation) { FactoryGirl.create(:invitation, user: user) }

  describe "#invitaiton" do
    subject { InvitationMailer.invitation(invitation) }
    its(:subject) { should == I18n.t(:email_invitation_subject) }
    its(:to) { should == [user.email] }
  end
end

require 'spec_helper'

describe InvitationsController do
	let(:user) { FactoryGirl.create(:user) }
	let(:invitation) { FactoryGirl.create(:invitation, user: user) }
	describe "GET 'show'" do
		before do
			get :show, id: invitation.id
		end
		it { should respond_with(:success) }
		it { should render_template(:show) }
	end

	describe "PUT 'resend'" do
		before do
			put :resend, id: invitation.id
		end
		it { should respond_with(:redirect) }
		it { should redirect_to invitation }
		it { should set_the_flash[:notice].to(I18n.t(:resent_invitation, email: invitation.user.email)) }
		it "should send the invitation" do
			# TODO: Fix this
			# invitation.should_receive(:send_invitation)
		end
	end

	describe "GET 'claim'" do
		context "when invitation can be found" do
			before do
				get :claim, id: invitation.id, code: invitation.code
			end
			it { should respond_with :success }
			it { should render_template :claim }
			it "should change pending to false" do
				invitation.reload
				invitation.pending.should be_false
			end
		end
		context "when invitation can not be found" do
			before do
				get :claim, id: invitation.id, code: 'whatever' 
			end
			it { should respond_with :redirect }
			it { should redirect_to login_url }
			it { should set_the_flash[:alert].to(I18n.t(:invitation_code_invalid)) }
		end
	end
end

require 'spec_helper'

describe ApprovalStatusesController do
	let(:user) { FactoryGirl.create(:user) }
	let(:release) { FactoryGirl.create(:release, creator: user) }
  let(:product) { release.product }
  let(:approval_step) { FactoryGirl.create(:approval_step, product: product) }
	let(:approval_status) { FactoryGirl.create(:approval_status, approval_step: approval_step, user: user, release: release) }
	let(:valid_approval_status) { FactoryGirl.attributes_for(:approval_status, approval_step: approval_step, user: user, release: release) }
	let(:invalid_approval_status) { FactoryGirl.attributes_for(:approval_status, approval_step: approval_step, user: user, release: release) }
	
	before do
		login!(user)
	end

	describe "POST 'create'" do
		context "when the attributes are valid" do
			before do
				post :create, approval_status: valid_approval_status, release_id: release.id
			end
			it { should respond_with :redirect }
			it { should redirect_to release_url(release) }
			it { should set_the_flash[:notice].to I18n.t(:updated_approval) }
		end
		context "when the attributes are not valid" do
			before do
				ApprovalStatus.any_instance.stub(:save).and_return(false)
				post :create, approval_status: invalid_approval_status, release_id: release.id
			end
			it { should respond_with :redirect }
			it { should redirect_to release_url(release) }
			it { should set_the_flash[:alert].to I18n.t(:error_updating_approval) }
		end
	end

	describe "PUT 'update'" do
		context "when the attributes are valid" do
			before do
				put :update, id: approval_status.id, approval_status: valid_approval_status, release_id: release.id
			end
			it { should respond_with :redirect }
			it { should redirect_to release_url(release) }
			it { should set_the_flash[:notice].to I18n.t(:updated_approval) }
		end
		context "when the attributes are not valid" do
			before do
				approval_status.stub(:save).and_return(false)
				put :update, id: approval_status.id, approval_status: invalid_approval_status, release_id: release.id
			end
			it { should respond_with :redirect }
			it { should redirect_to release_url(release) }
			it { should set_the_flash[:alert].to I18n.t(:error_updating_approval) }
		end
	end

	describe "PUT 'reset'" do
		before do
			put :reset, release_id: release.id
		end
		it { should respond_with :redirect }
		it { should redirect_to release_url(release) }
		it { should set_the_flash[:notice].to I18n.t(:approvals_have_been_reset_for_this_release) }
		it "should reset the statuses of the release" do
			# FIXME
			# release.should_receive(:"reset_approvals!")
		end
	end
end

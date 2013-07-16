require 'spec_helper'

describe ApprovalStepsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:release) { FactoryGirl.create(:release, creator: user) }
  let(:product) { release.product }
	let(:group) { product.groups.first }
  let(:approval_step) { FactoryGirl.create(:approval_step, product: product) }
  let(:valid_approval_step_attributes) { FactoryGirl.attributes_for(:approval_step, group_id: group.id) }
  let(:invalid_approval_step_attributes) { FactoryGirl.attributes_for(:approval_step).merge(name: nil) }

  before do
    login!(user)
  end

  describe "POST 'create'" do
    context "when the attributes are valid" do
      before do
        post :create, approval_step: valid_approval_step_attributes, product_id: product.slug
      end
      it { should redirect_to edit_product_url(product, tab: 'groups-approvals') }
      it { should set_the_flash[:notice].to I18n.t(:approval_step_added) }
    end
    context "when the attributes are not valid" do
      before do
        post :create, approval_step: invalid_approval_step_attributes, product_id: product.slug
      end
      it { should redirect_to edit_product_url(product, tab: 'groups-approvals') }
      it { should set_the_flash[:alert] }
    end
  end

  describe "PUT 'update'" do
    context "when the attributes are valid" do
      before do
        put :update, id: approval_step.id, approval_step: valid_approval_step_attributes, product_id: product.slug
      end
      it { should redirect_to edit_product_url(product, tab: 'groups-approvals') }
      it { should set_the_flash[:notice].to I18n.t(:approval_step_saved) }
    end
    context "when the attributes are not valid" do
      before do
        put :update, id: approval_step.id, approval_step: invalid_approval_step_attributes, product_id: product.slug
      end
      it { should redirect_to edit_product_url(product, tab: 'groups-approvals') }
      it { should set_the_flash[:alert] }
    end
  end

  describe "DELETE 'destroy'" do
    before do
      delete :destroy, id: approval_step.id, product_id: product.slug
    end
    it { should redirect_to edit_product_url(product, tab: 'groups-approvals') }
    it { should set_the_flash[:notice].to I18n.t(:approval_step_removed) }
  end
end

require 'spec_helper'

describe GroupsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:release) { FactoryGirl.create(:release, creator: user) }
  let(:product) { release.product }
  let(:group) { FactoryGirl.create(:group, product: product) }
  let(:valid_group_attributes) { FactoryGirl.attributes_for(:group) }
  let(:invalid_group_attributes) { FactoryGirl.attributes_for(:group).merge(name: nil) }

  before do
    login!(user)
  end

  describe "POST 'create'" do
    context "when the attributes are valid" do
      before do
        post :create, group: valid_group_attributes, product_id: product.slug
      end
      it { should redirect_to edit_product_url(product, tab: 'groups-approvals') }
      it { should set_the_flash[:notice].to I18n.t(:group_added) }
    end

    context "when the attributes are not valid" do
      before do
        post :create, group: invalid_group_attributes, product_id: product.slug
      end
      it { should redirect_to edit_product_url(product, tab: 'groups-approvals') }
      it { should set_the_flash[:alert] }
    end
  end

	describe "DELETE 'destroy'" do
		context "when it can be destroyed" do
			before do
				delete :destroy, id: group.id, product_id: product.slug
			end
			it { should redirect_to edit_product_url(product, tab: 'groups-approvals') }
			it { should set_the_flash[:notice].to I18n.t(:group_deleted) }
		end
		context "when it can not be destroyed" do
			before do
				Group.any_instance.stub(:destroy).and_return(false)
				delete :destroy, id: group.id, product_id: product.slug
			end
			it { should redirect_to edit_product_url(product, tab: 'groups-approvals') }
			it { should set_the_flash[:alert] }
		end
	end
end

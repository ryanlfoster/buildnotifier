require 'spec_helper'

describe ProductsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:release) { FactoryGirl.create(:release, creator: user) }
  let(:product) { release.product }

  before do
    login!(user)
  end

  describe "GET 'show'" do
    before do
      get :show, id: product.slug
    end

    it { should respond_with(:success) }
    it { should render_template(:show) }
  end

  describe "GET 'index'" do
    before do
      user.stub!(:products).and_return([product])
      get :index
    end
    
    it { should respond_with(:success) }
    it { should render_template(:index) }
  end

  describe "GET 'edit'" do
    before do
      get :edit, id: product.slug
    end

    it { should respond_with(:success) }
    it { should render_template(:edit) }
  end

  describe "PUT 'update'" do
    context "when the attributes are valid" do
      let(:valid_product_attributes) { FactoryGirl.attributes_for(:product) }
      before do
        put :update, id: product.id, product: valid_product_attributes
      end
      it { should redirect_to edit_product_url(product) }
      it { should set_the_flash[:notice].to I18n.t(:saved_product) }
    end
    context "when the attributes are not valid" do
      let(:invalid_product_attributes) { FactoryGirl.attributes_for(:product).merge(name: nil) }
      before do
        put :update, id: product.id, product: invalid_product_attributes
      end
      it { should render_template('edit') }
    end
  end
end

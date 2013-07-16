class ProductsController < ApplicationController
  respond_to :html, :xml, :json

	load_resource only: [:show, :edit, :update, :destroy]
	before_filter :authorize_view_product, only: [:show]
  before_filter :authorize_view_release, only: [:show]
	before_filter :authorize_manage_product, only: [:edit, :update, :destroy]

  def index
    @page_title = t :all_products
		@products = current_user.accessible_products
  end

  def edit
    @page_title = t :edit_product, name: @product.name
  end

  def update
    @page_title = t :edit_product, name: @product.name

    if @product.update_attributes params[:product]
      redirect_to edit_product_url(@product), notice: t(:saved_product)
    else
      render 'edit'
    end
  end
end

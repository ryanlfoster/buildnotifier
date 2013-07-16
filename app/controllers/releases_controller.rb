class ReleasesController < ApplicationController
  respond_to :html, :xml, :json

	before_filter :load_release, only: [:show, :edit, :update, :destroy]
	before_filter :authorize_view_release, only: [:show]
	before_filter :authorize_manage_release, only: [:show, :edit, :update, :destroy]

  def index
    @page_title = t :all_releases 

		@releases = Release.all.select do |release|
			can? :view, release
		end
  end

  def show
    @page_title = @release.descriptive_name
  end

  def destroy
    @release.destroy
    redirect_to root_url, notice: t(:removed_release) 
  end

  def new
    @page_title = t(:new_release, name: t(controller_name.singularize))
    @release = class_from_controller_name.new
  end

  def create
    @page_title = t(:new_release, name: t(controller_name.singularize))

    @release = class_from_controller_name.new params[controller_name.singularize].merge({creator: current_user})

    if @release.save
      if @release.product.new_product?
        redirect_to edit_product_url(@release.product), notice: t(:please_verify_the_information_for_this_product)
      else
        redirect_to @release.product, notice: t(:added_release, name: t(controller_name.singularize))
      end
    else
      render 'new'
    end
  end

  def edit
    @page_title = t :edit_release, name: @release.descriptive_name

    respond_with @release
  end

  def update
    @page_title = t :edit_release, name: @release.descriptive_name

    @release.update_attributes params[controller_name.singularize]

    if @release.save
      redirect_to release_url(@release), notice: t(:saved_release) 
    else
      render 'edit'
    end

  end

  protected 

  def class_from_controller_name
    controller_name.singularize.camelize.constantize
  end

	def load_release
		@release = Release.find params[:id]
	end

  def authorize_view_release
		authorize! :view, @release
	end

	def authorize_manage_release
		authorize! :manage, @release
	end
end

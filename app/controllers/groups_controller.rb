class GroupsController < ApplicationController
  load_resource :product
  before_filter :authorize_manage_product

  def create
    @group = @product.groups.build params[:group]

    if @group.save
      redirect_to edit_product_url(@product, tab: 'groups-approvals'), notice: t(:group_added)
    else
      redirect_to edit_product_url(@product, tab: 'groups-approvals'), alert: object_errors(@group)
    end
  end

  def update
    if request.xhr?
      @group = Group.find params[:id]

      unless params[:toggle_permission].blank?
        @group.toggle_permissions params[:toggle_permission]
      end

      render partial: '/products/permissions', object: @group
    end
  end

  def destroy
    @group = @product.groups.find params[:id]
    if @group.destroy
      redirect_to edit_product_url(@product, tab: 'groups-approvals'), notice: t(:group_deleted)
    else
      redirect_to edit_product_url(@product, tab: 'groups-approvals'), alert: object_errors(@group)
    end
  end
end

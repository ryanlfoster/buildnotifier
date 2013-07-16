class ApprovalStepsController < ApplicationController
	load_resource :product
	before_filter :authorize_manage_product

  def create
    @approval_step = @product.approval_steps.build params[:approval_step]
    @approval_step.position = @product.approval_steps.count

    if @approval_step.save
      redirect_to edit_product_url(@product, tab: 'groups-approvals'), notice: t(:approval_step_added)
    else
      redirect_to edit_product_url(@product, tab: 'groups-approvals'), alert: object_errors(@approval_step)
    end
  end

  def update
    @approval_step = @product.approval_steps.find params[:id]
    @approval_step.update_attributes params[:approval_step]

    if @approval_step.save
      redirect_to edit_product_url(@product, tab: 'groups-approvals'), notice: t(:approval_step_saved)
    else
      redirect_to edit_product_url(@product, tab: 'groups-approvals'), alert: object_errors(@approval_step)
    end
  end

  def destroy
    @approval_step = @product.approval_steps.find params[:id]
    @approval_step.destroy
    redirect_to edit_product_url(@product, tab: 'groups-approvals'), notice: t(:approval_step_removed)
  end

  def sort
    params[:approval_step].each_with_index do |approval_step, i|
      a = @product.approval_steps.find approval_step
      a.position = i
      a.save!
    end

    @product.reload

    render nothing: true
  end
end

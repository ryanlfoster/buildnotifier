class ApprovalStatusesController < ApplicationController
  respond_to :html, :xml, :json

	load_resource :release
	before_filter :authorize_manage_release

  def create
    @approval_status = @release.approval_statuses.build params[:approval_status]

    if @approval_status.save
      redirect_to release_url(@release), notice: t(:updated_approval)
    else
      redirect_to release_url(@release), alert: t(:error_updating_approval)
    end
  end

  def update
    @approval_status = @release.approval_statuses.find params[:id]

    @approval_status.update_attributes params[:approval_status]

    if @approval_status.save
      redirect_to release_url(@release), notice: t(:updated_approval)
    else
      redirect_to release_url(@release), alert: t(:error_updating_approval)
    end
  end

  def reset
    @release.reset_approvals!
    redirect_to release_url(@release), notice: t(:approvals_have_been_reset_for_this_release)
  end
end

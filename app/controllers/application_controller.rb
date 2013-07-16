class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user
  before_filter :validate_user

  rescue_from CanCan::AccessDenied do |exception| 
    redirect_to root_url, :alert => exception.message
  end

  protected

  def current_user
    @current_user ||= User.where(_id: session[:user_id]).first
  end

  def show_header_link
    @header_link_hidden = false
  end

  def hide_header_link
    @header_link_hidden = true
  end

  def validate_user
    unless current_user
      hide_header_link
      session[:original_request] = request.url
      redirect_to login_url
    end
  end

  protected

  def object_errors(object)
    object.try(:errors).try(:full_messages).try(:join, ", ")
  end

  def authorize_view_product
		authorize! :view, @product
	end

	def authorize_manage_product
		authorize! :manage, @product
	end

  def authorize_view_release
		authorize! :view, @release
	end

	def authorize_manage_release
		authorize! :manage, @release
	end
end

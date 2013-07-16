class UsersController < ApplicationController
  AUTOCOMPLETE_FIELDS = %w(name email)
  skip_before_filter :validate_user, only: [:new]

  before_filter :find_product, only: [:new, :create, :destroy]
  before_filter :find_group, only:[:new, :create, :destroy]
  before_filter :find_or_create_user, only: [:create]
  before_filter :new_user_in_group, only: [:new]
  before_filter :new_user_in_product, only: [:new]

  def new
    @identity = request.env['omniauth.identity'] || Identity.new

    unless @identity.errors.empty?
      if @identity.pending_invitation?
        flash.now[:alert] = object_errors(@identity)
        redirect_to User.where(email: @identity.email).first.invitation
      end
      flash.now[:alert] = object_errors(@identity)
    end
  end

  def create
    resource = @group || @product
    if resource.users.include? @user
      redirect_to edit_product_url(@product, tab: 'groups-approvals'), alert: t(:resource_already_contains_user, name: resource.class.name)
    else
      resource.users << @user

      if resource.save
        redirect_to edit_product_url(@product, tab: 'groups-approvals'), notice: t(:resource_added_user, name: resource.class.name.downcase)
      else
        redirect_to edit_product_url(@product, tab: 'groups-approvals'), alert: object_errors(resource)
      end
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      if @user.has_authorization(:identity)
        @identity = @user.identity
        fields = [:name, :email]
        unless params[:password].blank?
          if @identity.authenticate(params[:old_password])
            fields.push(*[:password, :password_confirmation])
          else
            flash.now[:alert] = t(:wrong_password_profile_update)
            render 'edit'
            return
          end
        end

        if @identity.update_attributes(params.merge(params[:user]).slice(*fields))
          redirect_to edit_user_url(@user), notice: t(:profile_updated)
        else
          flash.now[:alert] = object_errors(@identity)
          render 'edit'
        end
      else
        redirect_to edit_user_url(@user), notice: t(:profile_updated)
      end
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])

    if @group.remove_user(@user)
      redirect_to edit_product_url(@product, tab: 'groups-approvals'), notice: t(:group_removed_user)
    else
      redirect_to edit_product_url(@product, tab: 'groups-approvals'), alert: object_errors(@group)
    end
  end

  def autocomplete
    if AUTOCOMPLETE_FIELDS.include? params[:field]
      @users = User.where params[:field] => /#{params[:term]}/i
      render json: @users.map{|user| {label: user.send(params[:field]), value: user.id}}
    end
  end

  def show
    @user = User.find(params[:id])
    render json: @user
  end

  protected
  def find_or_create_user
    unless params[:existing_user_id].blank?
      @user = User.find(params[:existing_user_id])
    else
      @user = User.find_or_initialize_by(email: params[:user][:email])
      @user.name = params[:user][:name] if @user.new_record?

      if @user.save
        @user.send_invitation(params[:invitation_message])
      else
        redirect_to edit_product_url(@product, tab: 'groups-approvals'), alert: object_errors(user)
      end
    end
  end

  def find_product
    @product = Product.find params[:product_id] if params[:product_id].present?
  end

  def find_group
    @group = Group.find params[:group_id] if params[:group_id].present?
  end

  def new_user_in_group
    # If we're adding a user from the group page
    if params[:product_id].present? && params[:group_id].present?
      render partial: '/products/add_user_to_group'
    end
  end

  def new_user_in_product
    # If we're adding a user from the product
    if params[:product_id].present? && !params[:group_id].present?
      render partial: '/products/add_user_to_product'
    end
  end
end

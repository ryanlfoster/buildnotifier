class Group
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :permissions, type: Array, default: [:view_release]

  has_and_belongs_to_many :users
  belongs_to :product
  has_many :approval_steps, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :product_id }

  default_scope asc(:created_at)

  before_destroy :prevent_pm_group_deletion

  PERMISSIONS = [:view_release, :edit_release, :edit_product]

  class << self
    def permission_description(permission)
      I18n.t "permission_#{permission.to_s}"
    end
  end

  def is_pm?
    self.name == I18n.t(:product_managers_group_name)
  end

  def can_remove_user?(user)
    self.is_pm? && self.users.count > 1
  end

  def remove_user(user)
    if can_remove_user? user 
      self.user_ids.try :delete, user.id
      return self.save
    else
      errors.add :base, I18n.t(:need_one_pm)
      return false
    end
  end

  def toggle_permissions(permiss)
    return if self.is_pm?

    if self.permissions.include? permiss.to_sym 
      self.permissions.delete permiss.to_sym
    else
      self.permissions << permiss.to_sym
    end

    self.permissions.uniq!
    self.save
  end

  protected

  def prevent_pm_group_deletion
    if self.is_pm?
      errors.add(:base, I18n.t(:group_cannot_delete_pms))
      return false
    end
  end
end

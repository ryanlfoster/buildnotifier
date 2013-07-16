class Ability
  include CanCan::Ability

  def initialize(user)
    if user.roles.empty?
      send "common", user
    else
      user.roles.each do |role|
        send role.name, user
      end
    end
	end

	private
  def admin(user)
    can :manage, :all
  end

  def common(user)
    can :approve, ApprovalStep do |approval_step|
      groups = find_groups(approval_step.product, user) 
      groups.include?(approval_step.group) || groups.map(&:is_pm?).any?
    end

    can :view, Release do |release|
      find_permissions(release.product, user).include?(:view_release)
    end

    can :manage, Release do |release|
      find_permissions(release.product, user).include?(:edit_release)
    end

    can :view, Product do |product|
      find_permissions(product, user).include?(:view_release) || product.users.include?(user)
    end

    can :manage, Product do |product|
      find_permissions(product, user).include?(:edit_product)
    end

    cannot :create, Product

    can :manage_release_for, Product do |product|
      find_permissions(product, user).include?(:edit_release)
    end
  end

	def find_permissions(product, user) 
		find_groups(product, user).collect(&:permissions).uniq.flatten
	end

	def find_groups(product, user)
		product.groups.all_in user_ids: [user.id]
	end
end

class ApprovalStatus
  include Mongoid::Document

  field :reason
  field :status, type: Symbol, default: :unavailable
  field :date, type: DateTime
  field :position, type: Integer

  default_scope asc(:position)

  belongs_to :approval_step
  belongs_to :release
  belongs_to :user

  STATUSES = [:pending, :unavailable, :approved, :rejected]

  after_save :update_release_status
  after_save :notify_pms_of_all_status_changes
  after_save :notify_group_of_pending_status

  protected
  def last?
    self == self.release.approval_statuses.all.last
  end

  def update_release_status
    case self.status
    when :rejected
      self.reject!
    when :approved
      self.last? ? self.approve! : self.set_next_status_to_pending
    end
  end

  def reject!
    self.release.overall_status = :rejected
    self.release.save!
  end

  def approve!
    self.release.overall_status = :approved
    self.release.save!
  end

  def find_next_status
    self.release.approval_statuses.all[self.release.approval_statuses.index(self)+1]
  end

  def set_next_status_to_pending
    next_status = find_next_status
    next_status.status = :pending
    next_status.save!
  end

  def notify_group_of_pending_status
    if self.status_changed_to_pending?
      ReleaseMailer.release_notification(find_user_emails, self.release, self.approval_step).deliver
    end
  end

  def find_users
    self.approval_step.group.users
  end

  def find_user_emails
    find_users.collect(&:email).flatten
  end

  def status_changed_to_pending?
    self.status_changed? && self.status == :pending
  end

  def find_pms
    self.release.product.groups.select(&:is_pm?).collect(&:users).flatten
  end

  def find_pm_emails
    find_pms.collect(&:email).flatten
  end
  
  def status_changed_to_approved_or_rejected?
    self.status_changed? && [:approved, :rejcted].include?(self.status)
  end
  
  def status_initialized_to_pending?
    self.status_was.nil? && self.status == :pending
  end

  def should_notify_pm?
    self.status_changed_to_approved_or_rejected? || self.status_initialized_to_pending? 
  end

  def notify_pms_of_all_status_changes
    if should_notify_pm?
      ReleaseMailer.detailed_notification(find_pm_emails,
                                          self,
                                          self.status_was,
                                          self.status).deliver
    end
  end
end

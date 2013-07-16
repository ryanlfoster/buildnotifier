class Release
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :version
  field :notes
  field :identification
  field :overall_status, type: Symbol, default: :pending

  belongs_to :product
  belongs_to :creator, class_name: 'User', inverse_of: :releases

  has_many :approval_statuses, dependent: :destroy

  default_scope desc(:created_at)

  validates_presence_of :name, :identification

  before_create :associate_product
  after_create :initialize_statuses

  after_save :notify_creator_of_status_change

  def descriptive_name
    "#{self.name} v#{self.version}"
  end

  def rejection_reason
    self.approval_statuses.to_a.find{|a|a.status == :rejected}.try(:reason) || I18n.t(:missing_approval_step)
  end

  def reset_approvals!
    self.approval_statuses.delete_all
    self.overall_status = :pending
    self.save!
    self.initialize_statuses
  end

  def next_step_name
    self.approval_statuses.select{|status| status.status == :pending}.first.try(:approval_step).try(:name)
  end

  protected

  def initialize_statuses
    self.product.approval_steps.each_with_index do |step, index|
      status = (index == 0 ? :pending : :unavailable)
      self.approval_statuses << ApprovalStatus.create(release: self,
                                                        approval_step: step,
                                                        status: status,
                                                        position: step.position)
    end
  end

  def can_associate_product?(product)
    ability = Ability.new(self.creator)
    ability.can?(:create, Product) || ability.can?(:manage_release_for, product)
  end

  def associate_product
    associated_product = Product.find_or_initialize_by :identification => self.identification

    if can_associate_product? associated_product
      self.product = associated_product

      self.product.name = self.name if (self.product.name.blank? && !self.name.blank?)

      if self.product.new_record?
        self.product.releases << self
        self.product.save!
      end
    else
      self.errors.add(:base, I18n.t(:no_permission))
      return false
    end
  end

  def notify_creator_of_status_change
    if should_notify_creator_of_status_change?
      ReleaseMailer.overall_status_change(self).deliver
    end
  end

  def should_notify_creator_of_status_change?
    self.overall_status_changed? && [:approved, :rejected].include?(self.overall_status)
  end
end

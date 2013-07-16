class Identity
  include Mongoid::Document
  include Mongoid::Timestamps
  include OmniAuth::Identity::Models::Mongoid

  field :email, type: String
  field :name, type: String
  field :password_digest, type: String

  index :email => 1

  validates :email, presence: true, uniqueness: { case_sensitive: false }

  validate :check_for_pending_invitation

  def pending_invitation?
    self.check_for_pending_invitation
    self.errors.messages[:base].try(:include?, I18n.t(:invitation_pending_error))
  end

  protected

  def check_for_pending_invitation
    begin
      invitation = User.where(email: self.email).first.invitation

      if invitation.pending?
        errors.add(:base, I18n.t(:pending_invitation_error))
      end
    rescue
      # Do nothing
    end
  end
end

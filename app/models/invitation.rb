class Invitation
  include Mongoid::Document
  include Mongoid::Timestamps

  field :code, default: -> { SecureRandom.hex(20) }
  field :pending, default: true
  field :message

  belongs_to :user

  def reset_code
    self.code = SecureRandom(20)
    self.save
  end

  def send_invitation
    InvitationMailer.invitation(self).deliver
  end
end

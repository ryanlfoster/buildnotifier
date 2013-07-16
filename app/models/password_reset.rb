class PasswordReset
  include Mongoid::Document
  include Mongoid::Timestamps

  field :code, default: -> { SecureRandom.hex(20) }
  field :expiration, type: DateTime, default: -> { 1.day.from_now }

  belongs_to :user

  after_create :send_password_reset

  def expired?
    Time.now < self.expiration
  end

  protected

  def send_password_reset
    PasswordResetMailer.password_reset(self).deliver
  end
end

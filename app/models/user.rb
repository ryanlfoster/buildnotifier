class User
  include Mongoid::Document
  include Mongoid::Timestamps

  rolify

  field :name, type: String
  field :email, type: String

  has_many :authorizations, dependent: :destroy
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :users
  has_many :releases, class_name: 'Release', inverse_of: :creator
  has_many :approval_statuses
  has_one :invitation, dependent: :destroy
  has_one :password_reset, dependent: :destroy

  index :email => 1
  
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  before_destroy :delete_identity

	ROLE = %w(super user)

	def accessible_products
		ability = Ability.new self
		Product.all.select do |product|
			ability.can? :view, product
		end
	end

	def accessible_releases
		ability = Ability.new self
		Release.all.select do |release|
			ability.can? :view, release
		end
	end

  class << self
    def create_by_auth(auth)
      user = build_by_auth(auth)
      if user.save
        user.save_auth(auth)
        user
      end
    end
    
    def build_by_auth(auth)
      info = auth['info'] || {}
      User.new name: info['name'], email: info['email']
    end

    # Find the User instance for authorized user.
    # If the user does not exist yet, create it on the fly.
    def find_or_create_by_auth(auth)
      find_by_auth(auth) || create_by_auth(auth)
    end

    def find_by_auth(auth)
      user = find_by_auth_through_authorizations(auth) ||
        find_by_auth_through_email(auth)

      user
    end

    private
    def find_by_auth_through_authorizations(auth)
      if authorization = Authorization.find_by_auth(auth)
        authorization.user
      end
    end

    def find_by_auth_through_email(auth)
      if email = auth['info'].try(:[], 'email')
        if user = User.where(email: email).first
          user.save_auth(auth)
          user
        end
      end
    end
  end

  # Save omniauth.auth as Authorization
  def save_auth(auth)
    authorizations << Authorization.build_by_auth(auth)
    self # for method chain
  end

  def has_authorization(auth)
    self.authorizations.map(&:provider).include?(auth.to_s)
  end

  def identity
    Identity.find(self.authorizations.select{|a| a.provider == "identity"}.first.uid) if has_authorization(:identity)
  end

  def send_invitation(invitation_message)
    self.invitation ||= Invitation.new(message: invitation_message)
    self.invitation.send_invitation
  end

  def products
    Group.all_in(user_ids: [self.id]).collect(&:product).uniq.flatten
  end

  protected

  def delete_identity
    identity.destroy if identity
  end
end

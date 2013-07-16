class Authorization
  include Mongoid::Document

  field :provider, type: String
  field :uid, type: String

  belongs_to :user

  index :user_id => 1

  validates :provider, presence: true
  validates :uid, presence: true, uniqueness: { scope: [:provider] }

  PROVIDERS = {
    google_apps: 'Google'
  }

  class << self
    def find_by_auth(auth)
      where(provider: auth['provider'], uid: auth['uid']).first
    end

    def build_by_auth(auth)
      new(provider: auth['provider'],
          uid: auth['uid'])
    end
  end

  def readable_provider_name
    PROVIDERS[provider.to_sym]
  end
end

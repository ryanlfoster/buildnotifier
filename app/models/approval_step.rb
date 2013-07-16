class ApprovalStep
  include Mongoid::Document
  include ActsAsList::Mongoid 

  field :name

  default_scope asc(:position)

  belongs_to :product
  belongs_to :group
  has_many :approval_statuses, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :product_id }
	validates :group_id, presence: true
end

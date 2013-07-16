class Product
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps

  field :name
  field :identification
  field :description

  slug :name

  has_many :releases, dependent: :destroy
  has_many :approval_steps, dependent: :destroy
  has_many :groups, dependent: :destroy
  has_and_belongs_to_many :users

  validates_presence_of :name
  validates_uniqueness_of :identification

  default_scope asc(:name)

  before_destroy :rename_pm_group

  after_create :initialize_groups

  def self.[](param)
    Product.find_by_slug param.to_s
  end

  # Sets up the initial group
  def initialize_groups
    self.groups.create name: I18n.t(:product_managers_group_name),
                       users: [releases.first.creator], 
                       permissions: Group::PERMISSIONS
  end

  def new_product?
    releases.count == 1
  end

  def find_pm
    groups.all.select(&:is_pm?).first 
  end

  protected

  # This gets around the PM group preservation when deleting a product
  def rename_pm_group
    if pm = self.find_pm 
      pm.name = "DELETE ME"
      pm.save!
    end
  end
end

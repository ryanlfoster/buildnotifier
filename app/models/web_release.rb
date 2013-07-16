class WebRelease < Release
  # This needs to be done after initialize so that product assocation works
  after_initialize :clean_url

  before_validation :set_version
  before_validation :update_name

  protected

  def clean_url
    unless self.identification.blank?
      self.identification = URI.parse(self.identification).normalize.to_s
    end
  end

  def update_name
    associated_product = Product.where(identification: self.identification).first

    if associated_product && associated_product.name.present?
      self.name = associated_product.name
    end
  end

  def set_version
    self.version = Time.now.strftime('%F-%T') if self.version.blank?
  end
end

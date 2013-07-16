require 'plist_parser'

class IosRelease < Release
  include Mongoid::Paperclip

  has_mongoid_attached_file :ipa, PAPERCLIP_STORAGE_OPTIONS
  
  after_initialize :load_details_from_ipa

  protected

  def load_details_from_ipa
    if ipa.queued_for_write[:original]
      ipa_path = ipa.queued_for_write[:original].path
      self.identification = PlistParser.bundle_id_from_ipa(ipa_path)
      self.name = PlistParser.name_from_ipa(ipa_path)
      self.version = PlistParser.version_from_ipa(ipa_path)
    end
  end
end

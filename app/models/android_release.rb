require 'apk_parser'

class AndroidRelease < Release
  include Mongoid::Paperclip

  has_mongoid_attached_file :apk, PAPERCLIP_STORAGE_OPTIONS
  
  after_initialize :load_details_from_apk

  protected

  def load_details_from_apk
    if apk.queued_for_write[:original]
      apk_path = apk.queued_for_write[:original].path
      parser = ApkParser.new apk_path
      self.identification = parser.package_id
      self.name = parser.name
      self.version = parser.version
    end
  end
end

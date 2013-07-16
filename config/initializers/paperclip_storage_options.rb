if Rails.env.production?
  PAPERCLIP_STORAGE_OPTIONS = {
    :storage => :s3, 
    :s3_credentials => "#{Rails.root}/config/s3.yml"
  }
else
  PAPERCLIP_STORAGE_OPTIONS = {}
end

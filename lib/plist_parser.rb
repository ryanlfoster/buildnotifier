class PlistParser
  require 'cfpropertylist'
  require 'zip/zip'

  @@plist_cache = {}

  class << self
    def bundle_id_from_mobileprovision(mobileprovision_file)
      plist = from_mobileprovision(mobileprovision_file)

      app_id = plist[:entitlements][:application_identifiers]
      prefix = plist[:application_identifier_prefixes].first

      Rails.logger.debug "#{app_id} #{prefix}"

      # Strip the access group off the front of the bundle ID
      app_id[/#{prefix}\.(.*)/,1]
    end

    def bundle_id_from_ipa(ipa_file)
      from_ipa(ipa_file)[:cf_bundle_identifiers]
    end

    def name_from_ipa(ipa_file)
      from_ipa(ipa_file)[:cf_bundle_names]
    end

    def version_from_ipa(ipa_file)
      from_ipa(ipa_file)[:cf_bundle_versions]
    end

    def from_ipa(ipa_file, opts = {})
      return @@plist_cache[ipa_file] if @@plist_cache[ipa_file] && opts[:force_reload].blank?

      plist_bin = nil

      Zip::ZipFile.foreach(ipa_file) do |f|
        if f.name.match(/Payload\/[A-Za-z]*\.app\/Info.plist/)
          plist_bin = f.get_input_stream.read
        end
      end

      # Load as a plist file
      plist = CFPropertyList::List.new(:data => plist_bin)

      # Extract to hash
      plist_data = CFPropertyList.native_types(plist.value)

      @@plist_cache[ipa_file] = symbolize_keys(plist_data)
    end

    def from_mobileprovision(mobileprovision_file, opts = {})
      return @@plist_cache[mobileprovision_file] if @@plist_cache[mobileprovision_file] && opts[:force_reload].blank?

      # Read the raw data from the file
      raw_contents = IO.read(mobileprovision_file)

      # Reencode into readable text
      encoded_contents = raw_contents.encode("ISO8859-1",
                                             undef: :replace,
                                             invalid: :replace,
                                             replace: '')

      # Extract the plist XML data
      plist_xml = encoded_contents.scan(/[[:print:]]/).join.slice(/<.xml.*<.plist>/)

      # Load as a plist file
      plist = CFPropertyList::List.new(:data => plist_xml)

      # Extract to hash
      plist_data = CFPropertyList.native_types(plist.value)

      @@plist_cache[mobileprovision_file] = symbolize_keys(plist_data)
    end

    protected

    def symbolize_keys(hash)
      out = {}

      hash.each do |key,value|
        out[key.tableize.to_sym] = value.instance_of?(Hash) ? symbolize_keys(value) : value
      end

      out
    end
  end
end

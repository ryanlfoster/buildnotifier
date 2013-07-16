class ManifestsController < ApplicationController
  respond_to :plist

  def show
    @release = Release.find params[:id]

    plist_data = {
      items: [{
        assets: [{
          kind: 'software-package',
          url: ipa_dl_url(@release)
        }],
        metadata: {
          'bundle-identifier' => @release.bundle_id,
          kind: 'software',
          subtitle: @release.name,
          title: @release.name
        }
      }]
    }

    plist = CFPropertyList::List.new
    plist.value = CFPropertyList.guess(plist_data)

    xml_parser = CFPropertyList::XML.new

    respond_to do |format|
      format.plist { render text: xml_parser.to_str(root: plist.value) }
    end
  end

  protected

  def ipa_dl_url(release)
    PAPERCLIP_STORAGE_OPTIONS.has_key?(:s3_credentials) ? release.ipa.url : "#{root_url}#{release.ipa.url}"
  end
end

module ApplicationHelper
  def download_path(release)
    case release.class
    when IosRelease
      manifest_ipa_url(release) if release.is_a?(IosRelease)
    when AndroidRelease
      release.apk.url if release.is_a?(AndroidRelease)
    when WebRelease
      release.identification
    end
  end

  def gravatar(user = current_user, size = 32)
    Gravatar.new(user.email).image_url(size: size, default: :wavatar)
  end

  def manifest_ipa_url(release)
    "itms-services://?action=download-manifest&url=#{CGI::escape(manifest_url(release, :plist))}"
  end

  def page_title
    "Build Notifier#{(' | ' + @page_title) unless @page_title.blank?}"
  end

  def release_action_text(release)
    case release.class
    when IosRelease, AndroidRelease
      I18n.t :install_over_the_air
    when WebRelease
      I18n.t :go_to_url
    else
      I18n.t :download
    end
  end

  def release_icon(release)
    case release.class
    when IosRelease
      content_tag(:img, nil, {src: asset_path('apple-icon.png'), valign: 'middle', class: 'release-icon'})
    when AndroidRelease
      content_tag(:img, nil, {src: asset_path('android-icon.png'), valign: 'middle', class: 'release-icon'})
    when WebRelease
      content_tag(:img, nil, {src: asset_path('web-icon.png'), valign: 'middle', class: 'release-icon'})
    end
  end
end

$(document).ready ->
  $('.release-notes h5 small').click ->
    $(this).parent().siblings('.well').toggle()

  $('.release-notes .close').click ->
    $(this).parent().hide()
    return false

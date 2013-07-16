$(document).ready ->
  $('.modal-cancel').click ->
    $(this).closest('.modal').modal('hide')
    return false

  $('.reject').click ->
    $('#set-rejection-reason').modal
      backdrop: 'static'
      show: true
    return false

  $('#rejection-reason-save').click ->
    $('#approval_status_reason').val($('#reason').val())
    $('#rejection-form').submit()
    return false

  $('*[rel="popover"]').popover()

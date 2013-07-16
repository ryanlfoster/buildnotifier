user_selected = (event, ui) ->
  user_id = ui.item.value

  $('#new_user fieldset input:text')
    .attr('disabled', 'disabled')
    .val('...')
  $('#existing_user_id').val(user_id)
  $('.invitation-message').hide()

  $.getJSON "/users/#{user_id}", (data) ->
    $('#user_name').val(data.name)
    $('#user_email').val(data.email)

  return false

bind_permissions = ->
  $('.permissions a')
    .bind 'ajax:complete', (event, xhr) ->
      $(this)
        .parents('.permissions')
        .html(xhr.responseText)
      bind_permissions()
    .bind 'ajax:beforeSend', (event, xhr, settings) ->
      $(this).parents('.permissions').find('.permission-list').hide()
      $(this).parents('.permissions').find('.spinner').show()

$(document).ready ->
  $('.add-user-link')
    .bind 'ajax:complete', (event, xhr) ->
      $('#add-user-form')
        .html(xhr.responseText)

      $('#user_name').focus()

      $('.modal-cancel').click ->
        $(this).closest('.modal').modal('hide')
        $('#user_name').autocomplete('close')
        $('#user_email').autocomplete('close')
        return false

      $('#user_name').autocomplete
        source: $('#name-autocomplete-link').find('a').attr('href')
        select: user_selected
      $('#user_email').autocomplete
        source: $('#email-autocomplete-link').find('a').attr('href')
        select: user_selected

    .bind 'ajax:beforeSend', (event, xhr, settings) ->
      # Show the modal with a spinner
      $('#add-user-form')
        .html($('#spinner').html())
        .modal
          backdrop: 'static'
          show: true

  bind_permissions()

#    .bind 'ajax:beforeSend', (event, xhr, settings) ->
#      # Show the modal with a spinner
#      $('#add-user-form')
#        .html($('#spinner').html())
#        .modal
#          backdrop: 'static'
#          show: true

#    .bind 'ajax:beforeSend', (event, xhr, settings) ->
#    .bind 'ajax:success', (event, data, status, xhr) ->
#    .bind 'ajax:complete', (event, xhr) ->
#    .bind 'ajax:failure', (event, status, error) ->

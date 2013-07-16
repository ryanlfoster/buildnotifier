updateSort = (event, ui) ->

  @old_text = $('.approval-help').text()
  $('.approval-help').text("Saving...")

  $.ajax
    type: 'post',
    data: $(ui.item).closest('ul').sortable('serialize'),
    dataType: 'script',
    url: $(ui.item).parent().siblings('.sort-link').find('a').attr('href')
    success: =>
      $('.approval-help').text("Saved!")
      setTimeout (=> $('.approval-help').text(@old_text)), 1000

$(document).ready ->
  $('.approval-steps').sortable
    update: updateSort

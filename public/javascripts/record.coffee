$ ->
  record_template = jade.compile $('#record_template').html() 
  $('form').submit (event) ->
    $form = $(this)
    event.preventDefault()
    $form.find('.alert').hide()
    $.post $form.attr('action'), $form.serialize() , (res)->
      if res.error
        return $form.find('.alert').html(res.error).show() 
      $('#records tbody').append record_template res
  $(document).on 'click','a[href^="/record/remove"]', (event) ->
    $a = $(this)
    event.preventDefault()
    $.get $a.attr('href'), (res)->
      if res.error
        return $a.parents('table').find('.alert').html(res.error).show()
      $a.parents('tr').remove()
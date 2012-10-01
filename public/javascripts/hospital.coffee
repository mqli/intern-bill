$ ->
  hospital_template = jade.compile $('#hospital_template').html() 
  $('form').submit (event) ->
    $form = $(this)
    event.preventDefault()
    $form.find('.alert').hide()
    $.post $form.attr('action'), $form.serialize() , (res) ->
      if res.error
        return $form.find('.alert').html(res.error).show()
      $('#hospitals tbody').append hospital_template res.hospital
  $(document).on 'click', 'a[href^="/hospital/remove"]', (event) ->
    $a = $(this)
    event.preventDefault()
    $.get $a.attr('href'), (res)->
      if res.error
        return $a.parents('table').find('.alert').html(res.error).show() 
      $a.parents('tr').remove()
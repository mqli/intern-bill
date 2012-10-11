$(function  () {
  var alert_template = jade.compile($('#alert_template').html()),
      hospital_option = jade.compile($('#hospital_option').html()),
      bill_template = jade.compile($('#bill_template').html()),
      getBill = function () {
      	$.get('/tools/bill.ajax', function (result) {
          $('#bills').html(bill_template(result));
        });
      };
  //add hospital
  $('#hospital_form').submit(function (event) {
    var $form = $(this);
    event.preventDefault();
    $form.find('div.alert').remove()
      .end().find('button').attr('disabled',true);
    $.post($form.attr('action'), $form.serialize(), function (result) {
      $form.find('button').attr('disabled',false);
      if (result.message) {
        $form.append(alert_template({
          message: result.message
        }));
        return;
      }
      $('select[name="billId"]').append(hospital_option(result.bill));
      $('#bills').append(bill_template(result.bill));
    });
  });
  //remove hospital
  $(document).on('click','#bills thead a', function (event) {
    var $a = $(this);
    $a.parents('table').parent().find('div.alert').remove();
    event.preventDefault();
    $.get($a.attr('href'), function (result) {
      if (result.message) {
      	return $a.parents('table').before(alert_template({
          message: result.message
        }));
      }
     $a.parents('table').parent().remove();
     $('select[name="billId"] option[value="' + result.bill._id + '"]').remove();
    });
  });

  $('#student_form').submit(function (event) {
    var $form = $(this);
    event.preventDefault();
    $.post($form.attr('action'), $form.serialize(), function (bill) {
      $form.find('button').attr('disabled',false);
      $('#' + bill._id).html(bill_template(bill));
    });
  });
  //remove student
  $(document).on('click', '#bills tbody a', function (event) {
    var $a = $(this);
    event.preventDefault();
    $.get($a.attr('href'), function (bill) {
      $('#' + bill._id).html(bill_template(bill));
    });
  });
});
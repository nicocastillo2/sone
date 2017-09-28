$(function() {
  $(document).on('click', '#contacts-feedback a', function(event) {
    event.preventDefault();
    var dataType = $('#contacts-feedback').attr('data-feedback-type');
    var link = $(this).attr('href');
    var dateNumber = $('.report-select').find(":selected").val();
    var sentData = { "filter[nps_date]" : dateNumber, 'feedback_type': dataType };
    var feedback_type = $('#contacts-feedback').attr('data-feedback-type');
    var params;

    if (feedback_type!==undefined) {
      params = $("#filter-form").serialize()+"&feedback_type="+dataType;
    } else {
      params = $("#filter-form").serialize();
    }

    $.post(link, params, function(data){
      $("#contacts-feedback").html(data);
    });
  });

  $(document).on('click', '#all-campaigns', function(event) {
    event.preventDefault();
    if ($('#campaigns-checkboxes input').is(':checked')) {
      $('#campaigns-checkboxes input').removeAttr('checked');
    } else {
      $('#campaigns-checkboxes input').prop('checked', true );
    }
  });

  $(document).on('click', '#all-topics', function(event) {
    event.preventDefault();
    if ($('#topics-checkboxes input').is(':checked')) {
      $('#topics-checkboxes input').removeAttr('checked');
    } else {
      $('#topics-checkboxes input').prop('checked', true );
    }
  });

  $(document).on('click', '.feedback-stat:not(:first-child) span', function(event) {
    event.preventDefault();
    // Collect data to send through AJAX post request
    var urlPathname = window.location.pathname;
    var reportUrl = $('#download-report').attr('href');
    var dataType = $(this).attr('data-feedback-type');
    var feedbackType = '&feedback_type=' + dataType;
    var modifiedUrl = reportUrl + feedbackType;
    $('#download-report').attr('href', modifiedUrl);

    var sendData = $("#filter-form").serialize() + '&feedback_type=' + dataType;

    $.post(urlPathname, sendData, function(data){
      $("#contacts-feedback").html(data);
      $('#contacts-feedback').attr('data-feedback-type', dataType);
    });

  });


  // preview create campaign
  $(document).on("keyup change focusout", "#nombre-empresa-field", function(){
    var nombre = $(this).val() + " a un amigo o familiar?";
    $("#nombre-empresa-preview").html(nombre);
  });

  $(document).on("click", "#img-logo-img",function() {
    $("#img-logo-field").click();
  });

  $(document).on("change", "#img-logo-field", function(event) {
    var reader = new FileReader();
    reader.onload = function(e) {
      $("#img-logo-preview").attr('src', e.target.result);
    };

    reader.readAsDataURL(event.target.files[0]);
    // var url = event.target.files[0];
    // $("#img-logo-preview").attr('src', url);
  });
  // end preview create campaign
});

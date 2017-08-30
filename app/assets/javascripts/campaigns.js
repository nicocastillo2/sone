$(function() {
  $(document).on('click', '#contacts-feedback a', function(event) {
    event.preventDefault();
    var dataType = $('#contacts-feedback').attr('data-feedback-type');
    var link = $(this).attr('href');
    var dateNumber = $('.report-select').find(":selected").val();
    var sentData = { "filter[nps_date]" : dateNumber, 'feedback_type': dataType };
    $.post(link, sentData, function(data){
      $("#contacts-feedback").html(data);
    });
  });

  $(document).on('click', '.feedback-stat:not(:first-child) span', function(event) {
    event.preventDefault();
    var urlPathname = window.location.pathname;
    var dataType = $(this).attr('data-feedback-type');
    $('#contacts-feedback').attr('data-feedback-type', dataType);
    var dateNumber = $('.report-select').find(":selected").val();
    var sentData = { 'feedback_type': dataType, 'filter[nps_date]' : dateNumber };
    $.post(urlPathname, sentData, function(data){
      $("#contacts-feedback").html(data);
    });
  });
});

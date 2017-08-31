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

    // Collect data to send through AJAX post request
    var urlPathname = window.location.pathname;
    var reportUrl = $('#download-report').attr('href');
    var dataType = $(this).attr('data-feedback-type');
    $('#contacts-feedback').attr('data-feedback-type', dataType);
    var dateNumber = $('.report-select').find(":selected").val();
    var sentData = { 'feedback_type': dataType, 'filter[nps_date]' : dateNumber };

    // Manipulate report url to insert feedback type into query string
    var urlReplaced = reportUrl.replace(/=.*&/, '=&');
    var str1 = urlReplaced.slice(0, urlReplaced.indexOf('=') + 1);
    var str2 = urlReplaced.slice(urlReplaced.indexOf('=') + 1);
    var modifiedUrl = str1 + dataType + str2;
    $('#download-report').attr('href', modifiedUrl);

    $.post(urlPathname, sentData, function(data){
      $("#contacts-feedback").html(data);
    });
  });
});

// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap-sprockets
//= require bootstrap-colorpicker
//= require d3c3_rails
//= require turbolinks
//= require datepicker
//= require rails-ujs
//= require_tree .

$(document).on('turbolinks:load', function() {
  $('.colorpicker').colorpicker();

  $('.input-daterange').datepicker({
    format: 'yyyy-mm-dd'
  });

  // Selected date for report
  $(document).on('change', '.report-select', function(){
    $('input[name=feedback_date]').remove();

    var reportUrl = $('#download-report').attr('href').slice(0, -1);
    var dateNumber = $('.report-select').find(":selected").val();
    var dateText = $('.report-select').find(":selected").text();

    $('<input>').attr({
      type: 'hidden',
      value: dateText,
      name: 'feedback_date'
    }).appendTo('#filter-form');

    var newReportUrl = reportUrl + dateNumber;
    $('#download-report').attr('href', newReportUrl);
  });

  // Campaigns checkboxes
  var selectedCampaigns = [];
  $('#campaigns-checkboxes input:checked').each(function() {
    selectedCampaigns.push($(this).val());
  });
  var reportFullUrl = $('#download-report').attr('href');
  var campaignsStr = selectedCampaigns.join();
  var urlWithCampaigns = reportFullUrl + '&campaigns=' + campaignsStr;
  $('#download-report').attr('href', urlWithCampaigns);

  // Topics checkboxes
  var selectedTopics = [];
  $('#topics-checkboxes input:checked').each(function() {
    selectedTopics.push($(this).val());
  });
  var reportFullUrl = $('#download-report').attr('href');
  var topicsStr = selectedTopics.join();
  var urlWithTopics = reportFullUrl + '&topics=' + topicsStr;
  $('#download-report').attr('href', urlWithTopics);
});

$("#upfile1").click(function () {
    $("#file1").trigger('click');
});
$('#close', ".close").click(function() {
  console.log("si entre a esta wea");
    $.ajax({
        url: "",
        context: document.body,
        success: function(s,x){

            $('html[manifest=saveappoffline.appcache]').attr('content', '');
                $(this).html(s);
        }
    }); 
});

function checkForm(form){
  if(!form.terms.checked) {
    alert("Por favor acepta los terminos y condiciones.");
    form.terms.focus();
    return false;
  }
  return true;
}

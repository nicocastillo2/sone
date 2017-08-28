
$(function() {

  $(document).on('click', '#contacts-feedback a', function(event) {
    event.preventDefault();
    var link = $(this).attr('href');
    var dateNumber = $('.report-select').find(":selected").val();
    $.post(link, {"filter[nps_date]" : dateNumber}, function(data){
      console.log(data);
      $("#contacts-feedback").html(data);
    });
  });

});

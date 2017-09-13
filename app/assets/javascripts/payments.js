$(function() {
  $(".change-payment").click(function() {
    $("#current-card").hide(function() {
      $("#edit-card").show("fold");
    });
  });
});
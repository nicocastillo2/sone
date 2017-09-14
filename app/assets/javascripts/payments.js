$(function() {
  $(document).on("click", ".change-payment",function() {
    $("#current-card").hide(function() {
      $("#edit-card").show("fold");
    });
  });
});
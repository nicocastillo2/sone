//= require jquery
//= require bootstrap-sprockets
//= require bootstrap-colorpicker
//= require bxslider.min
//= require d3c3_rails
//= require rails-ujs
//= require turbolinks


$(function() {
  // Handler for .ready() called.
    margin_top();
    title_mobile();
});

$( window ).resize(function() {
  margin_top();
  title_mobile();
});

$(window).scroll(function() {
  title_botton();
})

function margin_top(){
  if (window.outerWidth <= 991){
      $('#popular').addClass('margin-top-5');
  }else{
    $('#popular').removeClass('margin-top-5');
  }
}

function back_to_top(){
  document.body.scrollTop=0;
  document.documentElement.scrollTop=0;
}
function title_botton(){
   var algo=$(window).scrollTop()
  if (algo >= 322){
    $('#flecha-arriba').removeClass('hide');
    $('#flecha-arriba').addClass('show');

  }else{
    $('#flecha-arriba').addClass('hide');
    $('#flecha-arriba').removeClass('show');  }
}

function title_mobile(){
  if (window.outerWidth <= 991){
      $('#prim').removeClass('font-80');
      $('#prim').addClass('font-40');
      $('#prim').addClass('text-center');
      $('#prim').addClass('padding-right-30');
      $('#segu').removeClass('font-65');
      $('#segu').addClass('font-30');
      $('#segu').removeClass('padding-left-20');
      $('#segu').addClass('text-center');
      $('#terc').removeClass('font-80');
      $('#terc').addClass('font-40');
      $('#terc').addClass('text-center');
      $('#terc').removeClass('text-right');
      $('#terc').addClass('padding-left-30');

  }
}

// $(document).ready(function() {
//   console.log("**************")
//   var slider = $('.bxslider-opinions').bxSlider({
//         pager: false,
//         controls: false,
//         onSlideBefore: function($slideElement, oldIndex, newIndex) {
//           $(".slider-clients-pages li.slider-page-item").removeClass("active");
//           $("[data-slide-index="+newIndex+"]").addClass("active");
//         }
//       });

//       $("#slider-right-arrow").click(function() {
//         slider.goToNextSlide();
//       });

//       $("#slider-left-arrow").click(function() {
//         slider.goToPrevSlide();
//       });
// });

//$(":file").filestyle({input: false});

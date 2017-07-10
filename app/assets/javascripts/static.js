//= require jquery
//= require bootstrap-sprockets
//= require bootstrap-colorpicker
//= require bxslider.min
//= require d3c3_rails
//= require rails-ujs
//= require turbolinks

$(document).ready(function() {
  // $('.bxslider').bxSlider();

  var slider = $('.bxslider-opinions').bxSlider({
        nextSelector: '#slider-right-arrow',
        prevSelector: '#slider-left-arrow',
        pager: false,
        onSlideBefore: function($slideElement, oldIndex, newIndex) {
          $(".slider-points, .slider-menu-titles li").removeClass("active");
          $("[data-slide-index="+newIndex+"]").addClass("active");
        }
      });

      $("#slider-right-arrow").click(function() {
        slider.goToNextSlide();
      });

      $("#slider-left-arrow").click(function() {
        slider.goToPrevSlide();
      });
});

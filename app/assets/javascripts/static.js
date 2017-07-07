//= require jquery
//= require bootstrap-sprockets
//= require bootstrap-colorpicker
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

console.log("hola")

function margin_top(){
	if (window.outerWidth <= 991){
    	$('#popular').addClass('margin-top-5');
	}else{
		$('#popular').removeClass('margin-top-5');
	}
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
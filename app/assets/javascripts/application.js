// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery-ui
//= require jquery-ui-touch-punch
//= require jquery_ujs
//= require bootstrap
// require bootstrap-sprockets
//= require_tree .

$('.headlines-more').click(function(event) {
	$('.headlines-compact').fadeToggle('fast');
    $('.headlines-extended').slideToggle('fast');
    $('.headlines-more i').toggleClass('icon-chevron-down icon-chevron-up');
});

$(".open_nav").on("click",function(){
  $(".body").toggleClass("mobileNavOpenActive");
});

$("header.module_heading nav ul li a, header.module_heading h2 a").click(function(event) {
	var ddl = $(this).closest("div.module").find(".dropdown");
	if(!ddl.is(':visible'))
		$(".dropdown").hide();
	ddl.toggle();

  if($(this).data("toggle") == "tab") {
	  $(this).closest("div.module").find("h2 > a:first-child").html($(this).html());
  } else
    event.stopPropagation();
});
$(document).click(function() {
  $(".dropdown").hide();
});
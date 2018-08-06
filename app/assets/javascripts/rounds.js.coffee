# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('ul.navbarNav li a').on 'click', (event) ->
  	$('.tab-pane.active .navbarToggle').click()
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  if $('#user_agree_to_terms').length > 0
    $('#sign_up_button').attr("disabled", "disabled")
    $('#user_agree_to_terms').click ->
      if $('#user_agree_to_terms').is(":checked")
        $('#sign_up_button').attr("disabled", false) 
      else
        $('#sign_up_button').attr("disabled", "disabled")
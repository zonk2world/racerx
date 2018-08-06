# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('#series_join').on 'click', (event) ->
    $('#series_join').attr('disabled', 'disabled')
    $(event.target).closest('form').submit()
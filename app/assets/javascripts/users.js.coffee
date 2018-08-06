# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
class @SortRiders
  constructor: ->
    $('.select_riders').sortable
      handle: '.handle'
      axis: 'y'
      start: (event, ui) ->
        $(ui.item).addClass( "dragging" );
      stop: (event, ui) ->
        $(ui.item).removeClass( "dragging" );
      update: ->    
        payload = {
          round_id: $(this).data('round-id'),
          sortable: $(this).sortable('toArray')
        };
        $.post($(this).data('update-url'), payload)
        
jQuery ->
  new SortRiders() if $('.select_riders').length > 0

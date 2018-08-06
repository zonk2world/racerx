# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
class CustomSeries
  constructor: ->
    $('.add_user_form').hide()
    $('.add_user').on 'click', @clickHandler

    if $('.alert-danger').length > 0
      $('.add-series').click()

  clickHandler: (event) =>
    inviteUserButton = $(event.target)
    seriesID = inviteUserButton.data 'custom-series'
    @toggleAddUserForm seriesID

  toggleAddUserForm: (seriesID) =>
    $(".add_user_form[data-custom-series='#{seriesID}']").toggle()
        
jQuery ->
  new CustomSeries() if $('.new_custom_series').length > 0


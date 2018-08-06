class PaymentForm
  constructor: ->
    window.paymentForm = this
    stripe_key = $('form#payment-form').data('stripe-key')
    Stripe.setPublishableKey(stripe_key);
    $("#payment-form").submit (event) ->
      $form = $(this)
      $form.find("button").prop "disabled", true
      Stripe.card.createToken $form, window.paymentForm.handleStripeResponse
      false

  handleStripeResponse: (status, response) ->
    if status == 200
      token = response.id
      $("#payment-form").append $("<input type=\"hidden\" name=\"stripeToken\" />").val(token)
      $("#payment-form")[0].submit()
    else
      $('.payment-errors').html("
        <div class='alert alert-danger alert-dismissable'>
          <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button>
          #{response.error.message}
        </div>"
      )
      $('button#payment-submit').attr('disabled', false)
$ ->
  new PaymentForm() if $('#payment-form').length > 0 
 

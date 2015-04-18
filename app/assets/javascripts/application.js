// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(document).ready(function(){
	$('.delete_cart_item').click(function(e){
		e.preventDefault();
		var cart_id = $(this).attr('cart_id');
		$.ajax({
    		url: '/checkouts/'+cart_id,
    		type: 'DELETE',
    		success: function(result) {
      			$('.cart_container').html(result);
    		}
		});
	});

  function createTokenData() {
    return {
      card_number: $('#card_number').val(),
      card_cvv: $('#card_cvc').val(),
      card_exp_month: $('#card_exp').val().match(/(\d+) \//)[1],
      card_exp_year: '20' + $('#card_exp').val().match(/\/ (\d+)/)[1],
      gross_amount: $('#gross_amount').val(),
      secure: false
    };
  }
  // Add custom event for form submition
  $('#card_form').on('submit', function (event) {
    var form = this;
    event.preventDefault();
    //console.log('eaaa :');

    Veritrans.token(createTokenData, function (data) {
      console.log('Token data:', data);
      // when you making 3D-secure transaction,
      // this callback function will be called again after user confirm 3d-secure
      // but you can also redirect on server side
      if (data.redirect_url) {
        // if we get url then it's 3d-secure transaction
        // so we need to open that page
        $('#3d-secure-iframe').attr('src', data.redirect_url).show();
      // if no redirect_url and we have token_id then just make charge request
      } else if (data.token_id) {
        $('#card_token').val(data.token_id);
        //console.log('token_id :'+data.token_id);
        form.submit();
      // if no redirect_url and no token_id, then it should be error
      } else {
        alert(data.validation_messages ? data.validation_messages.join("\n") : data.status_message);
      }
    });
  });
})
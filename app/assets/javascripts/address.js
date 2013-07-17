var address_id;

$(document).ready(function() {
  $('#address_address_id').change(function() 
	{
		if ($('#address_address_id').val() == ""){
			showNewAddressFields();
		}
		else{
			showExistingAddress($('#address_address_id').val());
		}
  });
	$('#address_address_id').change();
});

function showNewAddressFields(){
	$('.go_to_third_step').hide();
	$('#address_address_id').val('');
	$('.show_address').hide(1000);
	$('.new_address').show(1000);
}

function showExistingAddress(id){
  $.ajax({
    dataType: "json",
    url: '../address/get_address.json?id='+id,
    async: false,
    success: function(data) {
    	fillAddress(data);
    }
  });

	$('.go_to_third_step').show();
	$('.new_address').hide(1000);
	$('.show_address').show(1000);
}

function fillAddress(data){
	var address_info = data.address + ', ' + data.number + ' ' + data.complement;
	var region_info = data.district + ', ' + data.city + ' - ' + data.state;
	var zipcode_info = 'CEP: ' + data.zip_code;

	$('#identifier_info').html(data.identifier);
	$('#address_info').html(address_info);
	$('#region_info').html(region_info);
	$('#zipcode_info').html(zipcode_info);
}
function findZipCode()
{
    var zipcode = $("#address_zip_code").val();

    $.getJSON("http://api.postmon.com.br/v1/cep/" + $("#address_zip_code").val()).
                success(onZipCodeSuccess).
                error(onZipCodeError);
}

function onZipCodeSuccess(data)
{
    $('#address_address').val(data.logradouro);
    $('#address_address').removeClass('error');
    $('#address_district').val(data.bairro);
    $('#address_district').removeClass('error');
    $('#address_city').val(data.cidade);
    $('#address_city').removeClass('error');
    $('#address_state').val(data.estado);
    $('#address_state').removeClass('error');
    $('#address_address').focus();
}

function onZipCodeError(data)
{
    $('#address_zip_code').val('');
    $('#address_zip_code').focus();
}
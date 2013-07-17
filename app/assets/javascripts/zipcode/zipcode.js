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
    $('#address_district').val(data.bairro);
    $('#address_city').val(data.cidade);
    $('#address_state').val(data.estado);
    $('#address_number').focus();
}

function onZipCodeError(data)
{
    alert('cep invalido...');
    $('#address_zip_code').val('');
    $('#address_zip_code').focus();
}
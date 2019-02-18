// *********************************************
// SOLUÇÃO ELEGANTE
// *********************************************
String.prototype.replaceAll = function(de, para){
    var str = this;
    var pos = str.indexOf(de);
    while (pos > -1){
		str = str.replace(de, para);
		pos = str.indexOf(de);
	}
    return (str);
}

var showLoading = function(e, message){
  if(e) {
      $(e).html($('#loading').html());
  } else {
      $('#loading').show();
  }

  if(!message)
  {
  	message = "Carregando";
  }

  $('#loading .spinner-text').html(message);

}

var hideLoading = function(e){
	if(e) {

    } else {
        $('#loading').hide();
    }
}

var updateFieldRemote = function(path, model, field, field_remote_name, value, remote_collection = null)
{
    var id = "#" + model + "_" + field_remote_name + "_id";
    if ($(id)[0] == undefined) {
      id = "#" + model + "_" + field_remote_name;
    }

    $(id).html('<option value="0">Carregando ... </option>');
		$(id).parent().find('.select2-choice span').html("Carregando ... ");


    $(id).val('0');
    eval($(id).attr('onchange'));

    if(eval(value) >= 0)
    {
        $(id).attr('disabled', '');
        // $.post(path + "/remote", {fk: field, field: field_remote_name, fk_id: field + "_id", value: value}, null, 'script');
        $.post(path + "/remote", {fk: field, field: field_remote_name, fk_id: field + "_id", value: value, remote_collection: remote_collection}, null, 'script');
    }
    else
    {
        // $(id).html('<option value="0">Selecione</option>');
        $(id).html('<option value="">Selecione</option>');
        $(id)[0].disabled = true;
    }
}

var prepareFields = function(elem)
{
	$(elem).find(".select2-me").select2();
	// $('.bootstrap-timepicker')

	// timepicker
	$(elem).find('.timepick').timepicker({
		defaultTime: false,
		minuteStep: 1,
		disableFocus: true,
		template: 'dropdown',
		showMeridian: false
	}).on('changeTime.timepicker', function(e) {

		hours = e.time.hours;
		minutes = e.time.minutes;

		updateDateTimeValue($(this).closest('.bootstrap-timepicker'), hours, minutes);

	});

	// datepicker
	$(elem).find('.datepick').datepicker({ language: 'pt-BR' });

	$(elem).find('input.price_format').maskMoney({thousands:'', decimal:'.', allowNegative:true, allowZero:true});
}

var zeroPad = function(num, places) {
  var zero = places - num.toString().length + 1;
  return Array(+(zero > 0 && zero)).join("0") + num;
}

var updateDateTimeValue = function(elem, hours, minutes)
{
	var datetime = "";

	var date = $(elem).find('.datepick').val();

	if(hours != null && minutes != null)
		var time = zeroPad(hours, 2) + ":" + zeroPad(minutes, 2);
	else
		var time = $(elem).find('.timepick').val();

	if (date != "" && time != "")
		datetime = date + " " + time;

	$(elem).find('.datetime').val(datetime);
}

var getTableSelected = function()
{
	var ret = [];

	$('.table tbody .with-checkbox input:checked').each(function(index, el){
		ret.push($(el).val());
	});

	return ret;
}

// Handles "data-method" on links such as:
// <a href="/users/5" data-method="delete" rel="nofollow" data-confirm="Are you sure?">Delete</a>
function postPage(link, params, method) {
	if(method == null)
		method = 'post';
	if(params == null)
		params = [];

	var href = link,
		csrf_token = $('meta[name=csrf-token]').attr('content'),
		csrf_param = $('meta[name=csrf-param]').attr('content'),
		form = $('<form method="post" action="' + href + '"></form>'),
		metadata_input = '<input name="_method" value="' + method + '" type="hidden" />';

	if (csrf_param !== undefined && csrf_token !== undefined) {
		metadata_input += '<input name="' + csrf_param + '" value="' + csrf_token + '" type="hidden" />';
	}

	$(params).each(function(index, el){
		metadata_input += '<input name="' + el.name + '" value="' + el.value + '" type="hidden" />';
	});

	form.hide().append(metadata_input).appendTo('body');
	form.submit();
}

$(document).on('ready page:load', function(){

	prepareFields($('body'));

	$('.btn-remove-all-selected').click(function(e){
		e.preventDefault();

		var selected = getTableSelected()

		if(selected.length > 0)
		{
			if(confirm("Tem certeza que deseja excluir os itens selecionados?"))
			{
				var link = $(this).prop('href');
				var params = { name: 'ids', value: selected };

				postPage(link, params);
			}
		}
	});

	$('.box.list .actions #per_page').on('change', function(e){
		window.location.href = $(this).val();
	});

	$('.thefilter .with-checkbox input[type=checkbox]').click(function(e){
		$(this).closest('table').find('.with-checkbox input[type=checkbox]').prop('checked', $(this).prop('checked'));
	});

	$('.bootstrap-timepicker input').on('change', function(e){
		updateDateTimeValue($(this).closest('.bootstrap-timepicker'));
	});

	//HAS MANY ITEM
  $(".add_new_has_many_item").click(function(e){
			e.preventDefault();

      var limit = eval($(this).closest('.controls').find('.limit').val());

      var table = $(this).closest('.controls').find('table');
      var count = table.find('tr').length;
      var last = $(table.find('tr')[count - 1]);
      var clone = last.clone();

      clone.find('input, select').each(function(i, e){
          if($(this).attr('id'))
              $(this).attr('id', $(this).attr('id').replaceAll(count - 2, count - 1) );
          if($(this).attr('name'))
                $(this).attr('name', $(this).attr('name').replaceAll(count - 2, count - 1) );
          if(!$(this).hasClass('destroy'))
            $(this).val('');
          $(this).removeClass('hasDatepicker');
      });

			clone.find('.select2-container').remove();

      if(count >= limit && limit > 0)
        $(this).remove();

      last.after(clone);
      prepareFields(clone);
  });

  $(window).on('load', function(){
    $('select.belongs-to').each(function(i, e){
      var remote_element = $(e).attr('remote_element');
      $('#'+remote_element).html('<option value="">Selecione</option>');
      $('#'+remote_element)[0].disabled = true;
    });
  });

})

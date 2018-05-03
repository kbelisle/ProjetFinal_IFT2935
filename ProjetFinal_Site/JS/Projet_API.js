var CALLBACK_CONNECTION_STRING = "http://localhost:8132";

$(document).ready(function() {
	getAllCategories();
	
 $('.panel-collapse').on('show.bs.collapse', function () {
    $('#filtreIcon').removeClass('fa-chevron-up');
	$('#filtreIcon').addClass('fa-chevron-down');
  });

  $('.panel-collapse').on('hide.bs.collapse', function () {
    $('#filtreIcon').addClass('fa-chevron-up');
	$('#filtreIcon').removeClass('fa-chevron-down');
  });
});

function getAllCategories() {
	$.ajax({
		url : CALLBACK_CONNECTION_STRING + "/categorie",
		method: 'GET',
		dataType : 'json'
	}).done(function(data) {
		if(data.hasOwnProperty('errCode') && data.hasOwnProperty('data')) {
		  if(data.errCode == 0) {
			loadMenu(data.data,1,0,$('#parentDropDown'));
			BindNavMenu();
			loadFiltre(data.data);
		  }
		}
	});
}


function searchFilterObjet() {
	var txtNom = $('#txtNom').val();
	var txtCat = $('#categorieFilter').val();
	$.ajax({
		url : CALLBACK_CONNECTION_STRING + "/filterSearch",
		method: 'GET',
		dataType : 'json',
		data: {name:txtNom, categorie:txtCat}
	}).done(function(data) {
		if(data.hasOwnProperty('errCode') && data.hasOwnProperty('data')) {
		  if(data.errCode == 0) {
			loadObjetList(data.data);
		  }
		}
	});
}

function loadMenu(categories,niv,index,parent) {
	if(categories.length == 0) return;
	var i = index;
	do {
		var li = $('<li>');
		var a = $('<a>')
		.attr('class', 'dropdown-item')
		.attr('href','#')
		.text(categories[i].ncat);
		if( i + 1 < categories.length && categories[i+1].niveau > niv) {
			a.addClass('dropdown-toggle');
			var ul = $('<ul>').attr('class','dropdown-menu');
			i = loadMenu(categories,categories[i+1].niveau,i+1,ul);
			a.appendTo(li);
			ul.appendTo(li);
		}
		else {
			a.appendTo(li);
		}
		li.appendTo(parent);
		i++;
	}while(i < categories.length && categories[i].niveau >= niv);
	return i-1;
}

function loadFiltre(categories) {
	for(var i = 0; i < categories.length; i++) {
		var dash = "";
		for(var k = 0; k < categories[i].niveau - 1; k++) 
			dash += "--";
		$('#categorieFilter').append($('<option>', {
		  value: categories[i].ncat,
		}).text(dash + categories[i].ncat));
	}
}

function loadObjetList(objets) {
	$('#accordion').html('');
	
	if(!objets || objets.length == 0) {
		$('<h1>').attr('style','text-align:center;margin-top:20px;').text('Aucun Résultat').appendTo($('#accordion'));
	}
	else {
		for(var i = 0; i < objets.length; i++) {
			createEmptyCard(objets[i].idobj,objets[i].name,objets[i].odesc,objets[i].features);
		}	
	}
}

function createEmptyCard(idobj,name,desc,features) {
	var accordion = $('#accordion');
	var card = $('<div>', {
		class: 'card'
	}).appendTo(accordion);
	var card_header = $('<div>', {
		class: 'card-header',
		id: 'heading_' + idobj
	}).appendTo(card);
	var card_header_h5 = $('<h5>', {
		class: 'mb-0'
	}).appendTo(card_header);
	var card_header_h5_button = $('<button>', {
		class: 'btn btn-link',
		style: 'text-decoration:none;',
		text: name	
	}).attr('data-toggle', 'collapse')
	.attr('data-target', '#collapse_' + idobj)
	.attr('aria-expanded', 'true')
	.attr('aria-controls', 'collapse_' + idobj)
	.appendTo(card_header_h5);
	var collapse = $('<div>', {
		id: 'collapse_' + idobj,
		class: 'collapse'
	})
	.attr('aria-labelledby','heading_' + idobj)
	.attr('data-parent','#accordion')
	.appendTo(card);
	var card_body = $('<div>', {
		class: 'card-body'
	}).appendTo(collapse);
	var card_body_desc = $('<div>', {
		class: 'first-group-accordion'	
	}).html(desc).appendTo(card_body);
	var card_body_features = $('<div>').appendTo(card_body);
	var card_body_features_h4 = $('<h4>', {
		text: 'Features'
	}).appendTo(card_body_features);
	if (features && features.length > 0) {
		var card_body_features_table = $('<table>',{
			class: 'table table-striped'
		}).appendTo(card_body);
		for (var i = 0; i < features.length; i++) {
			var card_body_features_table_tr = $('<tr>').appendTo(card_body_features_table);
			$('<td>',{
				text: features[i].fname
			}).appendTo(card_body_features_table_tr);
			var td2 = $('<td>',{
				text: features[i].fvalue
			}).appendTo(card_body_features_table_tr);
		}
	}
	else {
		$('<p>').text('Aucune feature disponible pour cet objet').appendTo(card_body);
	}
}
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
  searchFilter();
});

function getAllCategories() {
	$.ajax({
		url : CALLBACK_CONNECTION_STRING + "/categorie",
		method: 'GET',
		dataType : 'json'
	}).done(function(data) {
		if(data.hasOwnProperty('errCode') && data.hasOwnProperty('data')) {
		  if(data.errCode == 0) {
			loadMenu(data.data);
			loadFiltre(data.data);
		  }
		}
	})
}


function searchFilter() {
	var name = $('#txtNom').val();
	var ncat = $('#categorieFilter').val();
	
	$.ajax({
		url : CALLBACK_CONNECTION_STRING + "/search",
		method: 'GET',
		dataType : 'json'
	}).done(function(data) {
		if(data.hasOwnProperty('errCode') && data.hasOwnProperty('data')) {
		  if(data.errCode == 0) {
			loadObjetList(data.data);
		  }
		}
	})
}

function loadMenu(categories) {

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

}

  
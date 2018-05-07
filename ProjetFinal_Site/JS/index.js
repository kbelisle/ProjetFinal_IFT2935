$(document).ready(function() {
	getAllCategories(loadFiltre);
	getURLCategorie();
});
/* remplit le select du filtre.*/
function loadFiltre(errCode, errMsg, data) {
	if(errCode == "0") {
		var categories = data;
		for(var i = 0; i < categories.length; i++) {
			var dash = "";
			for(var k = 0; k < categories[i].niveau - 1; k++) 
				dash += "--";
			$('#categorieFilter').append($('<option>', {
			  value: categories[i].ncat,
			}).text(dash + categories[i].ncat));
		}
		var url = new URL(window.location.href);
		var c = url.searchParams.get("categorie");
		if(c) {
			$('#categorieFilter').val(c);
		}
	}

}

function getURLCategorie() {
	var url = new URL(window.location.href);
	var c = url.searchParams.get("categorie");
	console.log(c);
	if(c) {
		/*Set Categorie in filter select and search*/
		console.log("set");
		getFilterResult(c,'');
	}
	else {
		/*Set nothing and search all*/
		console.log("no set");
		getFilterResult();
	}
}

function searchFilterAnnonce() {
	$('#annonce_container').html('');
	var cat = $('#categorieFilter').val();
	var name = $('#txtNom').val();
	
	getFilterResult(cat,name);
}

function getFilterResult(cat,name) {
	if (!cat) {
		cat = '';
	}
	if(!name) {
		name = ''
	}
	getActiveAnnonceByFilter(cat,name,AfterResultRetrieve);
}

function AfterResultRetrieve(errCode,errMsg,data) {
	var container = $('#annonce_container');
	if(errCode == "0") {
		data.forEach((row) => {
			var a = $('<a>')
			.attr('href', 'annonce_detail.html?id=' + row.idannonce)
			.attr('class', 'list-group-item list-group-item-action')
			.text(row.name + " Disponible jusqu'au : " + row.datefin);
			a.appendTo(container);
		});
	}
	else {
		$('<p>').text("Une erreur est survenue lors de l'obtention des annonces actives").appendTo(container);
	}
}
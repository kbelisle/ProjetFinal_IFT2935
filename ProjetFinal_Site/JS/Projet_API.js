var CALLBACK_CONNECTION_STRING = "http://localhost:8132";

/*Page onload*/
$(document).ready(function() {
	getAllCategories();
	
	$("#create_user_form").submit(addUser);
	$("#create_ad_form").submit(addAd);
	
	if($("#objet_categorie") !== undefined) 
		initCategoriesSelectionForm($("#objet_categorie"));
	
	if($("#vendeur_id") !== undefined) 
		initUserIDs($("#vendeur_id"));
	
	if($("#acheteur_id") !== undefined)
		initUserIDs($("#acheteur_id"));
	
	if($("#annonce_id") !== undefined)
		initAnnonceIDs($("#annonce_id"));
	
	if($("#utilisateur_preference") !== undefined)
		initCategoriesSelectionForm($("#utilisateur_preference"));
	
 $('.panel-collapse').on('show.bs.collapse', function () {
    $('#filtreIcon').removeClass('fa-chevron-up');
	$('#filtreIcon').addClass('fa-chevron-down');
  });

  $('.panel-collapse').on('hide.bs.collapse', function () {
    $('#filtreIcon').addClass('fa-chevron-up');
	$('#filtreIcon').removeClass('fa-chevron-down');
  });
});
/*obtient les categories ordonnés et les ajoutent au menu categorie dans la barre de navigation et dans le select du filtre.*/
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

function initCategoriesSelectionForm(selectionForm) {
	
	$.ajax({
		url : CALLBACK_CONNECTION_STRING + "/categorie",
		method : "GET",
		dataType : "json"
	}).done(function(data) {
		
		if(data.hasOwnProperty('errCode') && data.hasOwnProperty('data')) {
			
			if(data.errCode == 0) {
				
				data.data.forEach((row) => {
					
					selectionForm.append('<option value="' + row.ncat + '">' + row.ncat + '</option>');
					
				});
				
			}
			
		}
		
	});
	
}

function initAnnonceIDs(selectionForm) {
	
	$.ajax({
		url : CALLBACK_CONNECTION_STRING + "/ad",
		method : "GET",
		dataType : "json"
	}).done(function(data) {
		
		if(data.hasOwnProperty('errCode') && data.hasOwnProperty('data')) {
			
			if(data.errCode == 0) {
				
				data.data.forEach((row) => {
					
					selectionForm.append('<option value="' + row.idannonce + '">' + row.idannonce + '</option>');
					
				});
				
			}
			
		}
		
	});
	
}

function initUserIDs(selectionForm) {
	
	$.ajax({
		url : CALLBACK_CONNECTION_STRING + "/utilisateur",
		method : "GET",
		dataType : "json"
	}).done(function(data) {
		
		if(data.hasOwnProperty('errCode') && data.hasOwnProperty('data')) {
			
			if(data.errCode == 0) {
				
				data.data.forEach((row) => {
					
					selectionForm.append('<option value="' + row.iduser + '">' + row.iduser  + ' - ' + row.prenom + ' ' + row.nom + '</option>');
					
				});
				
			}
			
		}
		
	});
	
}

function getAllAds() {
	
	$.ajax({
		url : CALLBACK_CONNECTION_STRING + "/ad",
		method : "GET",
		dataType : "json"
	}).done(function(data) {
		
		if(data.hasOwnProperty('errCode') && data.hasOwnProperty('data')) {
			
			if(data.errCode == 0) {
				
				console.log(data.data);
				
			}
			
		}
		
	});
	
}

function getPurchaseHistory() {
	
	const id = $("#acheteur_id").val(); 
	
	$.ajax({
		url : CALLBACK_CONNECTION_STRING + "/purchases/" + id,
		method : "GET",
		dataType : "json"
	}).done(function(data) {
		
		if(data.hasOwnProperty('errCode') && data.hasOwnProperty('data')) {
			
			if(data.errCode == 0) {
				
				$("#title").text("Historique des achats de " + data.data[0].acheteur_prenom + " " + data.data[0].acheteur_nom);
				$("#sales_table tbody").html("");
				
				data.data.forEach((row) => {
					
					var itemName = row.objet_nom;
					var itemNameTD = "<td ";
					
					if(itemName.length > 30) {
						
						itemName = itemName.substring(0, 30) + "...";
						itemNameTD += 'data-container="body" data-toggle="tooltip" title="' + row.objet_nom + '"';
						
					}
					
					itemNameTD += '>' + itemName + "</td>";
										
					var row = "<tr><td>" + row.partage_date + "</td>" +
								itemNameTD +
								"<td>" + row.objet_categorie + "</td>" +
								"<td>" + row.prix + "</td>" + 
								"<td>" + row.vendeur_prenom + " " + row.vendeur_nom + "</td></tr>";
					
					$("#sales_table tbody").append(row);
					
				});
				
			}
			else {
				$("#title").text("Aucun achat pour l'ID " + id);
				$("#sales_table tbody").html("");
				
			}
			
		}
		
	});
	
}

function getSaleHistory() {
	
	const id = $("#vendeur_id").val(); 
	
	$.ajax({
		url : CALLBACK_CONNECTION_STRING + "/sales/" + id,
		method : "GET",
		dataType : "json"
	}).done(function(data) {
		
		if(data.hasOwnProperty('errCode') && data.hasOwnProperty('data')) {
			
			if(data.errCode == 0) {
				
				$("#title").text("Historique des ventes de " + data.data[0].vendeur_prenom + " " + data.data[0].vendeur_nom);
				$("#sales_table tbody").html("");
				
				data.data.forEach((row) => {
					
					var itemName = row.objet_nom;
					var itemNameTD = "<td ";
					
					if(itemName.length > 30) {
						
						itemName = itemName.substring(0, 30) + "...";
						itemNameTD += 'data-container="body" data-toggle="tooltip" title="' + row.objet_nom + '"';
						
					}
					
					itemNameTD += '>' + itemName + "</td>";
										
					var row = "<tr><td>" + row.partage_date + "</td>" +
								itemNameTD +
								"<td>" + row.objet_categorie + "</td>" +
								"<td>" + row.prix + "</td>" + 
								"<td>" + row.acheteur_prenom + " " + row.acheteur_nom + "</td></tr>";
					
					$("#sales_table tbody").append(row);
					
				});
				
			}
			else {
				
				$("#title").text("Aucune vente pour l'ID " + id);
				$("#sales_table tbody").html("");
				
			}
			
		}
		
	});
	
}

function getAnnonce() {

	const id = $("#annonce_id").val();
	
	$.ajax({
		url : CALLBACK_CONNECTION_STRING + "/ad/" + id,
		method : "GET",
		dataType : "json"
	}).done(function(data) {
		
		if(data.hasOwnProperty('errCode') && data.hasOwnProperty('data')) {
			
			if(data.errCode == 0) {
		
				$("#annonce_features").hide();
				$("#annonce_info").show();
				
				$("#annonce_titre").text('Annonce #' + data.data.annonce_id);
				$("#objet_nom").text(data.data.objet_nom);
				$("#objet_prix").text(data.data.prix);
				$("#objet_qte").text(data.data.qte);
				$("#date_debut").text(data.data.date_debut);
				$("#date_fin").text(data.data.date_fin);
				$("#vendeur_prenom").text(data.data.vendeur_prenom);
				$("#vendeur_nom").text(data.data.vendeur_nom);
				$("#vendeur_courriel").text(data.data.vendeur_email);
				$("#vendeur_adresse").text(data.data.vendeur_adresse);
				$("#objet_description").html(data.data.objet_description);
				
				$("#bouton_presentation").prop("disabled", true);
				$("#bouton_features").prop("disabled", false);
				$("#acheteur_id").prop("disabled", false);
				$("#acheteur_id").prop("disabled", false);
				$("#partage_button").prop("disabled", false);
				
			}
			else {
				
				$("#annonce_titre").text("L'Annonce #" + id + " n'existe pas");
				clearAnnonceInfos();
				$("#bouton_presentation").prop("disabled", true);
				$("#bouton_features").prop("disabled", true);
				
			}
		}
	});
	
}

function clearAnnonceInfos() {
	
	$("#objet_nom").text("");
	$("#objet_prix").text("");
	$("#objet_qte").text("");
	$("#date_debut").text("");
	$("#date_fin").text("");
	$("#vendeur_prenom").text("");
	$("#vendeur_nom").text("");
	$("#vendeur_courriel").text("");
	$("#vendeur_adresse").text("");
	$("#objet_description").html("");
	
}

function getFeatures() {
	
	const id = $("#annonce_id").val();
	
	$.ajax({
		url : CALLBACK_CONNECTION_STRING + "/features/" + id,
		method : "GET",
		dataType : "json"
	}).done(function(data) {
		
		$("#annonce_info").hide();
		$("#annonce_features").show();
		
		$("#annonce_features").html("");
		
		data.data.forEach((row) => {
			
			var rowHTML = "<p><strong>" + row.feature_nom + ": </strong>" + row.feature_valeur + "</p>";
			
			$("#annonce_features").append(rowHTML);
			$("#bouton_presentation").prop("disabled", false);
			$("#bouton_features").prop("disabled", true);
			
		});
		
	});
	
}

function addUser(ev) {
	
	ev.preventDefault();
	
	const prenom = $("#utilisateur_prenom").val();
	const nom = $("#utilisateur_nom").val();
	const email = $("#utilisateur_courriel").val();
	const adresse = $("#utilisateur_adresse").val();
	const preference = $("#utilisateur_preference").val();
	
	$.ajax({
		type: "POST",
		url: CALLBACK_CONNECTION_STRING + "/utilisateur",
		data: {"prenom":prenom,"nom":nom,"email":email,"adresse":adresse,"preference":preference},
		dataType: "json",
		error: (response) => { $("#feedback").text("L'utilisateur n'a pas pu être créé."); }
	}).done((data) => {
			
		if(data.hasOwnProperty('errCode') && data.hasOwnProperty('data')) {
			
			if(data.errCode == 0) {
				
				$("#utilisateur_prenom").val("");
				$("#utilisateur_nom").val("");
				$("#utilisateur_courriel").val("");
				$("#utilisateur_adresse").val("");
				
				$("#feedback").text("L'utilisateur a été créé avec succès.");
				
			}
			else {

				$("#feedback").text("L'utilisateur n'a pas pu être créé.");
				
			}
		
		}
	});
	
}

function addAd(ev) {
	
	ev.preventDefault();
	
	const vendeurID = $("#vendeur_id").val();
	const objet_nom = $("#objet_nom").val();
	const objet_categorie = $("#objet_categorie").val();
	const objet_qte = $("#objet_qte").val();
	const objet_prix = $("#objet_prix").val();
	const annonce_date_fin = $("#annonce_date_fin").val();
	const objet_description = $("#objet_description").val();
	
	$.ajax({
		type: "POST",
		url: CALLBACK_CONNECTION_STRING + "/ad",
		data: {"objet_description":objet_description,"vendeur_id":vendeurID,"objet_nom":objet_nom,"objet_categorie":objet_categorie,"objet_qte":objet_qte, "objet_prix":objet_prix, "annonce_date_fin":annonce_date_fin},
		dataType: "json",
		success: (data) => {
		
			if(data.hasOwnProperty('errCode') && data.hasOwnProperty('data')) {
				
				$("#objet_nom").val("");
				$("#objet_categorie").val("");
				$("#objet_qte").val("");
				$("#objet_prix").val("");
				$("#annonce_date_fin").val("");
				$("#objet_description").val("");
				
				if(data.errCode == 0) {
					
					$("#feedback").text("L'annonce a été créée avec succès.");
					
				}
				else {
					
					$("#feedback").text("L'annonce n'a pas pu être créée.");
					
				}
			
			}
			
		}
	});
	
}

function addPartage() {
	
	const annonce_id = $("#annonce_id").val();
	const acheteur_id = $("#acheteur_id").val();
	
	$.ajax({
		type: "POST",
		url: CALLBACK_CONNECTION_STRING + "/partage",
		data: {"annonce_id":annonce_id, "acheteur_id":acheteur_id},
		dataType: "json",
		success: (data) => {
		
			if(data.hasOwnProperty('errCode') && data.hasOwnProperty('data')) {
				
				if(data.errCode == 0) {
					
					$("#feedback").text("Le partage a été effectué avec succès.");
					
				}
				else {
					
					$("#feedback").text("Le partage n'a pas été effectué avec succès.");
					
				}
			
			}
		
		}
	});
	
}

/*obtient les objets selon les choix dans le filtre et les affichent dans l'accordion.*/
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

/*fonction recursive qui remplit le dropdown categorie dans la barre de navigation.*/
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
/* remplit le select du filtre.*/
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

/*Vide l'accordion et remplit selon le filtre*/
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
/*creer une carte de l'accordion et la remplit avec les données + features d'un objet*/
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
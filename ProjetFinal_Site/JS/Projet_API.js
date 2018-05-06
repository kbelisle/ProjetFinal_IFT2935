var CALLBACK_CONNECTION_STRING = "http://localhost:8132";

/*Page onload*/
$(document).ready(function() {
 $('.panel-collapse').on('show.bs.collapse', function () {
    $('#filtreIcon').removeClass('fa-chevron-up');
	$('#filtreIcon').addClass('fa-chevron-down');
  });

  $('.panel-collapse').on('hide.bs.collapse', function () {
    $('#filtreIcon').addClass('fa-chevron-up');
	$('#filtreIcon').removeClass('fa-chevron-down');
  });
});
/*searchobjet
loadMenu(data.data,1,0,$('#parentDropDown'));
BindNavMenu();
loadFiltre(data.data);
*/
/*obtient les categories ordonnés et les ajoutent au menu categorie dans la barre de navigation et dans le select du filtre.*/
function getAllCategories(callbackFunction) {
	$.ajax({
		url : CALLBACK_CONNECTION_STRING + "/categorie",
		method: 'GET',
		dataType : 'json'
	}).done(function(data) {
		if(data.hasOwnProperty('errCode') && data.hasOwnProperty('data') && data.hasOwnProperty('errMsg')) {
		  if(data.errCode == 0) {
			if(typeof callbackFunction === 'function') {
			  callbackFunction(data.errCode,data.errMsg,data.data);
			}
		    /* Navbar related */
		    loadMenu(data.data,1,0,$('#parentDropDown'));
		    BindNavMenu();
		  }
		}
		else {
			if(typeof callbackFunction === 'function') {
			  callbackFunction("999","Invalid JSON Format",[]);
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
		if(data.hasOwnProperty('errCode') && data.hasOwnProperty('data')  && data.hasOwnProperty('errMsg')) {		
			if(data.errCode == 0) {
				data.data.forEach((row) => {
					selectionForm.append('<option value="' + row.ncat + '">' + row.ncat + '</option>');	
				});
			}
		}	
	});
}

function getAnnonceList(callbackFunction) {
	$.ajax({
		url : CALLBACK_CONNECTION_STRING + "/ad",
		method : "GET",
		dataType : "json"
	}).done(function(data) {
		if(data.hasOwnProperty('errCode') && data.hasOwnProperty('data')  && data.hasOwnProperty('errMsg')) {
			if(typeof callbackFunction === 'function') {
				callbackFunction(data.errCode,data.errMsg,data.data);
			} 
		}
		else {
			if(typeof callbackFunction === 'function') {
				callbackFunction("999","",[]);
			} 
		}
	});
}

function getAllUserIDs(callbackFunction) {
	
	$.ajax({
		url : CALLBACK_CONNECTION_STRING + "/utilisateur",
		method : "GET",
		dataType : "json"
	}).done(function(data) {
		if(data.hasOwnProperty('errCode') && data.hasOwnProperty('data')  && data.hasOwnProperty('errMsg')) {	
			if(data.errCode == 0) {
				if(typeof callbackFunction === 'function') {
				  callbackFunction(data.errCode,data.errMsg,data.data);
				}
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
		
		if(data.hasOwnProperty('errCode') && data.hasOwnProperty('data')  && data.hasOwnProperty('errMsg')) {
			
			if(data.errCode == 0) {
				
				console.log(data.data);
				
			}
			
		}
		
	});
	
}

function getPurchaseHistory() {
	
	const id = $("#acheteur_id").val(); 
	
	if (isNaN(id)) {
		/* Someone changed the html! */
		window.location.replace("index.html");
		return false;
	}
	
	$.ajax({
		url : CALLBACK_CONNECTION_STRING + "/purchases/" + id,
		method : "GET",
		dataType : "json"
	}).done(function(data) {
		
		if(data.hasOwnProperty('errCode') && data.hasOwnProperty('data')  && data.hasOwnProperty('errMsg')) {
			
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
	
	if (isNaN(id)) {
		/* Someone changed the html! */
		window.location.replace("index.html");
		return false;
	}
	
	$.ajax({
		url : CALLBACK_CONNECTION_STRING + "/sales/" + id,
		method : "GET",
		dataType : "json"
	}).done(function(data) {
		
		if(data.hasOwnProperty('errCode') && data.hasOwnProperty('data')  && data.hasOwnProperty('errMsg')) {
			
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

function getAnnonceByID(annonceID, callbackFunction) {
	$.ajax({
		url : CALLBACK_CONNECTION_STRING + "/ad/" + annonceID,
		method : "GET",
		dataType : "json"
	}).done(function(data) {
		if(data.hasOwnProperty('errCode') && data.hasOwnProperty('data')  && data.hasOwnProperty('errMsg')) {
			if(typeof callbackFunction === 'function') {
				callbackFunction(data.errCode,data.errMsg,data.data);
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

function getFeaturesByAnnonceID(annonceID,callbackFunction) {
	$.ajax({
		url : CALLBACK_CONNECTION_STRING + "/features/" + annonceID,
		method : "GET",
		dataType : "json"
	}).done(function(data) {
		if(data.hasOwnProperty('errCode') && data.hasOwnProperty('data')  && data.hasOwnProperty('errMsg')) {
			if(typeof callbackFunction === 'function') {
				callbackFunction(data.errCode, data.errMsg, data.data);
			}
		}
		else {
			if(typeof callbackFunction === 'function') {
				callbackFunction("999", "Invalid JSON on response", []);
			}
		}
	});
	
}

function addUser(prenom,nom,email,adresse,preference,callbackFunction) {
	$.ajax({
		type: "POST",
		url: CALLBACK_CONNECTION_STRING + "/utilisateur",
		data: {"prenom":prenom,"nom":nom,"email":email,"adresse":adresse,"preference":preference},
		dataType: "json",
	}).done((data) => {	
		if(data.hasOwnProperty('errCode') && data.hasOwnProperty('data')  && data.hasOwnProperty('errMsg')) {
			if(typeof callbackFunction === 'function') {
				callbackFunction(data.errCode,data.errMsg,data.data);
			}
		}
		else {
			if(typeof callbackFunction === 'function') {
				callbackFunction("999","Invalid JSON Format",[]);
			}
		}
	});
}

function addAd(vendeurID, objNom, objCat, objQte, objPrix, dateFin, objDesc, callbackFunction) {
	$.ajax({
		type: "POST",
		url: CALLBACK_CONNECTION_STRING + "/ad",
		data: {"objet_description":objDesc,"vendeur_id":vendeurID,"objet_nom":objNom,"objet_categorie":objCat,"objet_qte":objQte, "objet_prix":objPrix, "annonce_date_fin":dateFin},
		dataType: "json",
		success: (data) => {
			if(data.hasOwnProperty('errCode') && data.hasOwnProperty('data') && data.hasOwnProperty('errMsg')) {
				if (typeof callbackFunction === 'function') 
					callbackFunction(data.errCode, data.errMsg, data.data);
			}
			else {
				if(typeof callbackFunction === 'function') {
					callbackFunction("999","Invalid JSON Format",[]);
				}
			}
		}
	});
	
}

function addPartage(annonceID, acheteurID, callbackFunction) {
	$.ajax({
		type: "POST",
		url: CALLBACK_CONNECTION_STRING + "/partage",
		data: {"annonce_id":annonceID, "acheteur_id":acheteurID},
		dataType: "json",
		done: (data) => {
			if(data.hasOwnProperty('errCode') && data.hasOwnProperty('data') && data.hasOwnProperty('errMsg')) {
				if(typeof callbackFunction === 'function') {
					callbackFunction(data.errCode,data.errMsg,data.data);
				}
			}
			else {
				if(typeof callbackFunction === 'function') {
					callbackFunction("999","Invalid JSON Format",[]);
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
		if(data.hasOwnProperty('errCode') && data.hasOwnProperty('data')  && data.hasOwnProperty('errMsg')) {
		  if(data.errCode == 0) {
			loadObjetList(data.data);
		  }
		}
		else {
			/*if(typeof callbackFunction === 'function') {
				callbackFunction("999","Invalid JSON Format",[]);
			}*/
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
		.attr('href','annonce.html?categorie=' + categories[i].ncat)
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

/*!
 * Bootstrap 4 multi dropdown navbar ( https://bootstrapthemes.co/demo/resource/bootstrap-4-multi-dropdown-navbar/ )
 * Copyright 2017.
 * Licensed under the GPL license
 */


function BindNavMenu() {
    $( '.dropdown-menu a.dropdown-toggle' ).on( 'mouseenter', function ( e ) {
        var $el = $( this );
        var $parent = $( this ).offsetParent( ".dropdown-menu" );
        if ( !$( this ).next().hasClass( 'show' ) ) {
            $( this ).parents( '.dropdown-menu' ).first().find( '.show' ).removeClass( "show" );
        }
        var $subMenu = $( this ).next( ".dropdown-menu" );
        $subMenu.toggleClass( 'show' );
        
        $( this ).parent( "li" ).toggleClass( 'show' );

        $( this ).parents( 'li.nav-item.dropdown.show' ).on( 'hidden.bs.dropdown', function ( e ) {
            $( '.dropdown-menu .show' ).removeClass( "show" );
        } );
        
         if ( !$parent.parent().hasClass( 'navbar-nav' ) ) {
            $el.next().css( { "top": $el[0].offsetTop, "left": $parent.outerWidth() - 4 } );
        }

        return false;
    } );
} 
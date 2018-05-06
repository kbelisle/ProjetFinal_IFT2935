$(document).ready(function() {
	getAnnonceList(AfterAnnonceListRetrieve);
	getAllUserIDs(AfterUserListRetrieve);
	getAllCategories();
	$('#annonce_id').on('change', onAnnonceChange);
});

function AfterUserListRetrieve(errCode,errMsg,data) {
	data.forEach((row) => {
		$('#acheteur_id').append($("<option>").val(row.iduser).text(row.iduser + " - " + row.prenom + " " + row.nom));
	});
	$('#acheteur_id').val([]);
	$('#acheteur_id').on('change', function (){
		$('#partage_button').removeAttr('disabled');
	});
}

function AfterAnnonceListRetrieve(errCode,errMsg,data) {
	data.forEach((row) => {			
		$('#annonce_id').append('<option value="' + row.idannonce + '">' + row.idannonce + '</option>');	
	});
	$('#annonce_id').val([]);
}

function onAnnonceChange(event) {
	var annonce_select = $('#annonce_id');
	annonce_select.attr('disabled', 'true');
	var selectedID = annonce_select.val();
	
	if (isNaN(selectedID)) {
		/* Someone changed the html! */
		window.location.replace("index.html");
		return false;
	}
	
	getAnnonceByID(selectedID, AfterAnnonceByIDRetrieve);
	getFeaturesByAnnonceID(selectedID,AfterFeatureListRetrieve);
}

function AfterAnnonceByIDRetrieve(errCode,errMsg,data) {
	if(errCode == "0") {
		$("#annonce_features").hide();
		$("#annonce_info").show();
		
		$("#annonce_titre").text('Annonce #' + data.annonce_id);
		$("#objet_nom").text(data.objet_nom);
		$("#objet_prix").text(data.prix);
		$("#objet_qte").text(data.qte);
		$("#date_debut").text(data.date_debut);
		$("#date_fin").text(data.date_fin);
		$("#vendeur_prenom").text(data.vendeur_prenom);
		$("#vendeur_nom").text(data.vendeur_nom);
		$("#vendeur_courriel").text(data.vendeur_email);
		$("#vendeur_adresse").text(data.vendeur_adresse);
		$("#objet_description").html(data.objet_description);
		
		showAnnonce();
		
		$('#acheteur_id').removeAttr('disabled');
		
	}
	else {
		$('#feedback').text("Une erreur s'est lors de l'obtention de l'annonce : " + errMsg);
	}
	$('#annonce_id').removeAttr('disabled');
}

function addPartageClick() {
	const annonceID = $('#annonce_id').val();
	const acheteurID = $('#acheteur_id').val();
	
	if(isNaN(annonceID) || isNaN(acheteurID)) {
		/* HTML modifié */
		window.location.replace("index.html");
		return false;
	}
	
	addPartage(annonceID,acheteurID,AfterAddPartage);
}

function AfterAddPartage(errCode,errMsg,data) {
	if(errCode == "0") {
		$('#feedback').text('Le partage a été ajouté');
		$('#acheteur_id').val([]);
	}
	else {
		$('#feedback').text("Une erreur s'est produite lors de l'ajout du partage : " + errMsg);
	}
}

function AfterFeatureListRetrieve(errCode,errMsg,data) {
	if(errCode == "0") {
		data.forEach((row) => {
			var p = $('<p>').html('<strong>' + row.feature_nom + '</strong> : ' + row.feature_valeur);
			p.appendTo($('#annonce_features'));
		});
	}
	else {
		$('#annonce_features').text("Une erreur est survenue lors de l'obtention des features : " + errMsg);
	}

}

function showAnnonce() {
	$("#annonce_features").hide();
	$("#annonce_info").show();
	$('#bouton_features').removeAttr('disabled');
	$('#bouton_presentation').attr('disabled','true');
}

function showFeature() {
	$("#annonce_features").show();
	$("#annonce_info").hide();
	$('#bouton_presentation').removeAttr('disabled');
	$('#bouton_features').attr('disabled','true');
}
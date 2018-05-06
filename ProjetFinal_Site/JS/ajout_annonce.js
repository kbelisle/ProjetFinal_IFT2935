$(document).ready(function () {
	getAllCategories(AfterCategorieRetrieve);
	getAllUserIDs(AfterUserListRetrieve);
	$("#create_ad_form").submit(validateAd);
});

function validateAd(event) {
	event.preventDefault();
	event.stopPropagation();
	
	const vendeurID = $("#vendeur_id").val();
	const objet_nom = $("#objet_nom").val();
	const objet_categorie = $("#objet_categorie").val();
	const objet_qte = $("#objet_qte").val();
	const objet_prix = $("#objet_prix").val();
	const annonce_date_fin = $("#annonce_date_fin").val();
	const objet_description = $("#objet_description").val();
	
	/*Clear is-invalid*/
	$(".form-control.is-invalid").removeClass('is-invalid');
	
	var valid = true;
	
	if(vendeurID === null) {
		valid = false;
		$("#vendeur_id").addClass("is-invalid");
	}
	if(objet_nom === "") {
		valid = false;
		$("#objet_nom").addClass("is-invalid");
	}
	if(objet_categorie === null) {
		valid = false;
		$("#objet_categorie").addClass("is-invalid");
	}
	if(objet_qte === "" || objet_qte < 0) {
		valid = false;
		$("#objet_qte").addClass("is-invalid");
	}
	if(objet_prix === "" || objet_prix < 0) {
		valid = false;
		$("#objet_prix").addClass("is-invalid");
	}
	
	if(valid) {
		if(typeof addAd === 'function') {
			addAd(vendeurID, objet_nom, objet_categorie, objet_qte, objet_prix, annonce_date_fin, objet_description, AfterAddAd);
		}
	}
}

function AfterAddAd(errCode, errMsg, data) {
	if(errCode == '0') {
		/* Sucess*/
		$('#feedback').html("L'annonce a été ajoutée."); 
		$("#vendeur_id").val([]);
		$("#objet_nom").val('');
		$("#objet_categorie").val('');
		$("#objet_qte").val('');
		$("#objet_prix").val('');
		$("#annonce_date_fin").val('');
		$("#objet_description").val('');
	}
	else {
		/* Failed */
		$('#feedback').html("Une erreur s'est produite. Message : " + errMsg);
	}
}

function AfterCategorieRetrieve(errCode, errMsg, data) {
	data.forEach((row) => {
		var dash = '';
		for (var i = 0; i < row.niveau - 1; i++) {
			dash += "--";
		}
		$("#objet_categorie").append('<option value="' + row.ncat + '">' + dash + row.ncat + '</option>');
	});
	$("#objet_categorie").val([]);
}

function AfterUserListRetrieve(errCode, errMsg, data) {
	data.forEach((row) => {
		$("#vendeur_id").append('<option value="' + row.iduser + '">' + row.iduser  + ' - ' + row.prenom + ' ' + row.nom + '</option>');
	});	
	$("#vendeur_id").val([]);
}
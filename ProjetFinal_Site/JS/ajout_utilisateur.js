$(document).ready(function () {
	getAllCategories(AfterCategorieRetrieve);
	$("#create_user_form").submit(validateUser);
});

function AfterCategorieRetrieve(errCode,errMsg,data) {
	if(errCode == "0") {
		data.forEach((row) => {
			var dash = '';
			for (var i = 0; i < row.niveau - 1; i++) {
				dash += "--";
			}
			$("#utilisateur_preference").append('<option value="' + row.ncat + '">' + dash + row.ncat + '</option>');
		});
		$("#utilisateur_preference").val([]);
	}
	else {
		$("#feedback").text('Erreur survenue : ' + errMsg);
	}
}

function validateUser(event) {
	event.preventDefault();
	event.stopPropagation();
	
	const prenom = $("#utilisateur_prenom").val();
	const nom = $("#utilisateur_nom").val();
	const email = $("#utilisateur_courriel").val();
	const adresse = $("#utilisateur_adresse").val();
	const preference = $("#utilisateur_preference").val();
	
	/* TODO : VALIDATION */
	/* Pour activer le message d'erreur 
		input.addClass('is-invalid');
		ex : $("#utilisateur_prenom").addClass('is-invalid');
	*/
	/*Clear is-invalid*/
	$(".form-control.is-invalid").removeClass('is-invalid');
	var valid = true;
	
	if(valid) {
		/*Valid*/
		addUser(prenom,nom,email,adresse,preference,AfterUserAdd);
	}
	else {
		/*Invalid*/
		
	}
	return valid;
}

function AfterUserAdd(errCode,errMsg,data) {
	if(errCode == "0") {
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
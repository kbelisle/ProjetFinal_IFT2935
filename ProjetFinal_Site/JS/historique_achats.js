$(document).ready(function () {
	getAllCategories();
	getAllUserIDs(AfterUserListRetrieve);
});

function AfterUserListRetrieve(errCode,errMsg,data) {
	data.forEach((row) => {
		$('#acheteur_id').append($("<option>").val(row.iduser).text(row.iduser + " - " + row.prenom + " " + row.nom));
	});
	$('#acheteur_id').val([]);
}
$(document).ready(function () {
	getAllCategories();
	getAllUserIDs(AfterUserListRetrieve);
});

function AfterUserListRetrieve(errCode,errMsg,data) {
	data.forEach((row) => {
		$('#vendeur_id').append($("<option>").val(row.iduser).text(row.iduser + " - " + row.prenom + " " + row.nom));
	});
	$('#vendeur_id').val([]);
}
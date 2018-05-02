var CALLBACK_CONNECTION_STRING = "http://localhost:8132";

function getAllCategories() {
	$.ajax({
		url : CALLBACK_CONNECTION_STRING + "/categorie",
		method: 'GET',
		dataType : 'json'
	}).done(function(data) {
		alert(JSON.stringify(data, null, 2));
	})
}
getAllCategories();
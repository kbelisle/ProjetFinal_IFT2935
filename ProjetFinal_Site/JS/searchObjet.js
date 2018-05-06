$(document).ready(function() {
	getAllCategories(loadFiltre);
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
	}

}
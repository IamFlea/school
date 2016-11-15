/**
 * Create a dynamic table.
 * @param `id` class id of the table 
 */
function dynamicTable(id) {
	var table = document.getElementById(id); // get Table from DOM 
	var new_row = table.insertRow(0);        // insert new row into table
	// Fill new row with columns. 
	for (var i = 0; i < table.rows[1].cells.length; i++) {
		var cellNew = new_row.insertCell(i);
		var att = cellNew.setAttribute("class", "dynamic_header_col"+i);
		cellNew.innerHTML = "<input type=\"text\" onchange=\"filter('"+id+"');\" class=\"dynamic_textfield\"  />" + "<span onclick=\"sort('"+id+"','"+i+"', 0)\" class=\"dynamic_ASCfield\">ASC</span>"+ " <span onclick=\"sort('"+id+"','"+i+"', 1)\" class=\"dynamic_DESCfield\">DESC</span>";
	}
}

/**
 * Filter unwanted things from a table
 * @param `id` class id of the table 
 */
function filter(id) {
	var table = document.getElementById(id);
	// If first row contains <th>, do not filter it
	var starting_idx;

	if(table.rows[1].getElementsByTagName('th').length != 0) { // First row contains <th>s
		starting_idx = 2;
	} else {
		starting_idx = 1;
	}

	for(var i = starting_idx; i < table.rows.length; i++) {
		var hide = false;
		for(var j = 0; j < table.rows[0].cells.length; j++){
			var hodnota_sloupce = table.rows[0].cells[j].childNodes[0].value;
			if(table.rows[i].cells[j].innerHTML.indexOf(hodnota_sloupce) === -1){
				hide=true;
				break;
			}
		}
		if(hide) {
			table.rows[i].style.setProperty('display','none');
		} else {
			table.rows[i].style.removeProperty('display');
		}
	}

	var x = table.getElementsByTagName("tfoot")
	for(var i = 0; i < x.length; i++){
		for(var j = 0; j < x[i].rows.length; j++){
			x[i].rows[j].style.removeProperty('display');
		}
	}
}
/**
 * Sort table
 * @param `id` class id of the table 
 * @param `col` which column
 * @param `desc` if 0 then sort from A to Z
 */
function sort(id, col, desc){
	var starting_idx;
	var table = document.getElementById(id);
	// Preskoc prvni radek ktery ma hodnoty <th>
	if(table.rows[1].getElementsByTagName('th').length != 0) { 
		starting_idx = 2;
	} else {
		starting_idx = 1;
	}

	var x = table.getElementsByTagName("tfoot")
	var v = Array();
	for(var i = 0; i < x.length; i++){
		v[i] = x[i].innerHTML;
		console.log(v[i])
		table.removeChild(x[i]);
		console.log(v[i])
	}

	var krpole = Array(); // dvojpole ve stzlu: [[nazev,html][nazev,html]]
	for(var i = starting_idx; i < table.rows.length; i++){
		krpole[i] = Array();
		krpole[i][0] = table.rows[i].cells[col].innerHTML;
		krpole[i][1] = table.rows[i].innerHTML;

	}

	// Porovnani na numericke hodnoty.
	if(table.rows[1].cells[col].className.split(" ").indexOf("numerical") == 0) {
		if(desc == 0) {
			krpole.sort(function(a,b){return a[0]-b[0];});
		} else {
			krpole.sort(function(a,b){return b[0]-a[0];});
		}
	}else{
		if(desc == 0) {
			krpole.sort(function(a,b){return a[0].localeCompare(b[0]);});
		} else {
			krpole.sort(function(a,b){return b[0].localeCompare(a[0]);});            
		}

	}

	// Uloz porovnane hodnotz
	for(var i = starting_idx; i < table.rows.length; i++){
		table.rows[i].innerHTML=  krpole[i - starting_idx][1] ;
	}

	var str = "";
	for(var i = 0; i < v.length; i++){
		str += v[i];
	}
	var footer = table.createTFoot();
	footer.innerHTML = str;
	// Prefiltruj znova
	filter(id);
}

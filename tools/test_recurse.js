/*
 Recurse directories
 @author: Collin Bode
 @date: 2018-10-06
 Purpose: walk through directory structure and return files and filepaths according to search criteria

*/

fs = require("fs")
tr = require("./transform_functions.js")
//path = require("path")
/*
function recurse_dir(dir,filepath_list,regex) {
	fs = require("fs")
	path = require("path")
	fs.readdirSync(dir).forEach(file => {
		let fullPath = path.join(dir, file)
		if (fs.lstatSync(fullPath).isDirectory()) {
	    recurse_dir(fullPath,filepath_list,regex)
	  } else {
	  	if(regex == "") {
		  	filepath_list.push([dir,file])
		  } else if(regex.test(file)) {
		  	filepath_list.push([dir,file])
		  }
	  }  
	})
}
*/

start_path = '/Users/collin/git/migrate-sensor-db-metadata/data/migration3-incidents/ucnrs/'
filepath_list = []
tr.recurse_dir(start_path,filepath_list,RegExp(/^precip((?!seasonal).)*$/i))
console.log("Traverse complete.")
filepath_list.forEach(set => {
	dir = set[0]
	file = set[1]
	console.log(file)
})
//console.log(filepath_list)

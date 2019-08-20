/*
Seasonal Datastreams - disable
Purpose: seasonal datastreams are causing problems with current dashboard downloads.  
make them invisible for now. 
*/

fs = require("fs")
tr = require("./transform_functions.js")
path = require("path")

// parameters
path_root = "../compost/deprecated_datastreams/Seasonal/"

// Loop through all Datastreams in org
ds_path_list = []
tr.recurse_dir(path_root,ds_path_list,RegExp(/datastream.json$/i))
for (var k=0;k<ds_path_list.length;k++) {
	ds_filename = ds_path_list[k][1]
	ds_path = ds_path_list[k][0]
	
	// load json, match name to station name part, and remove
	ds_json = JSON.parse(fs.readFileSync(ds_path+ds_filename))			
	console.log(ds_json.name,"enabled:",ds_json.enabled)
	ds_json.enabled = false
	console.log(ds_json.name,"enabled:",ds_json.enabled)
	// Write back to file
	ds_json_string = JSON.stringify(ds_json,null,2)
	fs.writeFileSync(ds_path+ds_filename,ds_json_string,'utf-8')
	console.log("Exported:",ds_path+ds_filename)
}

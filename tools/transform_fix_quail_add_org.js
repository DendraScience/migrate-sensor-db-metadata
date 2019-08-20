/*
	Quail Ridge Datastreams were hand crafted. Need modification
	Add organization_id to all of them.
	"_id": "5a37e71ba546db0001547681",
	"organization_id": ""
*/

fs = require("fs")
tr = require("./transform_functions.js")
ds_path = "../data/ucnrs/station/quail-ridge/" 
ds_files = fs.readdirSync(ds_path)
orgid = "58db17c424dc720001671378"

// Loop through Datastream JSON files 
for(var i=0;i<ds_files.length;i++) {
	ds_filename = ds_files[i]
	if (ds_filename.match(/datastream.json$/) && ds_filename.match(/Quail/)) {
		ds_json = JSON.parse(fs.readFileSync(ds_path+ds_filename))
		ds_json.organization_id = orgid

		// Write to file
		ds_json_string = JSON.stringify(ds_json,null,2)
		console.log("Processed!",ds_json.name)
		//console.log("\tFile:",ds_filename)
		fs.writeFileSync(ds_path+ds_filename,ds_json_string,'utf-8')
	} else {
		console.log("NOT Datastream:",ds_filename)
	}
} 

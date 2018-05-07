/*
	ERCZO datastreams never had character cleaning like the UCNRS did.
	Influx doesn't like things like (). 

*/

fs = require("fs")
tr = require("./transform_functions.js")
ds_path = "../data/migration2.1-rivendell/erczo/datastream/" 
ds_files = fs.readdirSync(ds_path)


// Loop through Datastream JSON files 
for(var i=0;i<ds_files.length;i++) {
	ds_filename = ds_files[i]
	if (ds_filename.match(/.json$/)) {
		ds_json = JSON.parse(fs.readFileSync(ds_path+ds_filename))

		if(ds_json.datapoints_config.length > 2) {
			console.log("OMG! ",ds_json.name,"has too many configs!!")
		}

		if(ds_json.datapoints_config.length == 2) {
			//console.log(ds_json.name,"config count:",ds_json.datapoints_config.length)
			// Pull existing values
		  ds_json.datapoints_config.splice(1)
		  //console.log(ds_json.name,"config count:",ds_json.datapoints_config.length)
		}
		console.log(ds_json.name,",",ds_json._id)
		// Write to file
		ds_json_string = JSON.stringify(ds_json,null,2)
		//fs.writeFileSync(ds_path+ds_filename,ds_json_string,'utf-8')
	} else {
		//console.log("NOT QUAIL!!!",ds_filename)
	}
} 

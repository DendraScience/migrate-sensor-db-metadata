/*
	ERCZO datastreams never had character cleaning like the UCNRS did.
	Influx doesn't like things like (). 

  current:
  "params": {
    "query": {
      "api": "erczo",
      "db": "station_rul3_2_cr1000",
      "fc": "source_table302",
      "sc": "\"time\", \"SoilTL3_(1)\"",
      "utc_offset": -28800,
      "coalesce": false
    }
.replace(/\W/g, '_')

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
			console.log(ds_json.name)
			// Pull existing values
			dpc = ds_json.datapoints_config[1]
			db = dpc.params.query.db
			fc = dpc.params.query.fc
			sc = dpc.params.query.sc
			console.log("\t db:",db,", fc:",fc,", sc:",sc) 

			field1 = sc.split(",")[1].replace("\"","").replace("\"","").replace(" ","")
			field1 = field1.replace(/\W/g, '_')
			nsc = "\"time\", \""+field1+"\""
			ds_json.datapoints_config[1].params.query.sc = nsc
			console.log("\t sc:",sc," nsc:",nsc)		
		}
		// Write to file
		ds_json_string = JSON.stringify(ds_json,null,2)
		fs.writeFileSync(ds_path+ds_filename,ds_json_string,'utf-8')
	} else {
		//console.log("NOT QUAIL!!!",ds_filename)
	}
} 

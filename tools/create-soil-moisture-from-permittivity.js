/* 
Add Measurement to tags for all datastreams
Uses list all method variable pairs from datastreams
*/

fs = require("fs")
tr = require("./transform_functions.js")
path = require("path")

// parameters
path_root = "/Users/collin/git/migrate-sensor-db-metadata/data/erczo/station/rivendell-level-61-ws/"
	
// Loop through all Datastreams in station directory
ds_path_list = []
tr.recurse_dir(path_root,ds_path_list,RegExp(/datastream.json$/i))
for (var k=0;k<ds_path_list.length;k++) {
	// Get each Datastream and load its json
	ds_filename = ds_path_list[k][1]
	ds_path = ds_path_list[k][0]
	ds_json = JSON.parse(fs.readFileSync(ds_path+ds_filename))

	// Ignore Disabled Datastreams
	if(ds_json.enabled == false) {
		console.log("\t",k,ds_filename,"enabled:",ds_json.enabled,"skipping...")
		continue
	}

	// Get tags
	//console.log("\n",k,ds_filename,ds_json.name)
	medium = tr.get_tag(ds_json,"Medium").replace("ds_Medium_","")
	variable = tr.get_tag(ds_json,"Variable").replace("ds_Variable_","")
	units = tr.get_tag(ds_json,"Unit").replace("dt_Unit_","")
	aggregate = tr.get_tag(ds_json,"Aggregate")
	if(typeof aggregate !== 'undefined') {
		aggregate = aggregate.replace("ds_Aggregate_","")
	} else {
		aggregate = ""
	}
	purpose = tr.get_tag(ds_json,"DataPurpose")
	if(typeof purpose !== 'undefined') {
		purpose = purpose.replace("dq_DataPurpose_","")
	} else {
		purpose = ""
	}
	
	// Ignore anything that is not Permittivity
	if(variable != "Permittivity" || aggregate == "") {
		continue
	}
	console.log(k,ds_filename,"tags:",medium,variable,units,aggregate,purpose)

	// Modify JSON
	// Get Name, Change to Soil Moisture Percent 
	// Soil Permittivity p6avg
	// WS3 30cm Soil Permittivity Avg
	console.log("\t old name:",ds_json.name)
	ds_json.name = ds_json.name.replace("Permittivity","Moisture")
	ds_json.name = ds_json.name.replace("Moisture p","Moisture Probe ")
	ds_json.name = ds_json.name.replace("avg"," Avg")
	ds_json.name = ds_json.name.replace(" Avg"," Percent Avg")
	console.log("\t new name:",ds_json.name)

	// Get Field Name, Transform into Topp equation
	sc = ds_json.datapoints_config[0].params.query.sc
	console.log("\t sc:",sc)
	field = sc.split(",")[1].replace('"','').replace('"','')
	soil_moisture = "100.0 * (-0.053 + (0.0292 * XXX) - (0.00055 * XXX * XXX) + (0.0000042999999999999995 * XXX * XXX * XXX))"
	soil_moisture = soil_moisture.replace(/XXX/g,field)
	//console.log("\t soil_moisture:",soil_moisture)
	ds_json.datapoints_config[0].params.query.sc = "\"time\", "+soil_moisture
	console.log("\t new sc:",ds_json.datapoints_config[0].params.query.sc)

	// Create new filename 
	ds_filename_new = ds_filename.replace("_p_","_soilmoist_")
	console.log("\t old file:",ds_filename)
	console.log("\t new file:",ds_filename_new)

	// Change Unit to Percent
	// Update Datastream JSON, add dq measurement and dq data-purpose
	if(typeof ds_json.tags === 'undefined') {
		if(typeof ds_json.terms.dq === 'undefined') {
			ds_json.terms.dq = {}
		}
		delete ds_json.terms.ds.variable
		ds_json.terms.ds.Variable = "Moisture"
		ds_json.terms.dq.Measurement = "SoilMoisture"
		ds_json.terms.dq.Purpose = "ReadytoUse"
		ds_json.terms.dt.Unit = "Percent"
		console.log("\t ds_json.terms:"+JSON.stringify(ds_json.terms,null,2))
	} else {
		ds_json.tags.push("dt_Unit_Percent")
		ds_json.tags.push("dq_Purpose_ReadytoUse")
		ds_json.tags.push("dq_Measurement_SoilMoisture")
		ds_json.tags.push("ds_Variable_Moisture")
		console.log("\t ds_json.tags:"+JSON.stringify(ds_json.tags,null,2))
	}

	// Reference original Permittivity Datastream
	p_ref = {
		"identifier":ds_json._id,
		"type": "derived_from_datastream_id"
	}
	ds_json.external_refs.push(p_ref)

	// Remove Permittivity Datastream ID
	delete ds_json._id

	// Write datastream back to file
	ds_json_string = JSON.stringify(ds_json,null,2)
	fs.writeFileSync(ds_path+ds_filename_new,ds_json_string,'utf-8')
	console.log("\t",k,ds_filename_new)
	console.log(ds_path+ds_filename_new)
  
} // datastream
console.log("DONE")

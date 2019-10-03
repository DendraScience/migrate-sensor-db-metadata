/* 
Soil Moisture has percent as units. Change to VolumetricWaterContent.
*/

fs = require("fs")
tr = require("./transform_functions.js")
path = require("path")

// parameters
path_root = "/Users/collin/git/migrate-sensor-db-metadata/data/erczo/station/"
sm = 0 // soil moisture count

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
	measurement = tr.get_tag(ds_json,"Measurement")
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

	
	// Ignore anything that is not SoilMoisture Measurement
	if(measurement != "SoilMoisture" && units != "Percent") {
		continue
	}

	if(measurement == "SoilMoisture" && units != "Percent" && units != "VolumetricWaterContent") {
		console.log(k,sm,"PROBLEM! SOIL MOISTURE ONLY:",ds_filename,"tags:",measurement,medium,variable,units,aggregate,purpose)	
	} else if (measurement != "SoilMoisture" && units == "Percent")  {
		console.log(k,sm,"PROBLEM! PERCENT ONLY:",ds_filename,"tags:",measurement,medium,variable,units,aggregate,purpose)	
	} else if (measurement != "SoilMoisture" && units == "VolumetricWaterContent") {
		sm += 1
		console.log(k,sm,"\t",ds_filename,"tags:",measurement,medium,variable,units,aggregate,purpose)
	}
	
	/*
	// Accidentally changed units on RelativeHumidity. Changed them back with snippet below
	rg_humid = new RegExp("humidity",'i')
	if(rg_humid.test(ds_json.name)) { 
		console.log(k,sm,"Humid:",ds_filename,"tags:",measurement,medium,variable,units,aggregate,purpose)
	}
	if(measurement == "RelativeHumidity" && units == "VolumetricWaterContent") {
		console.log(k,sm,"PROBLEM!:",ds_filename,"tags:",measurement,medium,variable,units,aggregate,purpose)	
	} else {
		continue
	}
	*/

	// Modify JSON
	// Change Unit from Percent to VolumetricWaterContent
	if(typeof ds_json.tags === 'undefined') {
		ds_json.terms.dt.Unit = "VolumetricWaterContent"
		//ds_json.terms.dt.Unit = "Percent"
		//console.log("\t ds_json.terms:"+JSON.stringify(ds_json.terms,null,2))
	}
	/*
	else {
		ds_json.tags.push("dt_Unit_VolumetricWaterContent")
		console.log("\t ds_json.tags:"+JSON.stringify(ds_json.tags,null,2))
	}
	*/

	// Write datastream back to file
	ds_json_string = JSON.stringify(ds_json,null,2)
	//fs.writeFileSync(ds_path+ds_filename,ds_json_string,'utf-8')
	//oconsole.log("\t",k,sm,ds_filename)  //ds_path+ds_filename)
  
} // datastream
console.log("DONE")

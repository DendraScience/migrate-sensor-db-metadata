/* 
Add Measurement to tags for all datastreams
Uses list all method variable pairs from datastreams
*/

fs = require("fs")
tr = require("./transform_functions.js")
path = require("path")

// parameters
orgs = ["erczo"] //["erczo","ucnrs","chi"]
path_root = "../data/"
//path_root = "../compost/data/" // test path

// dq-measurement load as list
dq_path = "../data/common/vocabulary/dq-measurement.json"
dq_json = JSON.parse(fs.readFileSync(dq_path))
dq = dq_json.terms
console.log("listing measurements. dq_json length:",dq.length)

// store list as an array
medium_variable_unit_list = []

for (var i=0; i<orgs.length;i++) {
	org = orgs[i]
	org_path = path_root+org+"/station/"
	console.log(org_path)

	// Stations - Find
	station_path_list =[] 
	tr.recurse_dir(org_path,station_path_list,RegExp(/.station.json$/i))
	//console.log(station_path_list)
	console.log(org,'Datastream count:',station_path_list.length)

	// Loop through all stations in org
	for (var j=0;j<station_path_list.length;j++) {
		s_filename = station_path_list[j][1]
		s_path = station_path_list[j][0]
		s_json = JSON.parse(fs.readFileSync(s_path+s_filename))
		//sname_list[s_json.name] = [s_json.name,s_json.slug].  // used only with temporary export of station names
		console.log("\n",j,s_json.name,s_json.slug)
		
		// Loop through all Datastreams in station directory
		ds_path_list = []
		tr.recurse_dir(s_path,ds_path_list,RegExp(/datastream.json$/i))
		for (var k=0;k<ds_path_list.length;k++) {
			// Get each Datastream and load its json
			ds_filename = ds_path_list[k][1]
			ds_path = ds_path_list[k][0]
			ds_json = JSON.parse(fs.readFileSync(ds_path+ds_filename))

			// Get tags
			//console.log("\n",k,ds_filename,ds_json.name)
			medium = tr.get_tag(ds_json,"Medium").replace("ds_Medium_","")
			variable = tr.get_tag(ds_json,"Variable").replace("ds_Variable_","")
			units = tr.get_tag(ds_json,"Unit").replace("dt_Unit_","")
			//console.log(k,ds_filename,":",medium,variable,units)

			// Loop through dq-measurements and match medium-variable pair
			for (var q=0; q<dq.length;q++) {
				boo_medium = false
				boo_variable = false

				dqlabel = dq[q].label
				dqmedium =  dq[q].medium
				dqvariable = dq[q].variable
				dqmeasurement = dq[q].label
				//console.log(q,dqlabel,dqmedium,"=",dqmeasurement)

				if(medium == dqmedium) {
					boo_medium = true
				}
				if(variable == dqvariable) {
					boo_variable = true
				}
				if(boo_medium == true && boo_variable == true) {
					measurement = dqmeasurement
					//console.log("\t MATCH medium:",medium,"== dq:",dqmedium,"variable:",variable,"== dq:",dqvariable,"-->",measurement)
					//console.log("\t WE HAVE A WINNER!",measurement)
					break
				}
			}
			console.log(ds_json.name,measurement,medium,variable,units)
			medium_variable_unit_list.push([medium,variable,units,measurement,ds_json.name])

			// Update Datastream JSON, add dq measurement
			if(typeof ds_json.tags === 'undefined') {
				ds_json.terms.dq = {}
				ds_json.terms.dq.Measurement = measurement
				console.log("\t ds_json.terms:"+ds_json.terms)
			} else {
				ds_json.tags.push("dq_Measurement_"+measurement)
				console.log("\t ds_json.tags:"+ds_json.tags)
			}

			// Write datastream back to file
			ds_json_string = JSON.stringify(ds_json,null,2)
			fs.writeFileSync(ds_path+ds_filename,ds_json_string,'utf-8')
			console.log(ds_path+ds_filename)

		} // datastream
	} // station
} // org

//console.log(medium_variable_unit_list)
console.log("DONE")
//medium_variable_unit_list_string = JSON.stringify(medium_variable_unit_list,null,2)
//fs.writeFileSync('medium_variable_unit_measurement_list.json',medium_variable_unit_list_string,'utf-8')

/* 
Add Measurement to tags for all datastreams
Uses list all method variable pairs from datastreams
*/

fs = require("fs")
tr = require("./transform_functions.js")
path = require("path")

// parameters
boo_save = true
orgs = ["chi"] //["erczo","ucnrs","chi"]
path_root = "../data/"
//path_root = "../compost/data/" // test path
path_root = "/Users/collin/dendra_dev/dat2datastream/station/"

// dq-measurement load as list
dq_path = "../data/common/vocabulary/dq-measurement-full.vocabulary.json"
dq_json = JSON.parse(fs.readFileSync(dq_path))
dq = dq_json.terms
console.log("listing measurements. dq_json length:",dq.length)

// store list as an array
medium_variable_unit_list = []

for (var i=0; i<orgs.length;i++) {
	org = orgs[i]
	org_path = path_root+org+"/station/"
	org_path = path_root
	console.log("----------------------------")
	console.log(org_path)
	console.log("----------------------------")

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

			// Ignore Disabled Datastreams
			if(ds_json.enabled == false) {
				console.log("\t",k,ds_filename,"enabled:",ds_json.enabled,"skipping...")
				continue
			}

			// Get tags
			console.log("\n",k,ds_filename,ds_json.name)
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
			//console.log(k,ds_filename,"tags:",medium,variable,units,aggregate,purpose)

			// Loop through dq-measurements and match medium-variable pair
			for (var q=0; q<dq.length;q++) {
				boo_medium = false
				boo_variable = false
				boo_update_units = false
				measurement = ""

				dqlabel = dq[q].label
				dqmedium =  dq[q].medium
				dqvariable = dq[q].variable
				dqmeasurement = dq[q].label
				dqpurpose = dq[q].data_purpose
				//console.log(q,dqlabel,dqmedium,dqvariable)

				if(medium == dqmedium) {
					boo_medium = true
				}
				if(variable == dqvariable) {
					boo_variable = true
				}
				if(boo_medium == true && boo_variable == true) {
					measurement = dqmeasurement
					purpose = dqpurpose
					//console.log("\t MATCH medium:",medium,"== dq:",dqmedium,"variable:",variable,"== dq:",dqvariable,"-->",measurement,"purpose:",purpose)
					//console.log("\t WE HAVE A WINNER!",measurement)
					break
				}
			}

			// Some Checks
			if(typeof measurement === 'undefined' || measurement == "") {
				console.log("\t",k,ds_filename,"has NO MATCH for medium:",medium,"variable:",variable," Quitting...")
				process.exit()
			}
			if(typeof purpose === 'undefined') {
				console.log("\t",k,ds_filename,"has NO PURPOSE",purpose," Quitting...")
				process.exit()
			}

			// Exceptions
			// Fix Cumulative Rainfall
			if(measurement == "Rainfall" && aggregate == "Cumulative") {
				measurement = "RainfallCumulative"
				console.log("\t",k,"EXCEPTION: Total Rainfall.",ds_json.name)
			}

			// Fix VMS Water Pressure
			regex_fns = new RegExp('FNS Water Pressure B*')
			regex_vsp = new RegExp('VSP Water Pressure A*')
			if(medium == "Water" && variable == "Pressure") {
				if(regex_fns.test(ds_json.name) || regex_vsp.test(ds_json.name)) {
					console.log("\t",k,"EXCEPTION: VMS mislabelling. WellLevel --> WaterPressure",ds_json.name)
					measurement = "WaterPressure"
					purpose = "ReadytoUse"
				}
			}

			// Fix VMS Permittivity
			regex_nocalib = new RegExp('Permitivity no calib*')
			if(medium == "Rock" && variable == "DielectricStrength" && regex_nocalib.test(ds_json.name)) {
				measurement = "Permittivity"
				variable = "Permittivity"
				purpose = "Raw"
				console.log("\t",k,"EXCEPTION: VMS Permittivity no calibration.",ds_json.name)
			}

			// Fix VMS Permittivity
			regex_sleeve = new RegExp('Sleeve Elec Conductivity*')
			if(medium == "Rock" && variable == "Moisture" && regex_sleeve.test(ds_json.name)) {
				measurement = "ElectricalConductivity"
				variable = "ElectricalConductivity"
				purpose = "Raw"
				console.log("\t",k,"EXCEPTION: VMS Sleeve Electrical Conductivity.",ds_json.name)
			}

			// Fix ERPs
			regex_erp = new RegExp('ERP*')			
			if(medium == "Rock" && variable == "Moisture" && units == "Kiloohm" && regex_erp.test(ds_json.name)) {
				measurement = "Resistance"
				variable = "ElectricalResistance"
				purpose = "Raw"
				console.log("\t",k,"EXCEPTION: ERP SoilResistance.",ds_json.name)
			}

			// Fix Sap Temperature
			regex_sap = new RegExp('Sap Temperature*')			
			if(medium == "Sap" && variable == "Flux" && regex_sap.test(ds_json.name)) {
				measurement = "Sap Temperature"
				variable = "Temperature"
				purpose = "Raw"
				console.log("\t",k,"EXCEPTION: Sap Temperature.",ds_json.name)
			}
			
			// Fix Voumetric Water Content Units
			if(units == "Percent" && variable == "VolumetricWaterContent") {
				boo_update_units = true
				units = "VolumetricWaterContent" // tr.get_tag(ds_json,"Unit").replace("dt_Unit_","")
				console.log("\t",k,"EXCEPTION: Volumetric Water Content Units",ds_json.name)
			}

			//console.log(ds_json.name,measurement,medium,variable,units)
			medium_variable_unit_list.push([medium,variable,units,measurement,ds_json.name])

			// Update Datastream JSON, add dq measurement and dq data-purpose
			if(typeof ds_json.tags === 'undefined') {
				if(typeof ds_json.terms.dq === 'undefined') {
					ds_json.terms.dq = {}
				}
				ds_json.terms.dq.Measurement = measurement
				ds_json.terms.dq.Purpose = purpose
				ds_json.terms.ds.Variable = variable
				if(boo_update_units == true) {
					ds_json.terms.dt.Unit = units
				}
				//console.log("\t ds_json.terms:"+ds_json.terms)
			} else {
				ds_json.tags.push("dq_Measurement_"+measurement)
				ds_json.tags.push("dq_Purpose_"+purpose)
				if(boo_update_units == true) {
					ds_json.tags.push("dt_Unit_"+units)
				}
				//console.log("\t ds_json.tags:"+ds_json.tags)
			}

			//console.log("\t",k,ds_filename,medium,variable,"-->",measurement,"purpose:",purpose)
			// Write datastream back to file
			if(boo_save == true) {
				ds_json_string = JSON.stringify(ds_json,null,2)
				fs.writeFileSync(ds_path+ds_filename,ds_json_string,'utf-8')
				console.log("\t",k,ds_filename,medium,variable,"-->",measurement,"purpose:",purpose)
				//console.log(ds_path+ds_filename)
			}
		} // datastream
	} // station
} // org

//console.log(medium_variable_unit_list)
console.log("DONE")
//medium_variable_unit_list_string = JSON.stringify(medium_variable_unit_list,null,2)
//fs.writeFileSync('medium_variable_unit_measurement_list.json',medium_variable_unit_list_string,'utf-8')

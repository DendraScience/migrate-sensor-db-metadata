/* 
* quail_ridge_datastream_migrator.js
* @author=collin bode
* @date=2017-12-18
*/

console.log("\n point source migrator starting \n")

fs = require("fs")
path = "../data/migration-round2/datastream/"

// Load list of Datastream:Field pairs
dsl = fs.readFileSync("QuailRidge_Datastreams_array.json")
quail_datastreams = JSON.parse(dsl)

// Function to search table for datastream name and match it to .dat file fieldname
function get_loggernet_fields(id) {
	datfield = ""
	for (i = 0; i < quail_datastreams.length; i++) {
		//console.log(quail_datastreams)
		ds_id = quail_datastreams[i][0]
		ds_name = quail_datastreams[i][2]
		ds_field = quail_datastreams[i][3].replace("(","_").replace(")","_") // remove parentheses
		ds_comment = quail_datastreams[i][4]
		ds_derived_id = quail_datastreams[i][5]
		ds_vals = {
			"ds_id":ds_id, 
			"ds_name": ds_name, 
			"ds_field": ds_field, 
			"ds_comment":ds_comment,
			"ds_derived_id":ds_derived_id
		}
		if(id == ds_id) {
			datfield = ds_field
			console.log("FOUND!",id," = ",ds_id,ds_vals)
			break
		}
		/* 
		else {
			console.log(id," != ",ds_id)
		}
		*/
	}
	return ds_vals
}

// Define default Influx configuration 
influx_conf = [{
  "params": {
    "query": {
      "db": "station_quail_ridge",
      "sc": "time, FIELD_NAME",
      "fc": "ten_minute_data",
      "utc_offset": -28800
    }
  },
  "begins_at": "2017-06-07T13:00:00Z",
  "path": "/influx/select"
}]


// Loop through all files in datastream directory 
fs.readdir(path+"temp/",function(err,files) {
	for (var i=0;i<files.length;i++) {
		file_name = files[i]
		console.log(i,file_name)

		if(file_name.match(/z_/)) {
			console.log("Already Processed: ",file_name)
		} 
		else if (file_name.match(/.json$/)) {
			file_content = fs.readFileSync(path+"temp/"+file_name)
			jsf = JSON.parse(file_content)
			console.log(file_name,jsf.name,jsf._id)

			// Get the update values from list
			ds_fields = get_loggernet_fields(jsf._id)

			// Datapoints Config: insert InfluxDB code and field name
			//"sc": "time", "FIELD_NAME",
			//sc_vals = ["time",ds_fields.ds_field]
			sc_vals = `"time", "${ds_fields.ds_field}"`
			//console.log("sc replacement:",sc_vals)
			influx_conf[0].params.query.sc = sc_vals
			jsf.datapoints_config = influx_conf
			console.log("Data Points Configuration:",JSON.stringify(jsf.datapoints_config))

			// Change Datastream name from Angelo to Quail Ridge
			re = new RegExp("  ", 'g');
			jsf.name = jsf.name.replace(re," ")
			jsf.name = jsf.name.replace("Angelo","Quail Ridge")

			// Change Station id (I thought this was done on clone?)
			jsf.station_id = "5a37e71ba546db0001547681"

			// Description is set to "TBD"
			jsf.description = "TBD"

			// Remove External References unless Datastream is derived
			if( jsf.source_type == "sensor") {
				delete jsf.external_refs
			} else if(jsf.source_type == "procedure") {
				jsf.external_refs = [{
      		"identifier": ds_fields.ds_derived_id,
      		"type": "dendra.datastreams"
    		}] 
    		console.log("Procedure datastream found. identifier:",ds_fields.ds_derived_id)
			} else {
				console.log("ERROR! Unknown source_type. Skipping")
				continue
			}

			// Custom alterations for 13 datastreams
			// Precip convert from mm to inches: PCPN_in_Tot
			if(ds_fields.ds_field == "PCPN_in_Tot") {
				jsf.name = jsf.name.replace(" mm "," in ")
				jsf.tags[jsf.tags.length-1] = "dt_Unit_Inch"
			}		
			// Precip cumulative should be calculated
			// Solar Radiation watts to kilowatts: RS_kw_m2_Avg
			if(ds_fields.ds_field == "RS_kw_m2_Avg") {
				jsf.name = jsf.name.replace(" W "," Kw ")
				jsf.tags[jsf.tags.length-1] = "dt_Unit_KiloWattPerSquareMeter"
			}	
			// Wind Gusts m/s to mph
			// Wind Speed m/s to mph
			if(ds_fields.ds_field == "WS_mph_Max" || ds_fields.ds_field == "WS_mph_WVc_1_") {
				jsf.name = jsf.name.replace(" m s "," mph ")
				jsf.tags[jsf.tags.length-1] = "dt_Unit_MilesPerHour"				
			}
			// Volumetric Water Content
			// add attributes change 4 to 2
			if(ds_fields.ds_field == "VWC2_Avg") {
				jsf.name = jsf.name.replace("4","2")
			}


			// Write JSON file
			re = new RegExp(" ", 'g');
			file_out_name = jsf.name.replace(re,"_")+".datastream.json" // replace all spaces with underscores
			jsf_out = JSON.stringify(jsf,null,2)
			fs.writeFileSync(path+file_out_name,jsf_out,'utf-8')

		} else {
			console.log("Not JSON file!",file_name)
		}
	}
	console.log("Done with file list",i,files.length)
})


/*
// test fieldname function
file_name = "58e6cc04df5ce6000126069b.datastream.json"
file_content = fs.readFileSync(path+file_name)
jsf = JSON.parse(file_content)
id = jsf._id
ds_vals = get_loggernet_fields(id)
console.log("TEST COMPLETE:",file_name,ds_vals)
*/

console.log("\n EXIT \n")
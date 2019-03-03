/* 
Transform Incidents from SensorDB into Dendra Annotations
@author: Collin Bode
@date: 2018-11-10
Purpose: small fixer script to update already exported incident reports derived from Wendy's 
excel sheet. Wendy exceptions:
- dates need fixing: PST --> UTC
- Actions: method: "exclude"  -->  "exclude": true
- stationid removal
- Description: remove ' Comments:undefined'

Dependencies: Must run the following scripts first:
 	../sql/vw_export_incidents.sql
 	extract-sensordb-export-incident.sh
 	extract-sensordb-incidents-wendy.js (deprecated)
 	extract-sensordb-incident2annotation.js
*/
 
fs = require("fs")
tr = require("./transform_functions.js")
path = require("path")

function string2array(str_array) {
	//console.log("\t\t",str_array)
	if(Array.isArray(str_array)) {
		//console.log("\t\t already array, returning ",str_array)
		return str_array
	}
	stripped = str_array.replace("[","").replace("]","").trim()
	only_array = stripped.split(",")
	return only_array
}

// UCNRS incidents
org = 'ucnrs'
orgid = "58db17c424dc720001671378" // ucnrs = "58db17c424dc720001671378", erczo = "58db17e824dc720001671379"

// Path to Incidents
ir_path = '../compost/migration3-incidents/wendy_done/'

// Path to Annotationss
//ann_path = '../compost/migration3-incidents/wendy_done2/'  
ann_path = '../data/migration3-incidents/'+org+'/annotation/'

// Run through migration3 annotation directory gather list of path & files	
ir_filepath_list = []
tr.recurse_dir(ir_path,ir_filepath_list,RegExp(/annotation.json$/i)) // Note: RegEx is not really used
console.log("Annotation Traverse complete. list length:",ir_filepath_list.length)

//-------------------------------------------------
// Loop through all Annotations / Incident Reports
//-------------------------------------------------
warn_count = 0
for (var l=0;l<ir_filepath_list.length;l++) {
	//if(l>10) {break} // just do one test

	dir = ir_filepath_list[l][0]
	file = ir_filepath_list[l][1]
	full_path = path.join(dir, file)
	ir = JSON.parse(fs.readFileSync(full_path))
	ann = ir
	console.log("FILE:",file) //,", Path:",full_path)

	// extract synthetic incident ID
	o = file.indexOf("odm.")
	ir.IncidentID = file.slice(o+4,o+7)
	
	// Remove  Comments:undefined
	ann.description = ann.description.replace(" Comments:undefined","")
	console.log("\t ann:",ann.description)
	
		// Set Dates correctly and who updated
	ann.updated_by = "Collin Bode"
	updated_date = new Date(Date.now())
	ann.updated_at = updated_date.toISOString()

	begins_at = new Date(ann.begins_at)
	ann.begins_at = begins_at.toISOString()

	if(ann.ends_before == "") {
		delete(ann.ends_before)
	}	else {
		ends_before = new Date(ann.ends_before)
		ann.ends_before = ends_before.toISOString()
	}

  /* Actions
		"actions":
          "exclude": true
          "flag": [“X”]
          "calc": {}
          "patch": {}
  */
  // Exclude Invalid Data
  // old version: "method": "exclude"
  if(ir.actions.method == "exclude") {
  	delete(ann.actions.method)
  	ann.actions.push({ "exclude" : true })  	
  }

  /* Clean Annotation to make it schema compliant
   	Rules:
   	- If datastreams exist and there is only one station, remove stations
   	- If multiple stations and no datastreams, remove datastreams
		- If there are multiple stations and datastreams, throw error to console and handle manually
   	- If an object is empty, remove object
	*/
	
	// Check station & datastream counts
	ds_count = ann.datastream_ids.length
	st_count = ann.station_ids.length
	console.log("\t station count:"+st_count+", datastream count: "+ds_count)
	if(st_count == 1 && ds_count > 0) {
		console.log(ir.IncidentID,") "+"Removing station id, datastreams sufficient")
		delete(ann.station_ids)
	} else if( st_count > 1 & ds_count == 0) {
		console.log(ir.IncidentID,") "+"stations only. No action.")
	} else if(st_count > 1 && ds_count > 0) {
		console.log(ir.IncidentID,") "+"WARNING! too many stations and datastreams in one incident.")
		warn_count += 1
	}

	// If object is empty, remove it
	for(var obj in ann){
	    //console.log(ir.IncidentID,") "+obj+": "+ann[obj]);
	    if(typeof ann[obj] == 'undefined') {
	    	console.log(ir.IncidentID,") "+obj+": is undefined. Ignoring...")
	    	continue
	    } else if(ann[obj] == 'undefined') {
	    	console.log(ir.IncidentID,") "+obj+": labelled undefined. usually end date. Removing...")
	    	delete ann[obj]
	    } else if(ann[obj].length == 0) {
	    	console.log(ir.IncidentID,") "+obj+": exists, but is empty. Removing...")
	    	delete ann[obj]
	    } 
	}

  // Annotation complete!
	//console.log("Anotation JSON:",ann)

	// Export JSON to file
	// Write to file
	//irpadded = pad(ir.IncidentID,3)
	delete(ann.IncidentID)
	//ann_file = org+"_"+ann.created_at.substring(0,13).replace("T","h")+".odm."+irpadded+".annotation.json"
	ann_string = JSON.stringify(ann,null,2)
	//console.log(file,ann_string)
	fs.writeFileSync(ann_path+file,ann_string,'utf-8')
	console.log("\t exporting:",ann_path+file)
}
console.log("wendy: annotations that need attention = ",warn_count)


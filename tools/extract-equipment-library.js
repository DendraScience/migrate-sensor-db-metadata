/*
Equipment Exporter
Author: Collin Bode
Date: 2019-03-10
Purpose: Export Campbell Scientific Short Cut Definitions into JSON. Use Thing Type schema. 
Dependencies: Requires a copy of the Windows Short Cut (SCWIN.exe) programm directory. 
*/

fs = require("fs")
tr = require("./transform_functions.js")
path = require("path")

// File paths
wpath = "../compost/migration4-methods/equipment_library/"
//wpath = "../../../dendra_dev/equipment_library/"
equip_path = wpath+"CampbellSci_Equipment_List_Full/"
json_path = wpath+"json/"
media_path = equip_path+"images/"

// Run through scwin equipment directory gather list of path & files	
equip_filepath_list = []
tr.recurse_dir(equip_path,equip_filepath_list,RegExp(/.scs$/i)) // Note: RegEx is not really used
console.log("Annotation Traverse complete. list length:",equip_filepath_list.length)

//-------------------------------------------------
// Loop through all .scs equipment definitions
//-------------------------------------------------
modern = 0
sensorfile = 0
for (var l=0;l<equip_filepath_list.length;l++) {
	filename = equip_filepath_list[l][1]
	equip_binary = fs.readFileSync(equip_filepath_list[l][0]+equip_filepath_list[l][1],'utf8')
	equip = equip_binary.toString().split('\r\n')
	console.log(filename,"SensorFile:",equip.indexOf('[SensorFile]'))

	// Reject files not [SensorFile]
	if(equip.indexOf('[SensorFile]') == -1) {
		console.log(filename,"is not a SensorFile! skipping...")
		continue
	}
	sensorfile ++

	// Loop through file row by row
	// Log as much as possible into objects
	skip = false
	in_pairs_section = true
	in_comments_section = false
	sensor_variables = {}
	sensor_variables["campbell_filename"] = filename
	sensor_variables["campbell_filetype"] = "SensorFile"
	for (var e=0;e<equip.length;e++) {
		row = equip[e]
		//console.log(row)

		// Beginning of files are paired variable=value
		if(row[0] == ';') {
			in_pairs_section = false
			//console.log('START comments section',in_pairs_section)	
		} 
		if(in_pairs_section == true) {
			pair = row.split('=')
			if(pair.length == 1) {
				continue
			}
			// Reject files not compatible with CR1000	
			if(pair[0] == 'Dataloggers') {
				dataloggers = pair[1].split(',')
				//console.log("Loggers:",dataloggers)
				//console.log("CR1000?:",dataloggers.indexOf('CR1000'))
				if(dataloggers.indexOf('CR1000') > -1) { 
					//console.log(filename," uses CR1000!")
					modern++
					sensor_variables['Dataloggers'] = dataloggers
				} else {
					console.log(filename,"old logger gear. skipping")
					skip = true
					break
				}
			} else {
				// Move paired values to json
				sensor_variables[pair[0]] = pair[1]
			}
		}

		// Next Section is faux XML with being and end sections
		// Begin & End Comments
		if(row.match("Comments") && !row.match("EndComments")) {
			in_comments_section = true
			//console.log("\tcomments now",in_comments_section,row)
			comments = ""
			continue
		}
		if(row.match("EndComments")) {
			in_comments_section = false
			sensor_variables["comments"] = comments.trim()
			//console.log("\tend comments now",in_comments_section,row)
		}
		if(in_comments_section == true) {
			comments += row+" "
			//console.log("\tcomments:",in_comments_section,comments)
		}
		// Begin & End  
	}


	// skip means this is the wrong type of file, don't process
	if(skip == true) { continue }

	// Clean up JSON 
	console.log(filename,"variables:",sensor_variables)

	// Export as JSON file
	sensor_variables_string = JSON.stringify(sensor_variables,null,2)
	file = filename.split(".")[0]+".campbell.scs.json"
	fs.writeFileSync(json_path+file,sensor_variables_string,'utf-8')
	console.log("\t exporting:",json_path+file)
}
console.log("CR1000 logger files:",modern,"SensorFiles:",sensorfile,"Total .scs files:",equip_filepath_list.length)

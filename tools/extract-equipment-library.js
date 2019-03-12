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
wpath = "../compost/equipment_library/"
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
for (var l=0;l<equip_filepath_list.length;l++) {
	console.log(equip_filepath_list[l][1])
	equip_binary = fs.readFileSync(equip_filepath_list[l][0]+equip_filepath_list[l][1],'utf8')
	equip = equip_binary.toString().split('\r\n')
	console.log("file length:",equip.length)
	
	for (var e=0;e<equip.length;e++) {
		//console.log(e,equip[e])
		row = equip[e].split('=')
		if(row.length == 1) {
			continue
		}
		if(row[0] == 'Dataloggers') {
			dataloggers = row[1].split(',')
			console.log("Loggers:",dataloggers)
			console.log("CR1000?:",dataloggers.indexOf('CR1000'))
			if(dataloggers.indexOf('CR1000') > -1) { 
				console.log("MODERN!")
				modern++
			} else {
				console.log("old stuff. ignore")
			}
		}
	}

	if(l > 1) {
		//break
	}
}
console.log("Files for CR1000 loggers:",modern,". Total .scs files:",equip.length)

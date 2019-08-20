/* 
Datastream Remove Station Name from Name
Purpose: to remove the station name from the datastream name
Requires: list of how each station is named in datastreams.

NOTE: added a comment to description.  didn't work as planned. not changing for now, 
but may be worth cleaning up later.
*/

fs = require("fs")
tr = require("./transform_functions.js")
path = require("path")

// parameters
orgs = ["erczo"]  // ["erczo","ucnrs"]
path_root = "../data/"
test_root = "../compost/data/"

// Station Names list: ways the station is named in datastreams
sname_list = JSON.parse(fs.readFileSync("remove-stationname-from-datastreams.json"))

function find_name_part(sname_list,ds_name) {
	// Cycle through the names list searching for a match
	for (var name in sname_list) {
		//console.log("\t",name)
		for (var m=0;m<sname_list[name].length;m++) {
			name_part = sname_list[name][m]
			//console.log("\t\t",name_part)
			regex_part = new RegExp(name_part)
			if(regex_part.test(ds_name)) {
				//console.log("\t\t\t MATCH",ds_name,"~=",name_part)
				return name_part
				break
			}
		}
	}
	return ""
}

for (var i=0; i<orgs.length;i++) {
	org = orgs[i]
	org_path = path_root+org+"/station/"
	console.log(org_path)

	// Stations - Find
	station_path_list =[] 
	tr.recurse_dir(org_path,station_path_list,RegExp(/.station.json$/i))
	//console.log(station_path_list)
	console.log(org,'Datastream count:',station_path_list.length)

	// Rename each datastream.name in a station directory
	for (var j=0;j<station_path_list.length;j++) {
		s_filename = station_path_list[j][1]
		s_path = station_path_list[j][0]
		s_json = JSON.parse(fs.readFileSync(s_path+s_filename))
		//sname_list[s_json.name] = [s_json.name,s_json.slug].  // used only with temporary export of station names
		console.log("\n",j,s_json.name,s_json.slug)
		
		// Loop through all Datastreams in org
		ds_path_list = []
		tr.recurse_dir(s_path,ds_path_list,RegExp(/datastream.json$/i))
		for (var k=0;k<ds_path_list.length;k++) {
			ds_filename = ds_path_list[k][1]
			ds_path = ds_path_list[k][0]
			
			// load json, match name to station name part, and remove
			ds_json = JSON.parse(fs.readFileSync(ds_path+ds_filename))
			oldname = ds_json.name			
			name_part = find_name_part(sname_list,oldname)
			ds_name = ds_json.name.replace(name_part,"")
			ds_name = ds_name.replace("-","")
			ds_name = ds_name.replace("  "," ").replace("  "," ")
			ds_name = ds_name.trim()
			// Change name
			console.log("rename:",oldname,"-->",ds_name)
			ds_json.name = ds_name
			
			// Modify description?
			//ds_json.description = ds_json.description+"original datastream name was "+ds_json.name
			if(typeof ds_json.description !== 'undefined') {
				regex_part = new RegExp("original datastream name was")
				if(regex_part.test(ds_json.description)) {
					descript = ds_json.description.split("original datastream name was")[0]
					oldname = ds_json.description.split("original datastream name was")[1]
					ds_json.description = descript
					console.log("\t\t fixed description. oldname:",oldname)
				} else {
					console.log("\t\t description clean. continuing...")
				}
			} else {
				console.log("\t\t no description. continuing...")
			}

			// Archive Old Name in external references
			if(typeof ds_json.external_refs === 'undefined') {
				console.log("\t\t no external_refs. adding...")
				ds_json.external_refs = []
			}
			ds_json = tr.update_external_ref(ds_json,"name_previous",oldname) 			

			// Write back to file
			ds_json_string = JSON.stringify(ds_json,null,2)
			//fs.writeFileSync(ds_path+ds_filename,ds_json_string,'utf-8')
			//console.log(ds_path+ds_filename)
		}
	}
}

// Temporary: write station names to json file
//sname_json_string = JSON.stringify(sname_list,null,2)
//fs.writeFileSync('remove-stationname-from-datastreams.json',sname_json_string,'utf-8')

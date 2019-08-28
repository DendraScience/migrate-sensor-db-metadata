/* 
List all method variable pairs from datastreams
*/

fs = require("fs")
tr = require("./transform_functions.js")
path = require("path")

// parameters
orgs = ["erczo","ucnrs","chi"]
path_root = "../data/"

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

			// Get tags
			//console.log("\n",k,ds_filename,ds_json.name)
			medium = tr.get_tag(ds_json,"Medium").replace("ds_Medium_","")
			variable = tr.get_tag(ds_json,"Variable").replace("ds_Variable_","")
			units = tr.get_tag(ds_json,"Unit").replace("dt_Unit_","")
			//console.log(k,ds_filename,":",medium,variable,units)
			console.log(ds_json.name,medium,variable,units)
			medium_variable_unit_list.push([medium,variable,units,ds_json.name])
		}
	}
}

console.log(medium_variable_unit_list)
console.log("DONE")
// Temporary: write station names to json file
medium_variable_unit_list_string = JSON.stringify(medium_variable_unit_list,null,2)
fs.writeFileSync('medium_variable_unit_list.json',medium_variable_unit_list_string,'utf-8')

/* 
Attributes need unit_tag instead of just unit.
*/

fs = require("fs")
tr = require("./transform_functions.js")
path = require("path")

// parameters
orgs = ["erczo","ucnrs","chi"]
a = 0 // soil moisture count


// Loop through Organizations
for (var o in orgs) {
	org = orgs[o]
	console.log("--=",org,"START","=--")
	// Build Path
	path_root = "/Users/collin/git/migrate-sensor-db-metadata/data/"+org+"/station/"

	// Loop through all Datastreams in station directory
	ds_path_list = []
	tr.recurse_dir(path_root,ds_path_list,RegExp(/datastream.json$/i))
	for (var k=0;k<ds_path_list.length;k++) {
		// Get each Datastream and load its json
		ds_filename = ds_path_list[k][1]
		ds_path = ds_path_list[k][0]
		ds_json = JSON.parse(fs.readFileSync(ds_path+ds_filename))

		boo_save = false //  don't save files that aren't edited

		// Get tags
		//console.log("\n",k,ds_filename,ds_json.name)
		try {
			measurement = tr.get_tag(ds_json,"Measurement")
		}
		catch {
			console.log("NO MEASUREMENT",k,ds_filename,ds_json.name)
		}
		medium = tr.get_tag(ds_json,"Medium").replace("ds_Medium_","")
		variable = tr.get_tag(ds_json,"Variable").replace("ds_Variable_","")
		units = tr.get_tag(ds_json,"Unit").replace("dt_Unit_","")
		aggregate = tr.get_tag(ds_json,"Aggregate")
		
		// Get Attributes
		/*
	  "attributes": {
	    "depth": {
	      "unit": "dt_Unit_Meter",
	      "value": 25.3
	    },
	    "wellhead_height": {
	      "unit": "dt_Unit_Meter",
	      "value": 0.06
	    },
	    "cable_length": {
	      "unit": "dt_Unit_Meter",
	      "value": 23.09
	    }
	  },
	  */
		// skip datastreams with no attributes
		if(typeof ds_json.attributes === 'undefined') {	
			continue 
		}
		a += 1 // count datastreams with attributes
		//console.log(k,a,ds_json.name,"attibute count:",Object.keys(ds_json.attributes).length)
		for (const att of Object.keys(ds_json.attributes)) {
			att_obj = ds_json.attributes[att]
			//console.log("\t",att,"==>",att_obj)
			//console.log("\t typeof:",typeof(att_obj))
			//if(typeof(att_obj) === "string") {
			//	console.log("\t\t",att,"==>",att_obj)
			//} else { 
			if(typeof(att_obj) === "object") {
				kk = 0
				for (const key of Object.keys(att_obj)) {
					val = att_obj[key]
					key_name = key,Object.keys(att_obj)[kk]
					//console.log("\t\t",key,"==>",val)
					if(key_name == "unit") {
						console.log("\t\tFOUND! unit convert to unit_tag")
						ds_json.attributes[att].unit_tag = val
						delete ds_json.attributes[att].unit
						boo_save = true
					}
					kk += 1
				}
			}
		}
		//console.log(k,a,ds_json.name,"attibutes:",JSON.stringify(ds_json.attributes))

		// Write datastream back to file
		//boo_save = false
		if(boo_save == true) {
			ds_json_string = JSON.stringify(ds_json,null,2)
			fs.writeFileSync(ds_path+ds_filename,ds_json_string,'utf-8')
			console.log(k,a,"SAVED",ds_filename)  //ds_path+ds_filename)
	  }
	} // datastream
	console.log("--=",org,"DONE",path_root,"=--")
}
console.log("DONE")

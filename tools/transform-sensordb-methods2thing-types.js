/* 
	Methods to Thing-Type
	Author: Collin Bode
	Date: 2019-03-19
	Purpose: Assembles information from datastreams, methods table, and variablecodes
	to create a "Thing-Type" or equipment definition for odm equipment.
	Dependencies:  these must be run first in order
		clean_methods.sql
		vw_export_methods.sql
		extract_sensordb_export_methods.sh
*/


fs = require("fs")
tr = require("./transform_functions.js")
path = require("path")

// File paths
compost = "../compost/migration4-methods/"
datam3 = "../data/migration3-incidents/"
mv_path = compost+""

// Method_Variables directory gather list of path & files	
mv_filepath_list = []
tr.recurse_dir(compost+"method_variable/",mv_filepath_list,RegExp(/methodvariable.json$/i)) // Note: RegEx is not really used
console.log("Methods-Variables Traverse complete. list length:",mv_filepath_list.length)

// Methods directory gather list of path & files	
method_filepath_list = []
tr.recurse_dir(compost+"method/",method_filepath_list,RegExp(/method.json$/i)) // Note: RegEx is not really used
console.log("Methods Traverse complete. list length:",method_filepath_list.length)

// Datastreams directory gather list of path & files	
ds_filepath_list = []
tr.recurse_dir(datam3,ds_filepath_list,RegExp(/datastream.json$/i)) // Note: RegEx is not really used
console.log("Datastreams Traverse complete. list length:",ds_filepath_list.length)

/*
 Loop through method-variables 
 Get VariableCode and MethodID
 Match them to datastreams 
 Get the DatastreamID and its tags
 */

for (var v=0;v<mv_filepath_list.length;v++) {
	filename = mv_filepath_list[v][1]
	mv = JSON.parse(fs.readFileSync(mv_filepath_list[v][0]+mv_filepath_list[v][1],'utf8'))
	console.log(filename, mv.methodid, mv.methodname, mv.variablecode)
	mv.datastream_ids = []
	mv.tags = []

	// Loop through Datastreams and match to MethodID and VariableCode
	for (var d=0;d<ds_filepath_list.length;d++) {
		dsfilename = ds_filepath_list[d][1]
		ds = JSON.parse(fs.readFileSync(ds_filepath_list[d][0]+ds_filepath_list[d][1],'utf8'))
		ds_methodid = tr.get_external_ref(ds,"odm.stations.MethodID")
		ds_variablecode = tr.get_external_ref(ds,"odm.stations.VariableCode")
		//console.log(mv.methodid,ds_methodid,ds_variablecode)

		// Check Datastream, does it match MethodID and VariableCode of Method document?
		if(mv.methodid == ds_methodid && mv.variablecode == ds_variablecode) {
			console.log("MATCH!",mv.methodid,"==",ds_methodid,"&&",mv.variablecode,"==",ds_variablecode)
			mv.datastream_ids.push(ds._id)
			tags_match = false

			// Remove Tags for Aggregates and Seasonal
			for(var m=0;m<ds.tags.length;m++) {
		    if(ds.tags[m].match("Aggregate")) { ds.tags.splice(m,1) }
		  }
			for(var m=0;m<ds.tags.length;m++) {
		    if(ds.tags[m].match("Function")) { ds.tags.splice(m,1) }
			}
			for(var m=0;m<ds.tags.length;m++) {
		    if(ds.tags[m].match("Interval")) { ds.tags.splice(m,1) }
			}

			// Add First Tag set found then check for different tags
			if(mv.tags.length == 0) {
				mv.tags.push(ds.tags)
				console.log(mv.methodid,"first tag pushed",mv.tags.toString())
			} else {
				for(var t=0;t<mv.tags.length;t++) {
					if(tr.is_objects_equivalent(mv.tags[t],ds.tags)) {
						tags_match = true
					} 
				}
				if(tags_match == false) {
					mv.tags.push(ds.tags)
					console.log(mv.methodid,"NEW tag pushed",mv.tags)
				}
			}	
		}	
		if(d > 40) { break }
	}	

	//if(v > 5) {break}

	// Export as JSON file
	mv_string = JSON.stringify(mv,null,2)
	fs.writeFileSync(compost+"method_variable_tags/"+filename,mv_string,'utf-8')
	console.log("\t exporting:",filename)
}
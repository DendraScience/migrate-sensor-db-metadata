/* 
Annotation Export and Modify Incidents from SensorDB
@author: Collin Bode
 @date: 2018-11-10
 Purpose: Takes the SQL to JSON export of vw_export_incident and transforms it into proper
 annotation JSON for Dendra.
*/


fs = require("fs")
tr = require("./transform_functions.js")
path = require("path")
//org = 'ucnrs'
//orgid = "58db17c424dc720001671378" // ucnrs = "58db17c424dc720001671378", erczo = "58db17e824dc720001671379"

function string2array(str_array) {
	stripped = str_array.replace("[","").replace("]","").trim()
	only_array = stripped.split(",")
	return only_array
}

function pad(num, size) {
    s = num+""
    while (s.length < size) {
    	s = "0" + s
    }
    return s
}

orgs = [
	["ucnrs","58db17c424dc720001671378"],
	["erczo","58db17e824dc720001671379"]
]

// Process each organization separately
for(var o=0;o<orgs.length;o++) {
	org = orgs[o][0]
	orgid = orgs[o][1]

	// Path to Annotations
	mig3_path = '../data/migration3-incidents/'+org+'/'
	ann_path = mig3_path+'annotation/'

	// Run through migration3 annotation directory gather list of path & files
	ir_path = '../compost/migration3-incidents/'+org+'/'
	ir_filepath_list = []
	tr.recurse_dir(ir_path,ir_filepath_list,RegExp(/annotation.json$/i)) // Note: RegEx is not really used
	console.log("Annotation Traverse complete. list length:",ir_filepath_list.length)

	// Gather list of Stations
	station_path_list = []
	station_id_list = []
	tr.recurse_dir(mig3_path,station_path_list,RegExp(/station.json$/i)) 
	console.log("Station Traverse complete. list length:",station_path_list.length)

	// Pull ODM ID & MongoID from each datastream
	for (var ss=0;ss<station_path_list.length;ss++) {
		//console.log(dd)
		sdir = station_path_list[ss][0]
		sfile = station_path_list[ss][1]
		sfull_path = path.join(sdir, sfile)
		st = JSON.parse(fs.readFileSync(sfull_path))
			
		// Quail Ridge and a few newer stations do not have external references	
		if(typeof st.external_refs === 'undefined') {
			console.log(st.name,"doesn't have external refs")
			continue
		}
		
		// list parts
		stname = st.name
		mongoid = st._id
		odmid = 0

	  for(var kk=0;kk<st.external_refs.length;kk++) {
	  	if(st.external_refs[kk].type.match(/StationID/)) {
	  		odmid = parseInt(st.external_refs[kk].identifier,10)
	  	}
	  }
	  if(odmid == 0) { continue }
	  else {
	  	station_id_list.push([stname,odmid,mongoid])
	  }
	}
	console.log("station_id_list.length:",station_id_list.length)
	console.log("station_path_list.length:",station_path_list.length)


	// Gather list of Datastreams for Organization
	datastream_path_list = [] 
	datastream_id_list = []
	tr.recurse_dir(mig3_path,datastream_path_list,RegExp(/datastream.json$/i)) 
	console.log("Datastream Traverse complete. list length:",datastream_path_list.length)

	// Pull ODM ID & MongoID from each datastream
	for (var dd=0;dd<datastream_path_list.length;dd++) {
		//console.log(dd)
		ddir = datastream_path_list[dd][0]
		dfile = datastream_path_list[dd][1]
		dfull_path = path.join(ddir, dfile)
		ds = JSON.parse(fs.readFileSync(dfull_path))
			
		// Quail Ridge and a few newer stations do not have external references	
		if(typeof ds.external_refs === 'undefined') {
			console.log(ds.name,"doesn't have external refs")
			continue
		}
		

		// datastream_id_list parts
		dsname = ds.name
		mongoid = ds._id
		odmid = 0

	  for(var k=0;k<ds.external_refs.length;k++) {
	  	//    "identifier": "422",
	    //		"type": "odm.datastreams.DatastreamID"
	  	if(ds.external_refs[k].type.match(/DatastreamID/)) {
	  		odmid = parseInt(ds.external_refs[k].identifier,10)
	  	}
	  }
	  if(odmid == 0) { continue }
	  else {
	  	datastream_id_list.push([dsname,odmid,mongoid])
	  }
	}
	console.log("datastream_id_list.length:",datastream_id_list.length)
	console.log("datastream_path_list.length:",datastream_path_list.length)


	//-------------------------------------------------
	// Loop through all Annotations / Incident Reports
	//-------------------------------------------------
	for (var l=0;l<ir_filepath_list.length;l++) {
		//if(l>10) {break} // just do one

		dir = ir_filepath_list[l][0]
		file = ir_filepath_list[l][1]
		full_path = path.join(dir, file)
		ir = JSON.parse(fs.readFileSync(full_path))
		console.log("FILE:",full_path)

		ann = {} // new annotation json
		ann.begins_at = ir.StartTime
		ann.ends_before = ir.EndTime
		ann.enabled = true
		ann.organization_id = orgid
		ann.title = ir.Title
		ann.description = ir.Description.replace(/\r?\n|\r/g," ") 
		if(ir.Comments != "") {
			ann.description = ann.description + " Comments:" + ir.Comments
		}
		ann.created_by = ir.Reported_By
		ann.created_at = ir.Date_Reported
		ann.actions = []
		ann.station_ids = []
		ann.datastream_ids = []
		ann.external_refs = []

		// Station ODM IDs --> MongoIDs
		ir_stations = string2array(ir.StationIDs)
		console.log("\t",ir.StationIDs,"-->",ir_stations)
		for (var s=0;s<ir_stations.length;s++) {
			sod = ir_stations[s].trim()
			console.log("\t\t",s,sod)
			for (var j=0;j<station_id_list.length;j++) {
				if(sod == station_id_list[j][1]) {
					ann.station_ids.push(station_id_list[j][2])
					//console.log("FOUND!",sod,"==",station_id_list[j][1],station_id_list[j][0],station_id_list[j][2])
				} 
			}
		}


		// Dataastream ODM IDs --> MongoIDs
		ir_datastreams = string2array(ir.DatastreamIDs)
		for (var d=0;d<ir_datastreams.length;d++) {
			dsid = ir_datastreams[d]

			if(dsid == "") {
				//console.log(d,file,"NO DATASTREAMS")
				break
			} else {
				dsid = parseInt(dsid,10)
				//console.log(d,file,"looking for",dsid)
			} 

			// Loop through the datastream_id_list looking for MongoID
			for (var i=0;i<datastream_id_list.length;i++) {
				//console.log(dsid,datastream_id_list[i][1])	
	  		if(datastream_id_list[i][1] == dsid) {
	  			ann.datastream_ids.push(datastream_id_list[i][2])
	  			//console.log("\t Datastream Found!",dsid,"==",datastream_id_list[i][1],"MongoID:",datastream_id_list[i][2])
	  			break
	  		}
			}
		}

		// External References
		//    "identifier": "422",
	  //		"type": "odm.datastreams.DatastreamID"
	  ann.external_refs.push({"identifier":ir.IncidentID,"type":"odm.incidents.IncidentID"})
	  ann.external_refs.push({"identifier":ir.StationNames,"type":"odm.incidents.StationNames"})
	  ann.external_refs.push({"identifier":ir.Datastream_Names,"type":"odm.incidents.Datastream_Names"})
	  ann.external_refs.push({"identifier":ir.qid,"type":"odm.qualifiers.QualifierID"})
	  ann.external_refs.push({"identifier":ir.QualifierCode,"type":"odm.qualifiers.QualifierCode"})
	  ann.external_refs.push({"identifier":ir.QualifierDescription,"type":"odm.qualifiers.QualifierDescription"})

	  // Actions
	  // Exclude Invalid Data
	  if(ir.valid == 0) {
	  	ann.actions.push({ "method": "exclude" })  	
	  }
	  // Flags
	  if(typeof ir.flag !== 'undefined') {
	  	ann.actions.push({"flags":[ir.flag.trim()]})
	  }

		//console.log("Anotation JSON:",ann)

		// Export JSON to file
		// Write to file
		irpadded = pad(ir.IncidentID,3)
		ann_file = org+"_"+ann.created_at.substring(0,13).replace("T","h")+".odm."+irpadded+".annotation.json"
		ann_string = JSON.stringify(ann,null,2)
		fs.writeFileSync(ann_path+ann_file,ann_string,'utf-8')
		console.log("\t exporting:",ann_file)
	}
}

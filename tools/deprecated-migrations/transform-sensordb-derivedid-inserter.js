/*
Derived ID inserter to Datastreams 
This must be run AFTER datstreams are loaded into Mongo.  Otherwise the MongoIDs
will not have been generated.
@author: Collin Bode
@date: 2018-02-28
*/

fs = require("fs")
args = process.argv.slice(2)
path = args[0] // Requires trailing slash, e.g. "../data/migration2.1-rivendell/erczo/" 
ds_path = path + 'datastream/'
if(fs.existsSync(ds_path) == false) {
	console.log('usage: node transform-sensordb-derivedid-inserter.js <migration_path/>')
	console.log("\tDIR does not exist! Skipping.",ds_path)
	process.exit()
}
console.log("\n Derived ID inserter to Datastreasms DIR:",ds_path)

/*  "external_refs": [
{
  "identifier": "1612",
  "type": "odm.datastreams.DatastreamID"
},
{
  "identifier": "10",
  "type": "odm.stations.StationID"
},
{
  "identifier": "394",
  "type": "odm.datastreams.DerivedID"
}*/
function get_external_ref(de_json,ref_type) {
  for(var k=0;k<de_json.external_refs.length;k++) {
  	//console.log("external_refs[",k,"]:",de_json.external_refs[k])
  	if(de_json.external_refs[k].type == ref_type) {
  		//console.log("MATCH!",ref_type,"==",de_json.external_refs[k].type,"returning identifier:",de_json.external_refs[k].identifier)
  		return de_json.external_refs[k].identifier
  	}
  }
}

function get_derived_mongoid(ds_path,name,derived_id) {
	dd_files = fs.readdirSync(ds_path)
  for(var j=0;j<dd_files.length;j++) {
    dd_filename = dd_files[j]
  	if (dd_filename.match(/.json$/)) {
			dd_json = JSON.parse(fs.readFileSync(ds_path+dd_filename))
			dd_datastreamid = get_external_ref(dd_json,"odm.datastreams.DatastreamID")
	    if(derived_id == dd_datastreamid) {
	      //console.log("FOUND! ",dd_json.name,'-->',name,dd_datastreamid,derived_id,dd_json._id)
	      return dd_json._id
	    }
	  }
  }
}

// DATASTREAMS

// counters
ds_count = 0
no_match_count = 0
match_count = 0
not_derived_count = 0

// Get list of Datastreams from directory
ds_files = fs.readdirSync(ds_path)
console.log('Datastream Path:',ds_path,"files found:",ds_files.length)

// Loop through Datastream JSON files 
for(var i=0;i<ds_files.length;i++) {
	ds_filename = ds_files[i]
	if (ds_filename.match(/.json$/)) {
		ds_count++
		ds_json = JSON.parse(fs.readFileSync(ds_path+ds_filename))
		name = ds_json.name
		if(typeof ds_json.external_refs === 'undefined') {
			console.log("DerivedId: Skip. no external_refs.",name)
			continue
		} else {
			derived_id = get_external_ref(ds_json,"odm.datastreams.DerivedID")
		}
		if(typeof derived_id === 'undefined') {
			//console.log('Not derived datastream ',name)
			not_derived_count++
		} else {
			//console.log('Derived datastream ',name)
			derived_mongo_id = get_derived_mongoid(ds_path,name,derived_id)
			if(typeof derived_mongo_id === 'undefined') {
				console.log(name," had NO match!")
				no_match_count++
			} else {
				ds_json.derived_from_datastream_ids = [derived_mongo_id]
				// Write JSON file
				ds_json_string = JSON.stringify(ds_json,null,2)
				console.log('Updating Datastream',name,'with derived:',ds_json.derived_from_datastream_ids)
				match_count++
				fs.writeFileSync(ds_path+ds_filename,ds_json_string,'utf-8')
			}
		}	
	} else {
		console.log("Not JSON file!",ds_filename)
	}
}
console.log('DONE! '+match_count+' Datastreams processed out of',ds_count,'with',no_match_count,'not matched. Not derived',not_derived_count)

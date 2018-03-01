/*
Station ID inserter to Datastreams 
@author: Collin Bode
@date: 2018-02-28
*/
console.log("\n Station ID inserter to Datastreasms starting \n")

fs = require("fs")
args = process.argv.slice(2)
path = args[0] // Requires trailing slash, e.g. "../data/migration2.1-rivendell/" 
console.log('usage: node stationid_inserter_2datastreams.js <migration_path/>')

// Get list of Datastreams from directory
ds_path = path + 'datastream/'
console.log('Datastream Path:',ds_path)
ds_files = fs.readdirSync(ds_path)
console.log(ds_files.length)

// counters
ds_count = 0
no_match_count = 0
match_count = 0

// Loop through Datastream JSON files 
for(var i=0;i<ds_files.length;i++) {
	ds_filename = ds_files[i]
	if (ds_filename.match(/.json$/)) {
		ds_count++
		ds_filepath = ds_path+ds_filename
		ds_file_content = fs.readFileSync(ds_filepath)
		ds_json = JSON.parse(ds_file_content)
		ds_station_id = Number(ds_json.external_refs[1].identifier)
		//console.log(ds_filename,', ds_station_id:',ds_station_id)

		// Loop through all the stations and get Station MongoID
		st_path = path+'station/'
		st_files = fs.readdirSync(st_path)
		var st_mongo_id = ""
		for(var j=0;j<st_files.length;j++) {
			st_filename = st_files[j]
			//console.log(i,j,st_filename) 
			if (st_filename.match(/.json$/)) {
				st_filepath = st_path+st_filename
				st_file_content = fs.readFileSync(st_filepath)
				st_json = JSON.parse(st_file_content)
				st_station_id = Number(st_json.external_refs[0].identifier)
				//console.log('comparing: ds',ds_station_id,'<--> st',st_station_id)
				if(ds_station_id == st_station_id) {
					st_mongo_id = st_json._id
					console.log('MATCH!',ds_filename,ds_station_id,st_station_id,st_mongo_id)
					match_count++
				}
			}
		}
		if(st_mongo_id == "") {
			console.log(ds_filename," had NO match!")
			no_match_count++
		} else {
			ds_json.station_id = st_mongo_id
			// Write JSON file
			ds_json_string = JSON.stringify(ds_json,null,2)
			console.log('updating: ',ds_filepath)
			fs.writeFileSync(ds_filepath,ds_json_string,'utf-8')
		}	
	} else {
		console.log("Not JSON file!",ds_filename)
	}
}

console.log('DONE! '+match_count+' Datastreams processed out of',ds_count,'with',no_match_count,'not matched.')

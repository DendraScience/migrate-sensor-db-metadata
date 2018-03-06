/*
Station ID inserter to Datastreams 
@author: Collin Bode
@date: 2018-02-28
*/
console.log("\n Station ID inserter to Stations and Datastreasms starting \n")

fs = require("fs")
args = process.argv.slice(2)
path = args[0] // Requires trailing slash, e.g. "../data/migration2.1-rivendell/" 
console.log('usage: node migrate-stationid-inserter.js <migration_path/>')

// To use old station ids, for compatibility, set this to true
stations = JSON.parse(fs.readFileSync("stations.js"))
console.log('number of stations:',stations.list.length)

function get_station_id(stations,station_id) {
  for(var i=0;i<stations.list.length;i++) {
    station = stations.list[i]
    if(station.station_id == station_id) {
      //console.log("FOUND! ",station.name, station.station_id,station._id)
      return station._id
    }
  }
}

// STATIONS

// counters
ss_count = 0
ss_no_match_count = 0
ss_match_count = 0

// Get list of stations from directory
ss_path = path + 'station/'
ss_files = fs.readdirSync(ss_path)
console.log('Station Path:',ss_path,"files found:",ss_files.length)

// Loop through Station JSON files 
for(var i=0;i<ss_files.length;i++) {
	st_mongo_id = ""
	ss_filename = ss_files[i]
	if (ss_filename.match(/.json$/)) {
		ss_count++
		ss_json = JSON.parse(fs.readFileSync(ss_path+ss_filename))
		ss_station_id = Number(ss_json.external_refs[0].identifier)

		// Loop through all the stations and get Station MongoID
		st_mongo_id = get_station_id(stations,ss_station_id)
		if(st_mongo_id == "") {
			console.log("Station",ss_filename," had NO MATCH!")
			ss_no_match_count++
		} else {
			console.log('Updating Station',ss_filename,ss_station_id,st_mongo_id)
			ss_match_count++
			ss_json._id = st_mongo_id
			// Write JSON file
			ss_json_string = JSON.stringify(ss_json,null,2)
			fs.writeFileSync(ss_path+ss_filename,ss_json_string,'utf-8')
		}	
	} else {
		console.log("Not JSON file!",ss_filename)
	}
}

// DATASTREAMS

// counters
ds_count = 0
no_match_count = 0
match_count = 0

// Get list of Datastreams from directory
ds_path = path + 'datastream/'
ds_files = fs.readdirSync(ds_path)
console.log('Datastream Path:',ds_path,"files found:",ds_files.length)

// Loop through Datastream JSON files 
for(var i=0;i<ds_files.length;i++) {
	st_mongo_id = ""
	ds_filename = ds_files[i]
	if (ds_filename.match(/.json$/)) {
		ds_count++
		ds_json = JSON.parse(fs.readFileSync(ds_path+ds_filename))
		ds_station_id = Number(ds_json.external_refs[1].identifier)
		// Loop through all the stations and get Station MongoID
		
		/*
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
		*/
		st_mongo_id = get_station_id(stations,ds_station_id)
		if(st_mongo_id == "") {
			console.log(ds_filename," had NO match!")
			no_match_count++
		} else {
			ds_json.station_id = st_mongo_id
			// Write JSON file
			ds_json_string = JSON.stringify(ds_json,null,2)
			console.log('Updating Datastream',ds_filename,ds_station_id,st_mongo_id)
			match_count++
			fs.writeFileSync(ds_path+ds_filename,ds_json_string,'utf-8')
		}	
	} else {
		console.log("Not JSON file!",ds_filename)
	}
}
console.log('DONE! '+ss_match_count+' Stations processed out of',ss_count,'with',ss_no_match_count,'not matched.')
console.log('DONE! '+match_count+' Datastreams processed out of',ds_count,'with',no_match_count,'not matched.')

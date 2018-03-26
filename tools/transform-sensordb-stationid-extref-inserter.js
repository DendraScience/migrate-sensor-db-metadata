/*
Station ID & External References inserter to Datastreams 
@author: Collin Bode
@date: 2018-02-28
@updated: 2018-03-26

Purpose: runs through station and datastream directories and 
1. inserts the MongoID for Stations
2. inserts external references to the station sources:
	- Datastream & Station external refs
		"loggernet.ldmp":"wanda.berkeley.edu:1024", <-- mutually exclusive with goes
		"goes.address":""	
		"loggernet.station":"wssm"
3. NOT inserted: Datastream ONLY -- get from Core8 spreadsheet
	"loggernet.table":"tenmin",
	"loggernet.field":"slr_kw_avg"
*/
console.log("\n Station ID inserter to Stations and Datastreams starting \n")

fs = require("fs")
args = process.argv.slice(2)
parent_path = args[0] // Requires trailing slash, e.g. "../data/migration2.1-rivendell/"
org_slug = args[1] // "erczo" or "ucnrs"
path = parent_path+org_slug+"/" 
console.log('usage: node transform-sensordb-stationid-inserter.js <migration_path/> <organization_slug>')

// Load static list of stations
stations = JSON.parse(fs.readFileSync("stations.json"))
console.log('number of stations:',stations.list.length)
/*	{
		    "_id" : "58e68cabdf5ce600012602ba",
		    "name" : "Burns",
		    "station_id" : "338",  <-- this is the odm id
		    "loggernet.station":"ucbu_burns",
		    "goes":"BEC025B0"
		}
*/
function get_station(stations,station_odm_id) {
  for(var i=0;i<stations.list.length;i++) {
    station = stations.list[i]
    if(station.station_id == station_odm_id) {
      //console.log("FOUND! ",station.name, station.station_id,station._id)
      return station
    }
  }
}

function get_external_ref(de_json,ref_type) {
  for(var k=0;k<de_json.external_refs.length;k++) {
  	//console.log("external_refs[",k,"]:",de_json.external_refs[k])
  	if(de_json.external_refs[k].type == ref_type) {
  		//console.log("MATCH!",ref_type,"==",de_json.external_refs[k].type,"returning identifier:",de_json.external_refs[k].identifier)
  		return de_json.external_refs[k].identifier
  	}
  }
}

function update_external_ref(de_json,ref_type,ref_identifier) {
	boofound = false
  for(var k=0;k<de_json.external_refs.length;k++) {
  	if(de_json.external_refs[k].type == ref_type) {
  		//console.log("update_external_ref: MATCH!",ref_type,"==",de_json.external_refs[k].type,"updating identifier:",de_json.external_refs[k].identifier)
  		de_json.external_refs[k].identifier = ref_identifier
  		boofound = true
  	}
  }
  if(boofound == false) {
  	//ss_json.external_refs.push({"identifier": ldmp,"type":"loggernet.ldmp" })
  	//console.log(de_json.name,"update_external_ref: pushing new ref",ref_type+":"+ref_identifier)
		de_json.external_refs.push({"identifier":ref_identifier,"type":ref_type})
  }
  return de_json
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
	station = ""
	ss_filename = ss_files[i]
	if (ss_filename.match(/.json$/)) {
		ss_count++
		ss_json = JSON.parse(fs.readFileSync(ss_path+ss_filename))
		ss_station_id = Number(ss_json.external_refs[0].identifier)

		// Loop through all the stations and get Station MongoID
		station = get_station(stations,ss_station_id)
		if(station == "") {
			console.log("Station",ss_filename," had NO MATCH!")
			ss_no_match_count++
		} else {

			// Update station id to Mongo id
			console.log(ss_filename,'Updating Station MongoID',ss_station_id,"-->",station._id)
			ss_match_count++
			ss_json._id = station._id

			// Update external references for loggernet and goes
			if(typeof station.loggernet !== 'undefined') {
				console.log(ss_filename,'Updating Station external refs LoggerNet name',station.loggernet)
				//     {"identifier": "349","type": "odm.station.StationID"}
				//ss_json.external_refs.push({"identifier":station.loggernet,"type":"loggernet.station"})
				ss_json = update_external_ref(ss_json,"loggernet.station",station.loggernet)
			}
			if(typeof station.goes === 'undefined') {
				if(org_slug == "erczo") {
					ldmp = "208.186.56.6:1024"
				} else if(org_slug == "ucnrs" || org_slug == "sagehen") {
					ldmp = "wanda.berkeley.edu:1024"
				} else {
					console.log(ss_filename,'ORGANIZATION NOT FOUND! No ldmp inserted')
				}
				if(typeof ldmp !== 'undefined') {
					console.log(ss_filename,'Updating LDMP server',ldmp)
					//ss_json.external_refs.push({"identifier": ldmp,"type":"loggernet.ldmp" })
					ss_json = update_external_ref(ss_json,"loggernet.ldmp",ldmp)
				}
			} else {
				console.log(ss_filename,'Updating GOES Address',station.goes)
				//ss_json.external_refs.push({"identifier":station.goes,"type":"goes.address"})
				ss_json = update_external_ref(ss_json,"goes.address",station.goes)
			}

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
	station = ""
	ds_filename = ds_files[i]
	if (ds_filename.match(/.json$/)) {
		ds_count++
		ds_json = JSON.parse(fs.readFileSync(ds_path+ds_filename))

		// Get Station ID from external refs
		// Get Station object & odm id
		ds_station_id = get_external_ref(ds_json,"odm.stations.StationID")
		console.log(ds_filename,'odm_station_id:',ds_station_id)
		station = get_station(stations,ds_station_id)		

		if(station == "") {
			console.log(ds_filename," had NO match!")
			no_match_count++
		} else {

			// Assign Station Mongo ID, replacing the odm station id
			ds_json.station_id = station._id


			// Update external references for loggernet and goes
			// LoggerNet station name for parent station
			if(typeof station.loggernet !== 'undefined') {
				console.log(ds_filename,'Updating datastream external refs LoggerNet name',station.loggernet)
				ds_json = update_external_ref(ds_json,"loggernet.station",station.loggernet)
			}

			// LoggerNet station ldmp or goes for parent station
			if(typeof station.goes === 'undefined') {
				if(org_slug == "erczo") {
					ldmp = "208.186.56.6:1024"
				} else if(org_slug == "ucnrs" || org_slug == "sagehen") {
					ldmp = "wanda.berkeley.edu:1024"
				} else {
					console.log(ds_filename,'ORGANIZATION NOT FOUND! No ldmp inserted')
				}
				if(typeof ldmp !== 'undefined') {
					console.log(ds_filename,'Updating LDMP server',ldmp)
					ds_json = update_external_ref(ds_json,"loggernet.ldmp",ldmp)
				}
			} else {
				console.log(ds_filename,'Updating GOES Address',station.goes)
				ds_json = update_external_ref(ds_json,"goes.address",station.goes)
			}


			// Write JSON file
			ds_json_string = JSON.stringify(ds_json,null,2)
			console.log('Updating Datastream',ds_filename,ds_station_id,ds_json.station_id)
			match_count++
			fs.writeFileSync(ds_path+ds_filename,ds_json_string,'utf-8')
		}	
	} else {
		console.log("Not JSON file!",ds_filename)
	}
}

console.log('DONE! '+ss_match_count+' Stations processed out of',ss_count,'with',ss_no_match_count,'not matched.')
console.log('DONE! '+match_count+' Datastreams processed out of',ds_count,'with',no_match_count,'not matched.')

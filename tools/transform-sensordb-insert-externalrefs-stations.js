/*
Station ID & External References inserter to Datastreams 
@author: Collin Bode
@date: 2018-02-28
@updated: 2018-03-26

Purpose: runs through station directories and 
1. inserts the MongoID for Stations
2. sets "enabled" to false, for stations and datastreams that are innactive
3. inserts external references to the station sources:
	- Datastream & Station external refs
		"loggernet.ldmp":"wanda.berkeley.edu:1024", <-- mutually exclusive with goes
		"goes.address":""	
		"loggernet.station":"wssm"
4. Data Tables from Loggernet Configuration XML. Status tables excluded.
	"loggernet.tables":["TenMin"]
5. NOT inserted: Datastream ONLY -- get from Core8 spreadsheet
	"loggernet.field":"slr_kw_avg"
*/

fs = require("fs")
tr = require("./transform_functions.js")

args = process.argv.slice(2)
parent_path = args[0] // Requires trailing slash, e.g. "../data/migration2.1-rivendell/"
org_slug = args[1] // "erczo" or "ucnrs"
path = parent_path+org_slug+"/" 
if(fs.existsSync(path) == false) {
	console.log('usage: node ./transform-sensordb-insert-externalrefs-stations.js <migration_path/> <organization_slug>')
	console.log("\tDIR does not exist! Skipping.",path)
	process.exit()
}
console.log("\n Stations External References DIR:",path)

// Load static list of stations
stations = JSON.parse(fs.readFileSync("stations.json"))
//stations_loggernet = JSON.parse(fs.readFileSync("stations_loggernet.json"))
console.log('number of stations:',stations.list.length) //,"loggernet stations:",stations_loggernet.length)

// STATIONS
// counters
ss_count = 0
ss_no_match_count = 0
ss_match_count = 0
ss_no_station_count = 0
ss_station_count = 0

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
		//ss_station_id = Number(ss_json.external_refs[0].identifier)
		ss_station_id = tr.get_external_ref(ss_json,"odm.station.StationID")

		// Loop through the station list and get Station MongoID
		station = tr.get_station(ss_station_id)
		if(station == "") {
			console.log("Station",ss_filename," had NO MATCH!")
			ss_no_match_count++
		} else {

			// Update station id to Mongo id
			//console.log(ss_filename,'Updating Station MongoID',ss_station_id,"-->",station._id)
			ss_match_count++
			ss_json._id = station._id

			// Update "enabled" status to false if the station is innactive
			if(typeof station.enabled !== 'undefined') {
				ss_json.enabled = station.enabled
			}
			/*
				// If station is innactive, skip the rest of the external references
				if(station.enabled == false) {
					console.log("Station",station.name," is innactive. skip.")
					continue
			}
			*/
			// Update external references for loggernet name
			if(typeof station.loggernet !== 'undefined') {
				//console.log('\texternal_refs:loggernet.station:',station.loggernet)
				ss_json = tr.update_external_ref(ss_json,"loggernet.station",station.loggernet)
			}

			// Update LDMP or GOES, depending on transmission protocol
			if(typeof station.goes === 'undefined') {
				if(org_slug == "erczo") {
					ldmp = "208.186.56.6:1024"
				} else if(org_slug == "ucnrs" || org_slug == "sagehen") {
					ldmp = "wanda.berkeley.edu:1024"
				} else {
					console.log(ss_filename,'ORGANIZATION NOT FOUND! No ldmp inserted')
				}
				if(typeof ldmp !== 'undefined') {
					//console.log('\texternal_refs:loggernet.ldmp:',ldmp)
					ss_json = tr.update_external_ref(ss_json,"loggernet.ldmp",ldmp)
				}
			} else {
				//console.log('\texternal_refs:goes.address:',station.goes)
				ss_json = tr.update_external_ref(ss_json,"goes.address",station.goes)
			}

			// Add Data Tables Names to external references
			lstation = tr.get_loggernet_station(station.loggernet)
			if(typeof lstation !== 'undefined') {
				data_table_list = tr.list_table_names(lstation.data_tables)
				if(data_table_list != "") {
					ss_json = tr.update_external_ref(ss_json,"loggernet.data_tables",data_table_list)
					//console.log("\texternal_refs:loggernet.data_tables:",data_table_list)
					ss_station_count++
				} else {
					ss_no_station_count++
					console.log(ss_filename,"external_refs:loggernet.data_tables: NO tables found.")
				}			
			} else if(typeof station.goes !== 'undefined') {
				ss_json = tr.update_external_ref(ss_json,"loggernet.data_tables","TenMin")
				ss_station_count++
			} else if(station.name.match(/WhiteMt/)) {
				console.log(ss_filename,"White Mountain is maintained by DRI. No external references.")
			} else {
				ss_no_station_count++
				console.log(ss_filename,"NO MATCH! in loggernet station list. No data tables for external refs")
			}

			// Write JSON file
			ss_json_string = JSON.stringify(ss_json,null,2)
			fs.writeFileSync(ss_path+ss_filename,ss_json_string,'utf-8')
		}	
	} else {
		console.log("Not JSON file!",ss_filename)
	}
}

console.log('DONE! '+ss_match_count+' Stations processed out of',ss_count,'with',ss_no_match_count,'not matched.')
console.log('DONE! loggernet stations matched',ss_station_count,'NOT matched',ss_no_station_count)


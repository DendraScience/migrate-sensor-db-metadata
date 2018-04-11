/*
Station ID & External References inserter to Datastreams 
@author: Collin Bode
@date: 2018-02-28
@updated: 2018-03-26

Purpose: runs through datastream directories and 
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
console.log("\n Datastreams External References Inserter starting \n")

fs = require("fs")
tr = require("./transform_functions.js")

args = process.argv.slice(2)
parent_path = args[0] // Requires trailing slash, e.g. "../data/migration2.1-rivendell/"
org_slug = args[1] // "erczo" or "ucnrs"
path = parent_path+org_slug+"/" 
console.log('usage: node transform-sensordb-stationid-inserter.js <migration_path/> <organization_slug>')

// Load static list of stations
stations = JSON.parse(fs.readFileSync("stations.json"))
stations_loggernet = JSON.parse(fs.readFileSync("stations_loggernet.json"))
console.log('number of stations:',stations.list.length)


// DATASTREAMS
// counters
ds_count = 0
no_match_count = 0
match_count = 0
ds_no_station_count = 0
ds_too_many_tables_count = 0

// Get list of Datastreams from directory
ds_path = path + 'datastream/'
ds_files = fs.readdirSync(ds_path)
console.log('\nDatastream Path:',ds_path,"files found:",ds_files.length)

// Loop through Datastream JSON files 
for(var i=0;i<ds_files.length;i++) {
	station = ""
	ds_filename = ds_files[i]
	if (ds_filename.match(/.json$/)) {
		ds_count++
		ds_json = JSON.parse(fs.readFileSync(ds_path+ds_filename))
		//console.log(ds_json.name,"file:",ds_filename)

		// Get Station ID from external refs
		// Get Station object & odm id
		ds_station_id = tr.get_external_ref(ds_json,"odm.stations.StationID")
		//console.log('\texternal_refs:odm.stations.StationId:',ds_station_id)
		station = tr.get_station(ds_station_id)		
		
		if(station == "") {
			console.log(ds_json.name," had NO STATION match! Skipping")
			no_match_count++
		} else {

			// Assign Station Mongo ID, replacing the odm station id
			ds_json.station_id = station._id
			//console.log("\tstation_id:",ds_json.station_id)
			
			// Update "enabled" status to false if station is innactive
			if(typeof station.enabled !== 'undefined' && station.enabled == false) {
				ds_json.enabled = false
			}  

			// Update external references for loggernet and goes
			// LoggerNet station name for parent station
			if(typeof station.loggernet !== 'undefined') {
				//console.log('\texternal_refs:loggernet.station:',station.loggernet)
				ds_json = tr.update_external_ref(ds_json,"loggernet.station",station.loggernet)
			}
			
			// LoggerNet station ldmp or goes for parent station
			if(typeof station.goes === 'undefined') {
				if(org_slug == "erczo") {
					ldmp = "208.186.56.6:1024"
				} else if(org_slug == "ucnrs" || org_slug == "sagehen") {
					ldmp = "wanda.berkeley.edu:1024"
				} else {
					console.log(ds_json.name,'ORGANIZATION NOT FOUND! No ldmp inserted')
				}
				if(typeof ldmp !== 'undefined') {
					//console.log('\texternal_refs:loggernet.ldmp:',ldmp)
					ds_json = tr.update_external_ref(ds_json,"loggernet.ldmp",ldmp)
				}
			} else {
				//console.log('\texternal_refs:goes.address:',station.goes)
				ds_json = tr.update_external_ref(ds_json,"goes.address",station.goes)
			}

			// Add Data Table to external references
			if(typeof station.loggernet !== 'undefined') {
				lstation = tr.get_loggernet_station(station.loggernet)
				if(typeof lstation !== 'undefined') {
					table_str = ""
					// Only one data table makes life simple. Assign
					if(lstation.data_tables.length == 1) {
						ds_json = tr.update_external_ref(ds_json,"loggernet.table",lstation.data_tables[0].name)
						//console.log("\texternal_refs.loggernet.table:",lstation.data_tables[0].name)
					} else {
						// Multiple tables requires some logic to choose the right one
						// GOES satellite tables are one of two: SatTen for old code and GOES_TenMin for new.
						if(typeof station.goes !== 'undefined') {
							if(tr.find_table(lstation.data_tables,"SatTen")) {
								ds_json = tr.update_external_ref(ds_json,"loggernet.table","SatTen")
								//console.log("\texternal_refs.loggernet.table: SatTen")
							} else if(tr.find_table(lstation.data_tables,"GOES_TenMin")) {
								ds_json = tr.update_external_ref(ds_json,"loggernet.table","GOES_TenMin")
								//console.log("\texternal_refs.loggernet.table: GOES_TenMin")
							} else {
								console.log("\tWARNING! GOES ADDRESS FOUND, BUT NO GOES TABLE LISTED.")
							}
						// LoggerNet stations (non-GOES) can have any table name, but UCNRS is all TenMin
						// ERCZO has one station with TenMin (even though its 5min)
						} else if(tr.find_table(lstation.data_tables,"TenMin")) {
								ds_json = tr.update_external_ref(ds_json,"loggernet.table","TenMin")
								//console.log("\texternal_refs.loggernet.table: TenMin")
						} else {
						// Level 6 has 3 tables, these may just need to be done by hand
							ds_too_many_tables_count++
							console.log(ds_json.name,"TOO MANY TABLES found. not updating loggernet.table",lstation.data_tables.length)
						}
					}
				} else {
					console.log(ds_json.name,"NO MATCH! in loggernet station list. not updating loggernet.table")
					ds_no_station_count++
				}
			}

			// Write JSON file
			ds_json_string = JSON.stringify(ds_json,null,2)
			//console.log('Writing Datastream to file',ds_filename)
			match_count++
			fs.writeFileSync(ds_path+ds_filename,ds_json_string,'utf-8')
		
		}	
	} else {
		console.log("Not JSON file!",ds_filename)
	}
}

console.log('DONE! '+match_count+' Datastreams processed out of',ds_count,'with',no_match_count,'not matched.')
console.log('DONE! Datastreams without loggernet station matches',ds_no_station_count)
console.log('DONE! Datastreams with too many loggernet tables:',ds_too_many_tables_count)
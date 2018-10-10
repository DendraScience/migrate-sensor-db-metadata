/*
 Fix UCNRS precip 
 @author: Collin Bode
 @date: 2018-10-06
 Purpose: precipitation mixes inches with millimeters. Goes through all the datastreams and fixes this by creating two influx configs. one converts inches to millimeters.
 Requires: ucnrs_precip_change_dates.json file 
 Exceptions:  too many variables to engineer in short time period. The following require manual adjustment.
 Fort Ord: Change the start date for cumulative and for legacy
	pnew_start: 2018-02-09T23:10:00Z
  cpnew_start: 2018-05-02T20:30:00Z


*/

fs = require("fs")
tr = require("./transform_functions.js")
path = require("path")

// load the date change file
date_changes = JSON.parse(fs.readFileSync("ucnrs_precip_change_dates.json"))

function match_station2date(sid) {
	for(var i=0;i<date_changes.length;i++) {
  	stationjs = date_changes[i]
  	//console.log(stationjs.station_name)
  	if(stationjs.station_id == sid) {
  		//console.log("MATCH!",stationjs.station_name,stationjs.station_id,"==",sid)
  		return stationjs
  	}
	}
	return ""
}  

// Run through migration3 directories gather list of path & files
start_path = '/Users/collin/git/migrate-sensor-db-metadata/data/migration3-incidents/ucnrs/'
filepath_list = []
tr.recurse_dir(start_path,filepath_list,RegExp(/^precip((?!seasonal).)*$/i)) // Note: RegEx prevents seasonal from showing up
console.log("Traverse complete. list length:",filepath_list.length)

// Process each Precip file 
for (var l=0;l<filepath_list.length;l++) {
	dir = filepath_list[l][0]
	file = filepath_list[l][1]
	full_path = path.join(dir, file)
	ds = JSON.parse(fs.readFileSync(full_path))
	console.log("FILE:",file)

	// Backup JSON file in case of fuckups
	fs.writeFileSync("../compost/temp_backup_precip/"+file,ds_json_string,'utf-8')

	// Get the InfluxDB dates for pre-core fields and core fields
	stationjs = ""
	stationjs = match_station2date(ds.station_id)	
	if(stationjs == "") {
		console.log("\t Not on list. skipping...",file)
		continue
	}

	// Dates Change 
	transition_date = "2018-04-25T00:00:00.000Z"
	// normal precip
	pold_start = stationjs.precip_old_date_start
	pold_end = stationjs.precip_old_date_end
	pnew_start = stationjs.precip_new_date_start
	// cumulative precip
	cpold_start = stationjs.cumprecip_old_date_start
	cpold_end = stationjs.cumprecip_old_date_end
	cpnew_start = stationjs.cumprecip_new_date_start


	// Check to see if there are already two influx configs. If so, skip
	p = 0
	conf_count = ds.datapoints_config.length
	for(var j=0;j<conf_count;j++) {
		conf = ds.datapoints_config[j]
		if(conf.path == "/influx/select") {
			p++
		}
	}
	if(p != 1) {
		console.log("\t Config p != 1. Either multiple influx configs or none. skipping...")
		continue
	} 


	// Set up configuration JSON objects
	// Retrieve conf_legacy and conf1, then copy conf1 to conf2
	conf_legacy = {}
	conf_old = {}
	conf_new= {}
	conf_legacy_count = 0
	conf_influx_count = 0
	for(var k=0;k<conf_count;k++) {
		conf = ds.datapoints_config[k]				
		if(conf.path == "/legacy/datavalues-ucnrs") {
			conf_legacy = JSON.parse(JSON.stringify(conf))
			conf_legacy_count = k
		} else if(conf.path == "/influx/select") {
			delete conf.params.query.coalesce
			conf_old = JSON.parse(JSON.stringify(conf))
			conf_new = JSON.parse(JSON.stringify(conf))
			conf_influx_count = k
		} else {
			console.log("\t ERROR! no conf path detected!")
			break
		}
		//delete ds.datapoints_config[k]
	}	
			
	// Does old value exist?
	boo_old_exists = true
	if(pold_start == "") {
		console.log("\t --<NO OLD>-- Don't create second conf.")
		boo_old_exists = false
	}

	// Modify legacy end date
	legacy_end = conf_legacy.ends_before
	if(boo_old_exists == true) {
		lend = pold_start		
	} else {
		lend = pnew_start
	} 
	conf_legacy.ends_before = lend
	console.log("\t conf_LEGACY old:",legacy_end,"--> new:",lend)

	// CONF_OLD?
	if(boo_old_exists == true) {
		// conf_old start date
		conf_old.begins_at = pold_start				
		// conf_old end date
		if(pold_end < pnew_start) {
			conf_old.ends_before = pold_end
			console.log("\t @CONF_OLD END OLD (there may be a time gap")
		} else if(pold_end > pnew_start) {
			conf_old.ends_before = pnew_start
			console.log("\t @CONF_OLD END NEW startdate")
		} else {
			console.log("\t @CONF_OLD something wrong!")
			break
		}
	}

	// CONF_NEW
	conf_new.begins_at = pnew_start

	// Fix the Coalesce line in the configurations by separating the values
	boo_write_to_file = true

	if(/PCPN_in_Tot/i.test(conf_new.params.query.sc)) {
		conf_old.params.query.sc = "\"time\", \"PCPN_in_Tot\" * 25.4 AS \"PCPN_intrvl_Tot\""					
		conf_new.params.query.sc = "\"time\", \"PCPN_intrvl_Tot\""		
		console.log("\t replaced sc for normal precip")			
	} else if(/PCPN_tot/i.test(conf_new.params.query.sc)) {
		conf_old.params.query.sc = "\"time\", \"PCPN_tot\" * 25.4 AS \"PCPN_accumulated\""
		conf_new.params.query.sc = "\"time\", \"PCPN_accumulated\""
		ds.description = "Cumulative precipitation is the total rainfall from October 1 to the timetamp of recording. It is reset every Oct. 1. This is done on logger."
		console.log("\t replaced sc for cumulative precip")
	} else {
		console.log("\t standard fields NOT FOUND. skipping...")
		boo_write_to_file = false
	}

	// Add the configurations back into the datastream
	//ds.datapoints_config.push(conf_legacy)
	ds.datapoints_config[conf_legacy_count] = conf_legacy
	if(boo_old_exists == true) {
		ds.datapoints_config.push(conf_old)
	}
	//ds.datapoints_config.push(conf_new)
	ds.datapoints_config[conf_influx_count] = conf_new

	// If changes have been made to file, export
	if(boo_write_to_file == true) {
		ds_json_string = JSON.stringify(ds,null,2)
		console.log("\t Processed! InfluxDB config_points changed. Writing FILE:",file)
		//fs.writeFileSync("../compost/temp_precip/"+file,ds_json_string,'utf-8')
		fs.writeFileSync(full_path,ds_json_string,'utf-8')
	}
	//console.log(ds.name,ds.datapoints_config)
}
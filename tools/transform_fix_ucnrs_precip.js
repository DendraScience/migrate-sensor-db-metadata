/*
 Fix UCNRS precip 
 @author: Collin Bode
 @date: 2018-10-06
 Purpose: precipitation mixes inches with millimeters. Goes through all the datastreams and fixes this by creating two influx configs. one converts inches to millimeters.
 Requires: ucnrs_precip_change_dates.json file 
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
  		return stationjs.change_date
  	}
	}
	return ""
}  

// Run through migration 3 directories
start_path = '/Users/collin/git/migrate-sensor-db-metadata/data/migration3-incidents/ucnrs/'
filepath_list = []
tr.recurse_dir(start_path,filepath_list,RegExp(/^precip((?!seasonal).)*$/i))
console.log("Traverse complete. list length:",filepath_list.length)

// Process each Precip file 
for (var l=0;l<filepath_list.length;l++) {
	dir = filepath_list[l][0]
	file = filepath_list[l][1]
	console.log("FILE:",file)

	full_path = path.join(dir, file)
	ds = JSON.parse(fs.readFileSync(full_path))
	date_change = ""
	date_change = match_station2date(ds.station_id)
	//console.log(file,date_change)
	if(date_change == "") {
		console.log("\t Not on list. skipping...",file,ds.name,",date_change:",date_change)
	} else {
		//console.log(ds.name,date_change)
		// Check to see if there are already two influx configs. If so, skip
		p = 0
		conf_count = ds.datapoints_config.length
		for(var j=0;j<conf_count;j++) {
			conf = ds.datapoints_config[j]
			if(conf.path == "/influx/select") {
				p++
			}
		}
		//console.log(ds.name,date_change,"Influx configs:",p,"total configs:",ds.datapoints_config.length)
		
		// Process config and duplicate
		if(p != 1) {
			console.log("\t Config p != 1. Either multiple influx configs or none. skipping...")
		} else {
			//console.log(ds.name,"config INFLUX okay")
			for(var k=0;k<conf_count;k++) {
				conf = ds.datapoints_config[k]				
				if(conf.path == "/influx/select") {
					//console.log("\t datapoints_config",k,conf_count,ds.datapoints_config.length)
					delete conf.params.query.coalesce
					conf2 = JSON.parse(JSON.stringify(conf))
					conf.ends_before = date_change
					conf2.begins_at = date_change
					boo_write_to_file = false
					console.log("\t sc:",conf.params.query.sc)
					//if(conf.params.query.sc == "\"time\", \"PCPN_in_Tot\",\"PCPN_intrvl_Tot\"") {
					if(/PCPN_in_Tot/i.test(conf.params.query.sc)) {
						conf.params.query.sc = "\"time\", \"PCPN_in_Tot\" * 25.4 AS \"PCPN_intrvl_Tot\""					
						conf2.params.query.sc = "\"time\", \"PCPN_intrvl_Tot\""		
						console.log("\t replaced sc for normal precip")		
						boo_write_to_file = true		
					//} else if(conf.params.query.sc == "\"time\", \"PCPN_accumulated\",\"PCPN_tot\"") {
					} else if(/PCPN_tot/i.test(conf.params.query.sc)) {
						conf.params.query.sc = "\"time\", \"PCPN_tot\" * 25.4 AS \"PCPN_accumulated\""
						conf2.params.query.sc = "\"time\", \"PCPN_accumulated\""
						ds.description = "Cumulative precipitation is the total rainfall from October 1 to the timetamp of recording. It is reset every Oct. 1. This is done on logger."
						console.log("\t replaced sc for cumulative precip")
						boo_write_to_file = true
					} else {
						console.log("\t standard fields NOT FOUND. skipping...")
						boo_write_to_file = false
					}
					console.log("\t sc:",conf.params.query.sc)
					ds.datapoints_config.push(conf2)
					//console.log("\t conf",conf.params.query.sc)
					//console.log("\t conf2",conf2.params.query.sc)
				} 
			}

			// If changes have been made to file, export
			if(boo_write_to_file == true) {
				ds_json_string = JSON.stringify(ds,null,2)
				console.log("\t Processed! InfluxDB config_points changed. Writing FILE:",file)
				fs.writeFileSync("../compost/temp_precip/"+file,ds_json_string,'utf-8')
			}
			//console.log(ds.name,ds.datapoints_config)
		}
	}
}

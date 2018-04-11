/*
@author: collin bode
@date: 2018-03-27
Purpose: 
To merge the manually created stations.json file with 
stations_loggernet.json file, which was extracted from
 xml configuration.
*/

fs = require('fs')

man_stations = JSON.parse(fs.readFileSync('stations.json'))
log_stations = JSON.parse(fs.readFileSync('stations_loggernet.json'))

function get_mstation(stations,station_name) {
  for(var i=0;i<stations.list.length;i++) {
    station = stations.list[i]
    if(station.loggernet == station_name) {
      //console.log("FOUND! ",station.loggernet, station.station_id,station._id)
      return station
    }
  }
}

function get_lstation(stations,station_name) {
  for(var i=0;i<stations.length;i++) {
    station = stations[i]
    if(station.name == station_name) {
      //console.log("FOUND! ",station.name)
      return station
    }
  }
}

// Find which loggernet stations match
match_count = 0
no_loggernet_match = []
multiple_tables_count = 0
ucnrs_multiple_count = 0 
erczo_multiple_count = 0
console.log('START matching stations')
for (var j=0;j<log_stations.length;j++) {
	lstation = log_stations[j]
	//console.log(lstation.name)
	mstation = get_mstation(man_stations,lstation.name)
	if(typeof mstation !== 'undefined') {
		match_count++
		//console.log(lstation.name,"<-->",mstation.loggernet)
	} else {
		no_loggernet_match.push(lstation.name)
	}
	// How many data tables per station?
	table_count = lstation.data_tables.length
	if(table_count > 1 && !lstation.name.match("Station")) {
		multiple_tables_count++
		if(lstation.organization_slug == "ucnrs") {
			ucnrs_multiple_count++
		}
		if(lstation.organization_slug == "erczo") {
			console.log(lstation.name,"erczo has multiple tables!")
			erczo_multiple_count++
		}
		for(var m=0;m<table_count;m++) {
				table = lstation.data_tables[m].name
				console.log("\t",lstation.name,table)
				if(table == "TenMin") {
					console.log(lstation.name,"has TenMin table",table)
				}
		} 
	}
	console.log(lstation.name,table_count)
	// Sagehen decrepit stations
	//if(lstation.name.match("Station")) {
	//	console.log('Sagehen!',lstation.name)
	//}
}
man_count = man_stations.list.length
log_count = log_stations.length
console.log("Stations matched:",match_count,"Manual stations:",man_count,"Loggernet:",log_count)
console.log("Stations with multiple data tables:",multiple_tables_count)
console.log("UCNRS stations with multiple data tables:",ucnrs_multiple_count)
console.log("ERCZO stations with multiple data tables:",erczo_multiple_count)
//console.log("Loggernet Stations not matched:",no_loggernet_match)
/*
// Find which manual stations are not matched
no_man_match = []
mmatch_count = 0
for (var j=0;j<man_stations.list.length;j++) {
	mstation = man_stations.list[j]
	console.log(j,mstation.loggernet)
	lstation = get_lstation(log_stations,mstation.loggernet)
	if(typeof lstation !== 'undefined') {
		mmatch_count++
		//console.log(lstation.name,"<-->",mstation.loggernet)
	} else {
		no_man_match.push(mstation.loggernet)
	}
}
console.log("Manual Stations not matched:",no_man_match)

*/
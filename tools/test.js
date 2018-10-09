//test
fs = require("fs")
tr = require("./transform_functions.js")
path = require("path")
start_path = '/Users/collin/git/migrate-sensor-db-metadata/data/migration3-incidents/ucnrs/'

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


for(var i=0;i<date_changes.length;i++) {
  
  stationjs = date_changes[i]
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

	console.log(stationjs.station_name)//,stationjs.table)
	console.log("\t transition:",transition_date)
	console.log("\t pold_start:",pold_start)
	console.log("\t pold_end:",pold_end)
	console.log("\t pnew_start:",pnew_start)
	//console.log("\t cpold_start:",cpold_start)
	//console.log("\t cpold_end:",cpold_end)
	console.log("\t cpnew_start:",cpnew_start)

	// are normal and cumulative different?
	if(pold_start != cpold_start || pold_end != cpold_end || pnew_start != cpnew_start) {
		console.log("\t !!NOT THE SAME!!")  // Fort Ord only one
	}

	// is old ever older than new?
	if(pold_end > pnew_start || cpold_end > cpnew_start) {
		console.log("\t ***OLD IS NEWER!***")  // Chickering and Dawson
	}

	boo_old_exists = true

	// Does old value exist?
	if(pold_start == "") {
		console.log("\t --<NO OLD>-- Don't create second conf.")
		boo_old_exists = false
	}

	// Modify legacy conf?
	if(boo_old_exists == true) {
		console.log("\t @MODIFY LEGACY ENDING OLD startdate")
	} else if(pnew_start < transition_date) {
		console.log("\t @MODIFY LEGACY ENDING NEW startdate")
	} else {
		console.log("\t @LEGACY unchanged")
	}

	// Dates for conf1?
	// start
	if(boo_old_exists == true && pold_start < transition_date) {
		console.log("\t @MODIFY CONF1 START OLD startdate")
	} else if(pnew_start < transition_date) {
		console.log("\t @MODIFY CONF1 START NEW startdate")
	} else {
		console.log("\t @CONF1 unchanged")
	}
	// end
	if(boo_old_exists == true && pold_end < pnew_start) {
		console.log("\t @MODIFY CONF1 END OLD enddate (there may be a time gap")
	} else if(boo_old_exists == true && pold_end > pnew_start) {
		console.log("\t @MODIFY CONF1 END NEW startdate")
	} else if(boo_old_exists == false){
		console.log("\t @CONF1 NO END unchanged")
	} else {
		console.log("\t CONF1 wtf?")
	}

	// Dates for conf2
	// start only 
	if(boo_old_exists == true) {
		console.log("\t @CREATE CONF2 START NEW, NO END")
	}

	// is new after transition date?
	if(boo_old_exists == false && pnew_start > transition_date) {
		console.log("\t +++NEW AFTER TRANSITION+++")
	}
	/*
	if(transition_date > pold_start) {
		console.log("\t tran more recent than old data start")
	} else if(transition_date > pold_start) {
		console.log("\t tran more older than old data start")
	} else {
		console.log("\t wtf?")
	}
	*/
}
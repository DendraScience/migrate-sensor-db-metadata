/*
@author: Collin Bode
@date: 2018-03-28
Purpose: use external references to construct influx datapoint config for datastreams.

"dpc": functions are for "datapoints_config"

Scott recommends making FieldNames InfluxDB-safe
let unsafeFieldName = "WS_mph_WVc(4)"
let safeFieldName = unsafeFieldName.replace(/\W/g, '_')

SENSOR DATABASE
"datapoints_config": [
  {
    "begins_at": "2008-11-25T19:50:00.000Z",
    "params": {
      "query": {
        "compact": true,
        "datastream_id": 1783,
        "time_adjust": -28800
      }
    },
    "path": "/legacy/datavalues2"
  }
]

INFLUXDB
"datapoints_config": [
  {
    "params": {
      "query": {
        "db": "station_quail_ridge",
        "sc": "\"time\", \"TC_C_2_Max\"",
        "fc": "ten_minute_data",
        "utc_offset": -28800
      }
    },
    "begins_at": "2017-06-07T13:00:00.000Z",
    "path": "/influx/select"
  }
]
*/

console.log("\n Datastream Influx config starting \n")

fs = require("fs")
tr = require("./transform_functions.js")
//core8 = JSON.parse(fs.readFileSync("ucnrs_core8.json"))

args = process.argv.slice(2)
parent_path = args[0] // Requires trailing slash, e.g. "../data/migration2.1-rivendell/"
org_slug = args[1] // "erczo" or "ucnrs"
//path = parent_path+org_slug+"/" 
path = "../data/migration2.1-rivendell/ucnrs_test/"
console.log('usage: node transform-sensordb-stationid-inserter.js <migration_path/> <organization_slug>')
console.log('path:',path)

// CONSTANTS
sensordb_end_date = "2018-04-17T00:00:00Z"
influxdb_start_date = sensordb_end_date

function dpc_set_enddate(dd_json,new_enddate,position,options) {
	// position = integer of which config to choose out of the list
	// options = "create" if doesn't exist,"force" alsways changes,"newer" compares the dates
	dpc = dd_json.datapoints_config[position]
	if(typeof dpc.ends_before === "undefined" || options == "force") {
		dpc.ends_before = new_enddate
		boochanged = true
	} else if(options == "newer") {
		curdate = new Date(dpc.ends_before)
		newdate = new Date(new_enddate)
		if(newdate.getTime() > curdate.getTime()) {
			dpc.ends_before = new_enddate
		}
	}
	dd_json.datapoints_config[position] = dpc
	return dd_json
}

function dpc_get_type(dd_json,j) {
	if(dd_json.datapoints_config[j].path.match("legacy")){
		dpc_type = "SensorDB"
	} else if(dd_json.datapoints_config[j].path.match("influx")) {
		dpc_type = "InfluxDB"
	}
	return dpc_type
}

function dpc_create_influxdb_from_extref(dd_json,start_date,end_date="") {
  org_slug = tr.get_org_slug(dd_json.organization_id)
  station = tr.get_external_ref(dd_json,"loggernet.station")
  database = "station_"+station
  table = "source_"+tr.get_external_ref(dd_json,"loggernet.table")
  if(org_slug == "ucnrs") {
  	fieldname = tr.get_fieldname_ucnrs_match_dsname(dd_json)
  } else if(typeof tr.get_external_ref(ds_json,"odm.datastreams.FieldName") !== 'undefined') {
  	fieldname = tr.get_external_ref(dd_json,"odm.datastreams.FieldName") 
  }
  // check that all params are there, then create datapoints config
  // Note: the replace() function removes ([ and other unsafe characters from fieldname])
  if(typeof org_slug !== 'undefined' && station !== 'undefined' && typeof table !== 'undefined' && typeof fieldname !== 'undefined') {
	  dpc = {
	    "params": {
	      "query": {
	      	"api": org_slug.replace(/\W/g, '_'),
	        "db": database,   //"station_quail_ridge", or "station_ucac_angelo"
	        "fc": table.toLowerCase().replace(/\W/g, '_'), 			//"ten_minute_data",
	        "sc": "\"time\", \""+fieldname.replace(/\W/g, '_')+"\"",
	        "utc_offset": -28800
	      }
	    },
	    "begins_at": start_date,
	    "path": "/influx/select"
	  }
	  if(end_date != "") {
	  	dpc.ends_before = end_date
	  }
	  dd_json.datapoints_config.push(dpc)
	  //console.log(dd_json.name,dd_json.datapoints_config)
  	return dd_json
	} else {
		console.log("\tSKIP. WARNING! INPUT VALUES INCOMPLETE",dd_json.name)
	}
}

/*
// Load static list of stations
stations = JSON.parse(fs.readFileSync("stations.json"))
stations_loggernet = JSON.parse(fs.readFileSync("stations_loggernet.json"))
console.log('number of stations:',stations.list.length)
*/

// DATASTREAMS
// counters
ds_count = 0
skipped_count = 0
influx_dpc_count = 0

// Get list of Datastreams from directory
ds_path = path + 'datastream/'
ds_files = fs.readdirSync(ds_path)
//console.log('\nDatastream Path:',ds_path,"files found:",ds_files.length)
// Loop through Datastream JSON files 
for(var i=0;i<ds_files.length;i++) {
	ds_filename = ds_files[i]
	if (ds_filename.match(/.json$/)) {
		ds_count++
		boo_skip = true
		ds_json = JSON.parse(fs.readFileSync(ds_path+ds_filename))
		//console.log(ds_json.name,"file:",ds_filename)

		// investigate existing datapoints_configs
		dpc_count = ds_json.datapoints_config.length
		//console.log("\tdatapoints_config:",dpc_count)
		boo_influxdb_exists = false
		dpc_bsdb_position = -999
		for(var j=0;j<dpc_count;j++) {
			dpc_type = dpc_get_type(ds_json,j)
			//console.log("\t",j,dpc_type)
			if(dpc_type == "InfluxDB") { boo_influxdb_exists = true }
			if(dpc_type == "SensorDB") {
				dpc_bsdb_position = j
			}
		}

		// create a new influx config or update existing with same start-date 
		// if the datastream qualifies. below are the conditionals
		if(ds_json.enabled == false) {
			console.log("\tSKIP. Innactive. enabled:",ds_json.enabled)
		// Must have external references to build influx datapoints_config
		} else if(typeof ds_json.external_refs === 'undefined') {
			console.log("\tSKIP. No external references.")
		// Do not create influx config if one already exists
		} else if(boo_influxdb_exists == true) {
			console.log("\tSKIP. boo_influxdb_exists:",boo_influxdb_exists)
		// Do not create influx config for derived datastreams
		} else if(typeof tr.get_external_ref(ds_json,"odm.datastreams.DerivedID") !== 'undefined') {
			console.log("\tSKIP. Derived dataset.")
		// Must has a fieldname if ERCZO, Not necessary if UCNRS
		} else if(typeof tr.get_external_ref(ds_json,"odm.datastreams.FieldName") === 'undefined' && org_slug != "ucnrs") {
			console.log("\tSKIP. FieldName not listed",tr.get_external_ref(ds_json,"odm.datastreams.FieldName"))
		// Must exist in sensor database 					
		} else {
			if(dpc_bsdb_position != -999) {
				ds_json = dpc_set_enddate(ds_json,sensordb_end_date,dpc_bsdb_position,"create") 
			} else {
				console.log("\tNO SensorDB config.")
			}
			
			// FINALLY actually create a datapoints_config
			dt_json = dpc_create_influxdb_from_extref(ds_json,influxdb_start_date)
			if(typeof dt_json === 'undefined') {
				console.log("\tSKIP. not processed.")
			} else {
				boo_skip = false
				influx_dpc_count++
				// Write JSON file
				ds_json_string = JSON.stringify(ds_json,null,2)
				//console.log("\tProcessed! InfluxDB config_points created. Writing file:",ds_filename)
				//fs.writeFileSync(ds_path+ds_filename,ds_json_string,'utf-8')
			}
		}
		if(boo_skip == true) {
			skipped_count++
		} 
	} else {
		console.log("Not JSON file!",ds_filename)
	}
}
console.log("transform-sensordb-influxconfig.js complete.  Datastreams processed:",influx_dpc_count,"skipped:",skipped_count,"of total files",ds_count)
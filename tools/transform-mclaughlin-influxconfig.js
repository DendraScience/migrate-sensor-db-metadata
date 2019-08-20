/*
@author: Collin Bode
@date: 2018-03-28
Purpose: Construct influx datapoint config for McLaughlin datastreams.

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

console.log("\n Mclaughlin Datastream Influx config starting \n")

fs = require("fs")
tr = require("./transform_functions.js")
//core8 = JSON.parse(fs.readFileSync("ucnrs_core8.json"))

path = "../data/ucnrs/station/mclaughlin/" 
//out_path = "../compost/mclaughlin/"
out_path = path

if(fs.existsSync(path) == false) {
	console.log('usage: node transform-mclaughlin-influconfig.js')
	console.log("\tDIR does not exist! Skipping.",path)
	process.exit()
}
console.log("Datastreams DIR:",path)

// CONSTANTS
influxdb_start_date = "2017-02-01T11:10:00Z" //"2018-04-10T00:00:00Z"

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

function get_core8_fieldname(dri_fieldname,station_id) {
	dri2c8 = JSON.parse(fs.readFileSync("DRI_to_Core8.json"))
	for(var i=0;i<dri2c8.length;i++) {
		dri = dri2c8[i].FieldName 
		//console.log(dri_fieldname,"=?=",dri)
		if(dri == dri_fieldname) {
			station_tables = JSON.parse(fs.readFileSync("stations.json"))
			for(var q=0;q<station_tables.list.length;q++) {
				station = station_tables.list[q]
				//console.log("\ttesting",station.name,station_id,"=?=",station._id)
				if(station_id == station._id) {
					//console.log("\tfound station:",station.name)
					tabletype = station_tables.list[q].table_type
					if(tabletype == "Core8_TenMin") {
						field = dri2c8[i].Core8_TenMin
						field2 = dri2c8[i].TenMin
					} else if(tabletype == "GOES_TenMin") {
						field = dri2c8[i].GOES_TenMin
						field2 = dri2c8[i].SatTen
					} else if(tabletype == "SatTen") {
						field = dri2c8[i].SatTen
						field2 = dri2c8[i].GOES_TenMin
					} else if(tabletype == "TenMin") {
						field = dri2c8[i].TenMin
						field2 = dri2c8[i].Core8_TenMin
					} else if(tabletype == "DRI") {
						console.log("get_core8_fieldname: DRI managed. no influx.")
						return
					} else {
						console.log("get_core8_fieldname: Field NOT FOUND. dri:",dri_fieldname,"station:",station.name)
						return
					}	
					//console.log("MATCH!",dri_fieldname,"==",dri,"-->",field,"<--",tabletype)
					return [field,field2]
				}
			}
		}
	}
}

function dpc_create_influxdb_from_extref(dd_json,start_date,end_date="") {
	boo_coalesce = true
	// Set up config parts, except fieldname
	// Organization 
  org_slug = tr.get_org_slug(dd_json.organization_id)
  org_api = org_slug.replace(/\W/g, '_')
  // Database - based on the station name
  station_name = tr.get_external_ref(dd_json,"loggernet.station")
  if(typeof station_name === 'undefined') {
  	console.log("dpc_create_influxdb_from_extref: ERROR!",dd_json.name," no station found in loggernet config.")
  	return
  }
  database = "station_"+station_name.toLowerCase().replace(/\W/g, '_')
  // Measurement Table - based on the loggernet table name
  loggernet_table = "tenmin" //tr.get_external_ref(dd_json,"loggernet.table")
  if(typeof loggernet_table !== 'undefined') {
  	table = "source_"+loggernet_table.toLowerCase().replace(/\W/g, '_')
  } else {
    console.log("dpc_create_influxdb_from_extref: ERROR!",dd_json.name," no loggernet_table found in external references.")
  	return
  }
  // Fieldname manipulations
  if(typeof tr.get_external_ref(dd_json,"odm.datastreams.FieldName") === 'undefined') {
  	console.log("dpc_create_influxdb_from_extref: ERROR!",dd_json.name," no FieldName found.")
  	return 
  } else {
  	fieldname = tr.get_external_ref(dd_json,"odm.datastreams.FieldName") 
  	console.log(station_name,table,fieldname)
    // UCNRS sensor database fields are from DRI. Convert to Core8
    if(org_slug == "ucnrs") {
	  	//fieldname = tr.get_fieldname_ucnrs_match_tags(dd_json)
	  	//console.log(dd_json.name,fieldname)
	  	fields = get_core8_fieldname(fieldname,dd_json.station_id)
	  	if(typeof fields === 'undefined') {
	  		console.log(dd_json.name,fieldname,"NOMATCH Core8 Fieldname not found!")
	  		return
	  	}
	  	console.log(station.name,fields)
	  	core8field = fields[0]
	  	field2 = fields[1]
	  	fieldname = core8field.replace(/\W/g, '_')
	  	// Solar Exception: need watts/meter squared for Dashboard
	  	if(fieldname.match(/RS_kw_m2/)) { 
				//"sc": "\"time\", \"RS_kw_m2_Avg\"*1000 as \"RS_w_m2_Avg\""
				oldfieldname = fieldname
				newfieldname = oldfieldname.replace("RS_kw_m2","RS_w_m2")
				fieldname = oldfieldname+"\"*1000 as \""+newfieldname
				console.log("SOLAR",dd_json.name,"o:",oldfieldname,"-->",fieldname)
				boo_coalesce = false
			} else if(fieldname.match(/PAR/)) { 
				//"sc": "\"time\", \"PAR_Avg\"*1000 as \"PAR_Avg\""
				oldfieldname = fieldname
				fieldname = oldfieldname+"\"*1000 as \""+oldfieldname
				console.log("PAR",dd_json.name,"o:",oldfieldname,"-->",fieldname)
				boo_coalesce = false
		  } else if(core8field == field2) { 
		  	fieldname = core8field.replace(/\W/g, '_')
		  	boo_coalesce = false
		  } else {
			  fieldname = core8field.replace(/\W/g, '_')+"\",\""+field2.replace(/\W/g, '_')
		  }
		} else {
			fieldname.replace(/\W/g, '_')
			boo_coalesce = false
		}
  } 

  // check that all params are there, then create datapoints config
  // Note: the replace() function removes ([ and other unsafe characters from fieldname])
  if(typeof org_api !== 'undefined' && database !== 'undefined' && typeof table !== 'undefined' && typeof fieldname !== 'undefined') {
	  console.log("db:",database,"fc:",table,"sc:",fieldname,",coalesce:",boo_coalesce,"<--",tr.get_external_ref(dd_json,"odm.datastreams.FieldName"))
	  dpc = {
	    "params": {
	      "query": {
	      	"api": org_api,
	        "db": database,   //"station_quail_ridge", or "station_ucac_angelo"
	        "fc": table, 			//"source_tenmin"
	        "sc": "\"time\", \""+fieldname+"\"",
	        "utc_offset": -28800,
	        "coalesce": boo_coalesce
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
ds_path = path
ds_files = fs.readdirSync(ds_path)
console.log('\nDatastream Path:',ds_path,"files found:",ds_files.length)


// Loop through Datastream JSON files 
for(var i=0;i<ds_files.length;i++) {
	ds_filename = ds_files[i]
	if (ds_filename.match(/datastream.json$/)) {
		ds_count++
		boo_skip = true
		skipped_count++
		ds_json = JSON.parse(fs.readFileSync(ds_path+ds_filename))
		console.log("file:",ds_filename)

		// SET "enabled" to true. Currently false 
		// Except Cumulative Precipitation, which is incorrect. Keep off.
		if(ds_json._id != "5ae879b8fe27f41864102da8") {
			ds_json.enabled = true
		}

		// investigate existing datapoints_configs
		dpc_count = ds_json.datapoints_config.length
		//console.log("\tdatapoints_config:",dpc_count)
		boo_influxdb_exists = false
		dpc_bsdb_position = -999
		for(var j=0;j<dpc_count;j++) {
			dpc_type = dpc_get_type(ds_json,j)
			console.log("\t",j,dpc_type)
			if(dpc_type == "InfluxDB") { boo_influxdb_exists = true }
			if(dpc_type == "SensorDB") {
				dpc_bsdb_position = j
			}
		}

		// Several stations are still owned and operated by DRI. Only web accessible 
		dri_only_stations = ["58e68cacdf5ce600012602dc","58e68cacdf5ce600012602dd","58e68caddf5ce600012602de"]
		boo_dri_skip = false
		for(var j=0;j<dri_only_stations.length;j++) {
			if(ds_json.station_id == dri_only_stations[j]) {
				boo_dri_skip = true
			} 
		}

		// create a new influx config or update existing with same start-date 
		// if the datastream qualifies. below are the conditionals
		if(boo_dri_skip == true) {
			console.log("\tSKIP. DRI managed station. Must retrieve via website.",ds_json.name)
		} else if(ds_json.enabled == false) {
			console.log("\tSKIP. Innactive. enabled:",ds_json.enabled,ds_json.name)
		// Must have external references to build influx datapoints_config
		} else if(typeof ds_json.external_refs === 'undefined') {
			console.log("\tSKIP. No external references.",ds_json.name)
		// Do not create influx config if one already exists
		} else if(boo_influxdb_exists == true) {
			console.log("\tSKIP. boo_influxdb_exists:",boo_influxdb_exists,ds_json.name)
		// Do not create influx config for derived datastreams
		} else if(typeof tr.get_external_ref(ds_json,"odm.datastreams.DerivedID") !== 'undefined') {
			console.log("\tSKIP. Derived dataset.",ds_json.name)
		// Must has a fieldname if ERCZO, Not necessary if UCNRS
		} else if(typeof tr.get_external_ref(ds_json,"odm.datastreams.FieldName") === 'undefined' && org_slug != "ucnrs") {
			console.log("\tSKIP. FieldName not listed",ds_json.name,tr.get_external_ref(ds_json,"odm.datastreams.FieldName"))
		// Must exist in sensor database 					
		} else {
			if(dpc_bsdb_position != -999) {
				ds_json = dpc_set_enddate(ds_json,influxdb_start_date,dpc_bsdb_position,"create") 
			} else {
				console.log("\tNO SensorDB config.",ds_json.name)
			}
			
			// FINALLY actually create a datapoints_config
			// note: dt_json was not used when exporting to file. Not sure how anything worked.
			dpc_start_date = influxdb_start_date
			dt_json = dpc_create_influxdb_from_extref(ds_json,dpc_start_date)
			if(typeof dt_json === 'undefined') {
				console.log("\tSKIP. not processed.",ds_json.name)		
			} else {
				boo_skip = false
				influx_dpc_count++
				skipped_count--
				// Write JSON file
				dt_json_string = JSON.stringify(dt_json,null,2)
				//console.log("\tProcessed! InfluxDB config_points created. Writing file:",ds_filename)
				fs.writeFileSync(out_path+ds_filename,dt_json_string,'utf-8')
			}
		}
	} else {
		console.log("Not JSON file!",ds_filename)
	}
}
console.log("transform-sensordb-influxconfig.js complete.  Datastreams processed:",influx_dpc_count,"skipped:",skipped_count,"of total files",ds_count)

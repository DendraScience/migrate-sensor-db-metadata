/* 
 FieldName checker 
 collin bode
 2018-4-20
 compare fieldnames in datastreams to loggernet extracted fieldname list

  "datapoints_config": [
    {
      "begins_at": "2011-06-03T20:00:00.000Z",
      "params": {
        "query": {
          "compact": true,
          "datastream_id": 3075,
          "time_adjust": -28800
        }
      },
      "path": "/legacy/datavalues-ucnrs",
      "ends_before": "2018-04-17T00:00:00.000Z"
    },
    {
      "params": {
        "query": {
          "api": "ucnrs",
          "db": "station_ucbo_blueoak",
          "fc": "source_tenmin",
          "sc": "\"time\", \"AT_C_Max\"",
          "utc_offset": -28800
        }
      },
      "begins_at": "2018-04-17T00:00:00.000Z",
      "path": "/influx/select"
    }
  ],
*/

console.log("\n Datastream Influx Fieldname counter starting \n")

fs = require("fs")
tr = require("../transform_functions.js")
core8 = JSON.parse(fs.readFileSync("ucnrs_core8.json"))
loggernet_stations = JSON.parse(fs.readFileSync("../stations_loggernet.json"))

function get_loggernet_station(station_name) {
  stations_loggernet = JSON.parse(fs.readFileSync("../stations_loggernet.json"))
  for(var i=0;i<stations_loggernet.length;i++) {
    lstation = stations_loggernet[i]
    if(lstation.name.toLowerCase() == station_name) {
      //console.log("FOUND! ",lstation.name,"==",station_name)
      return lstation
    }
  }
}

// count
field_same = 0
field_diff = 0
field_diff_tenmin = 0
match = 0
nomatch = 0
disabled = 0
goes = 0
total = 0

ds_path = "../../data/migration2.1-rivendell/ucnrs/datastream/"
ds_files = fs.readdirSync(ds_path)

for(var i=0;i<ds_files.length;i++) {
	ds_filename = ds_files[i]
	var influx_station = undefined
	var influx_table = undefined
	var influx_fieldname = undefined
	var fieldname = undefined
	var boo_field_same = false
	
	// Eliminate invalid Datastreams
	if (ds_filename.match(/.json$/) == null) {
		continue
	}
	total++
	ds_json = JSON.parse(fs.readFileSync(ds_path+ds_filename)) 
	if(ds_json.enabled != true) {
		disabled++
		//console.log("SKIP. Disabled:",ds_json.name)
		continue
	}

	// Get Influx Parts: Fieldname, Table, Station
	for(var j=0;j<ds_json.datapoints_config.length;j++) {
		if(ds_json.datapoints_config[j].path == "/influx/select") {
			// Field
			sc = ds_json.datapoints_config[j].params.query.sc
			influx_fieldname = sc.split(",")[1].replace("\"","").replace("\"","").trim()
			// Table
			fc = ds_json.datapoints_config[j].params.query.fc
			influx_table = fc.replace("source_","")
			// Station
			db = ds_json.datapoints_config[j].params.query.db
			influx_station = db.replace("station_","")
		}
	}

	if(typeof influx_fieldname == 'undefined') {
		console.log("SKIP. No Influx Field:",ds_json.name)
		nomatch++
		continue
	}
	if(typeof influx_table == 'undefined') {
		console.log("SKIP. Influx Table not found:",ds_json.name)
		nomatch++
		continue
	}
	if(typeof influx_station == 'undefined') {
		console.log("SKIP. Influx Station not found:",ds_json.name)
		nomatch++
		continue
	}
	//console.log(i,"station:",influx_station,",table:",influx_table,",field:",influx_fieldname,"<--",ds_json.name)
	goes_address = tr.get_external_ref(ds_json,"goes.address")
	if(typeof goes_address != 'undefined') {
		console.log("SKIP. GOES station:",ds_json.name)
		//nomatch++
		goes++
		continue
	}

	// Match to LoggerNet records
	//station = tr.get_station_mongoid(ds_json.station_id)
	loggernet_station = get_loggernet_station(influx_station)
	if(typeof loggernet_station == 'undefined') {
		console.log(i,"NOPE! Loggernet_Station not found:",influx_station,ds_json.name)
		nomatch++
		continue
	} 

	// get the right table
	for(var k=0;k<loggernet_station.data_tables.length;k++) {
		//console.log(loggernet_station.name,loggernet_station.data_tables[k].name)
		if(influx_table == loggernet_station.data_tables[k].name.toLowerCase()) {
			//console.log("Table Match!",influx_table,"==",loggernet_station.data_tables[k].name.toLowerCase(),"<--",ds_json.name)
			//console.log(influx_fieldname)
			loggernet_fieldlist = loggernet_station.data_tables[k].fields
			for(var l=0;l<loggernet_fieldlist.length;l++) {
				lfield = loggernet_fieldlist[l]
				if(lfield == influx_fieldname) {
					field_same++
					boo_field_same = true
					fieldname = influx_fieldname
					//console.log(l,"Match! Fieldname found influx:",influx_fieldname,"==",lfield)
				} else {
					//console.log(l,"fieldname miss. influx:",influx_fieldname,"==",lfield)
				}
			}
			if(boo_field_same == false) {
				field_diff++
				console.log("Fieldnames different.",influx_station,influx_table,influx_fieldname,"<--",ds_json.name)
				for(var m=0;m<core8.length;m++) {
					core8_field = core8[m].Core8_TenMin
					if(core8_field == influx_fieldname) {
						tenmin_field = core8[m].TenMin
						for(var n=0;n<loggernet_fieldlist.length;n++) {
							if(tenmin_field == loggernet_fieldlist[n]) {
								console.log("\t Match! Older TenMin found. field:",tenmin_field,",core8_field:",core8_field,",influx field:",influx_fieldname,"<--",ds_json.name)
								field_diff_tenmin++
								fieldname = tenmin_field
							}
						}
					}
				}
			} else {
				console.log(i,influx_station,influx_table,influx_fieldname,"<--",ds_json.name)
			}
		}
	}
	match++

	if(typeof fieldname !== 'undefined' ) {
		if(fieldname.match(/RS_kw_m2/)) { 
			//"sc": "\"time\", \"RS_kw_m2_Avg\"*1000 as \"RS_w_m2_Avg\""
			oldfieldname = fieldname
			newfieldname = oldfieldname.replace("RS_kw_m2","RS_w_m2")
			fieldname = oldfieldname+"\"*1000 as \""+newfieldname
			console.log("SOLAR",ds_json.name,"o:",oldfieldname,"-->",fieldname)
		}
	} else {
		console.log("fieldname undefined.",ds_json.name)
	}
}
console.log("UCNRS Datastreams total:",total,",table matches:",match,",misses:",nomatch,",disabled:",disabled,", goes:",goes)
console.log("\t field matches:",field_same,", different:",field_diff,",tenmin found:",field_diff_tenmin,",unmatched:",field_diff-field_diff_tenmin)

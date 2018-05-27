/*
Loggernet Missing Fieldnames 
author: Collin Bode 
date: 2018-05-24
email: collin@berkeley.edu
purpose: to find the fields that do not have datastreams defined.
{
        "name": "ucel_elliotchaparral",
        "organization_slug": "ucnrs",
        "program_name": "CPU:UC_Elliott_Sniper_v8.1.CR1",
        "data_tables": [
            {
                "name": "Audit",
                "fields": [ ]
            },
            {
                "name": "GOES_TenMin",
                "fields": [ ]
            },
            {
                "name": "TenMin",
                "fields": [ ]
            },
            {
                "name": "_Settings",
                "fields": [ ]
            }
        ],
        "program_startdate": "2018-05-18T14:13:16.98"
    },
*/


console.log("\n Datastream Influx Fieldname counter starting \n")

fs = require("fs")
tr = require("../transform_functions.js")
core8 = JSON.parse(fs.readFileSync("ucnrs_core8.json"))
loggernet_stations = JSON.parse(fs.readFileSync("./stations_loggernet_ucnrs_2018-05-26.json"))
ds_path = "../../data/migration2.1-rivendell/ucnrs/datastream/"

function get_station_mongoid_by_name(station_name) {
	station_list = JSON.parse(fs.readFileSync("../stations.json"))
	for(var j=0;j<station_list.list.length;j++) {
		mstation = station_list.list[j]
		if(mstation.loggernet == station_name) {
			return mstation._id
		}
	}
}

function get_tenmin_fields(data_tables) {
	for(var k=0;k<data_tables.length;k++) {
		table = data_tables[k]
		if(table.name == 'TenMin') {
			return table.fields
		}
	}
}

function get_station_tablenames(data_tables) {
	table_names = []
	for(var k=0;k<data_tables.length;k++) {
		table_names.push(data_tables[k].name)
	}	
	return table_names
}

function get_influx_datapoints_config(dpc) {
	for(var i=0;i<dpc.length;i++) {
		sc = dpc[i].params.query.sc
		if(typeof sc !== 'undefined') {
			return dpc[i]
		}
	}
}

// Get an array of JSON Datastreams
ds_files = []
dsfilelist = fs.readdirSync(ds_path)
for(var p=0;p<dsfilelist.length;p++) {
	dsfilename = ds_path+dsfilelist[p]
	//console.log(dsfilename)
	if(!dsfilename.match(/.json/)) {
		continue
	}	else if(dsfilename.match(/seasonal.datastream.json/)) {
		continue
	} else {
		ds = JSON.parse(fs.readFileSync(dsfilename))
		console.log(p,ds.name,)
		ds_files.push()
	}
}
console.log("ds_files:",ds_files.length,"dsfilelist:",dsfilelist.length)

// Pull out an array of datastream name, station_id, and fieldname
dsfields = []
for(var i=0;i<ds_files.length;i++) {
	dpc = get_influx_datapoints_config(ds_files[i].datapoints_config)
	if(typeof dpc === 'undefined') {
		console.log("SKIP. no influx.",ds_files.name)
		continue
	}
	sc = dpc.params.query.sc
	fields = sc.split(",")
	dsfieldtemp = fields[fields.length-1].replace('"',"").replace('"',"")
	dsfield = dsfieldtemp.split("\*")[0]
	dsfields.push([ds_files[i].name,ds_files[i].station_id,dsfield])
	console.log(ds_files[i].name,ds_files[i].station_id,dsfield)
}

/*
// LOOP THROUGH ALL STATIONS IN LOGGERNET FILE
for(var i=0;i<loggernet_stations.length;i++) {
	if(i>11) { break }

	// Get necessary information for each station
  station = loggernet_stations[i]
  if(station.organization_slug == 'sagehen') {
  	//console.log("SKIP!",station.name,station.organization_slug)
  	continue
  }
  station_id = get_station_mongoid_by_name(station.name)
  //table_names = get_station_tablenames(station.data_tables)

  // counts
  count_station_ds = 0
  count_station_fields = 0
  count_station_matches = 0

  fields = get_tenmin_fields(station.data_tables) 
  if(typeof fields === 'undefined') {
  	console.log("SKIP",station.name,"has no fields")
  	continue
  }
	count_station_fields = fields.length  

  console.log(station.name,station.organization_slug,station_id) //,table_names)

  // For each field, find if there is a matching datastream
  // Requires both mongo_id for station and fieldname
  for(var l=0;l<fields.length;l++) {
  	field = fields[l]

  	// Skip the time fields and station ID fields
  	// We didn't make datastreams for these
  	if(field.match(/Hour/) || field.match(/Day_of_Year/) || field.match(/Sta_ID/)) {
  		console.log("\tSKIP: control field("+l+"):",field)
  		count_station_fields--
  		continue
  	} 
  	fieldclean = field.replace(/\W/g, '_')
  	console.log("\tfield("+l+"):",field,"-->",fieldclean)
  	
  	
  	// Loop through all the datastreams
		for(var m=0;m<ds_files.length;m++) {
			dsfile = ds_files[m]

			// Skip datastreams not for this station
			if(dsfile.station_id == station_id) {
				count_station_ds++
				//console.log("\t",station_id,"==",dsfile.station_id)
				sc = dsfile.datapoints_config[1].params.query.sc
				//console.log("\t",field,"<-->",sc)
				fields = sc.split(",")
				dsfieldtemp = fields[fields.length-1].replace('"',"").replace('"',"")
				dsfield = dsfieldtemp.split("\*")[0]
				console.log("\tds_files("+m+"):",field,"<-->",dsfield)
				
				if(fieldclean.match(/dsfield/)) {
					console.log("\tMATCH!",fieldclean,"==",dsfield)
					count_station_matches++
				} else {
					//console.log("\t",field,"!=",dsfield)
				}
			}
		}
		
  }
	console.log(station.name,count_station_fields,"==",count_station_ds,"matches:",count_station_matches)	
}
*/
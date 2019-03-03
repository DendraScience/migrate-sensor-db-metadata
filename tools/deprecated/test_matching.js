// test matching

dsid = 36804



fs = require("fs")
tr = require("./transform_functions.js")
path = require("path")

function string2array(str_array) {
	stripped = str_array.replace("[","").replace("]","").trim()
	only_array = stripped.split(",")
	return only_array
}

org = 'erczo'
mig3_path = '../data/migration3-incidents/'+org+'/'
irStationIDs = "[4, 5, 6, 7, 8, 9, 10]"

// Gather list of Stations
station_path_list = []
station_id_list = []
tr.recurse_dir(mig3_path,station_path_list,RegExp(/station.json$/i)) 
console.log("Station Traverse complete. list length:",station_path_list.length)

// Pull ODM ID & MongoID from each datastream
for (var ss=0;ss<station_path_list.length;ss++) {
	//console.log(dd)
	sdir = station_path_list[ss][0]
	sfile = station_path_list[ss][1]
	sfull_path = path.join(sdir, sfile)
	st = JSON.parse(fs.readFileSync(sfull_path))
		
	// Quail Ridge and a few newer stations do not have external references	
	if(typeof st.external_refs === 'undefined') {
		console.log(st.name,"doesn't have external refs")
		continue
	}
	
	// list parts
	stname = st.name
	mongoid = st._id
	odmid = 0

  for(var kk=0;kk<st.external_refs.length;kk++) {
  	if(st.external_refs[kk].type.match(/StationID/)) {
  		odmid = parseInt(st.external_refs[kk].identifier,10)
  	}
  }
  if(odmid == 0) { continue }
  else {
  	station_id_list.push([stname,odmid,mongoid])
  }
}
console.log("station_id_list.length:",station_id_list.length)
console.log("station_path_list.length:",station_path_list.length)
console.log(station_id_list)





// Station ODM IDs --> MongoIDs
ir_stations = string2array(irStationIDs)
console.log("\t",irStationIDs,"-->",ir_stations)
for (var s=0;s<ir_stations.length;s++) {
	sod = ir_stations[s].trim()
	console.log("\t\t",s,sod)
	for (var j=0;j<station_id_list.length;j++) {
		if(sod == station_id_list[j][1]) {
			ann.station_ids.push(station_id_list[j][2])
			console.log("FOUND!",sod,"==",station_id_list[j][1],station_id_list[j][0],station_id_list[j][2])
		} 
	}
}
//console.log("\t",ir.StationIDs)
//console.log("\t",ann.station_ids)
/*
	station = tr.get_station_odmid(sod)		

	//ann.station_ids.push(station._id)
	console.log("\t\t",s,sod,station._id,station.name)
	*/
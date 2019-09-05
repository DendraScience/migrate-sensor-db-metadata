/*	
Functions for transforming Stations and Datastream JSON files

// Station object
{
  "_id" : "58e68cabdf5ce600012602ba",
  "name" : "Burns",
  "station_id" : "338",  <-- this is the odm id
  "loggernet.station":"ucbu_burns",
  "goes":"BEC025B0"
}
*/

exports.recurse_dir = function(dir,filepath_list,regex) {
  // example use: tr.recurse_dir(start_path,filepath_list,RegExp(/^Precip((?!seasonal).)*$/i))
  // regex starts with precip and excludes seasonal.
  // filepath_list is a paired array of parent path and filename that is the returned values.
  fs = require("fs")
  path = require("path")
  fs.readdirSync(dir).forEach(file => {
    let full_path = path.join(dir, file)
    if (fs.lstatSync(full_path).isDirectory()) {
      exports.recurse_dir(full_path+path.sep,filepath_list,regex)
    } else {
      if(regex == "") {
        filepath_list.push([dir,file])
      } else if(regex.test(file)) {
        filepath_list.push([dir,file])
      }
    }  
  })
}

exports.get_org_slug = function(organization_id) {
  // assumes specific file structure
  fs = require("fs")
  opath = "../data/common/organization/"
  o_files = fs.readdirSync(opath)
  for(var o=0;o<o_files.length;o++) {
    o_file = o_files[o]
    if(o_file.match(/.json$/)) {
      o_json = JSON.parse(fs.readFileSync(opath+o_file))
      if(organization_id == o_json._id) {
        return o_json.slug
      }
    } // else {
    //  console.log(o_file,"not json!")
    //}
  }
}

exports.get_station = function(station_odm_id) {
  stations = JSON.parse(fs.readFileSync("stations.json"))
  for(var i=0;i<stations.list.length;i++) {
    station = stations.list[i]
    if(station.station_id == station_odm_id) {
      //console.log("FOUND! ",station.name, station.station_id,station._id)
      return station
    }
  }
}

exports.get_station_odmid = function(station_odm_id) {
  stations = JSON.parse(fs.readFileSync("stations.json"))
  boofound = false
  for(var i=0;i<stations.list.length;i++) {
    station = stations.list[i]
    if(station.station_id == station_odm_id) {
      //console.log("FOUND! ",station.name, station.station_id,station._id)
      boofound = true
      return station
    }
  }
  if(boofound == false) {
    return 'STATION_NOT_FOUND'
  } 
}

exports.get_station_mongoid = function(station_mongo_id) {
  stations = JSON.parse(fs.readFileSync("stations.json"))
  for(var i=0;i<stations.list.length;i++) {
    station = stations.list[i]
    if(station._id == station_mongo_id) {
      //console.log("FOUND! ",station.name, station.station_id,station._id)
      return station
    }
  }
}

exports.get_loggernet_station = function(station_name) {
  stations_loggernet = JSON.parse(fs.readFileSync("stations_loggernet.json"))
  for(var i=0;i<stations_loggernet.length;i++) {
    lstation = stations_loggernet[i]
    if(lstation.name == station_name) {
      //console.log("FOUND! ",station.name)
      return lstation
    }
  }
}

exports.get_external_ref = function(de_json,ref_type) {
  if(typeof de_json.external_refs === 'undefined') {
    return ""
  }
  for(var k=0;k<de_json.external_refs.length;k++) {
  	//console.log("external_refs[",k,"]:",de_json.external_refs[k])
  	if(de_json.external_refs[k].type == ref_type) {
  		//console.log("MATCH!",ref_type,"==",de_json.external_refs[k].type,"returning identifier:",de_json.external_refs[k].identifier)
  		return de_json.external_refs[k].identifier
  	}
  }
}

exports.get_tag = function(dt_json,tag_prefix) {
  regex_prefix = new RegExp(tag_prefix+'*')
  // bug in den causing tag to be removed from json
  // if this is the case, it means the json has been processed and "terms" can be used instead
  if(typeof dt_json.tags === 'undefined') {
    if(regex_prefix.test("Unit")) {
      return dt_json.terms.dt.Unit
    } else if(regex_prefix.test("Aggregate")) {
      return dt_json.terms.ds.Aggregate
    } else if(regex_prefix.test("Medium")) {
      return dt_json.terms.ds.Medium
    } else if(regex_prefix.test("Variable")) {
      return dt_json.terms.ds.Variable
    } else if(regex_prefix.test("Measurement")) {
      return dt_json.terms.dq.Measurement
    } else if(regex_prefix.test("DataPurpose")) {
      return dt_json.terms.dq.DataPurpose
    }  
  } else {
    for(var k=0;k<dt_json.tags.length;k++) {
      //console.log("tag test:",tag_prefix,"=?=",dt_json.tags[k])
      if(regex_prefix.test(dt_json.tags[k])) {
        //console.log("Tag Match!",tag_prefix,"===",dt_json.tags[k])
        return dt_json.tags[k]
      }
    }
  }
  /*
  "terms": {
    "dt": {
      "Unit": "Volt"
    },
    "ds": {
      "Aggregate": "Minimum",
      "Medium": "Battery",
      "Variable": "Voltage"
    }
  },
  */   
}

exports.is_objects_equivalent = function(a,b) {
  // Recurses into 2 levels of two JSON objects to test to see if they match
  // First make sure one or both aren't null
  if(typeof a === 'undefined' && typeof b === 'undefined') {
    return true
  } else if(typeof a === 'undefined' && typeof b !== 'undefined') {
    return false
  } else if(typeof a !== 'undefined' && typeof b === 'undefined') {
    return false
  }
  // Get top level properties and make sure they match
  a_props = Object.getOwnPropertyNames(a)
  b_props = Object.getOwnPropertyNames(b)
  //console.log("a_props:",a_props)
  //console.log("b_props:",b_props)
  if(a_props.length != b_props.length) {
    //console.log("NOT equivalent objects. different number of objects")
    return false
  }
  // Loop through values and check if they match
  for (var p=0;p<a_props.length;p++) {
    propname = a_props[p]
    // If there is another layer call itself to recurse
    if(typeof a[propname] === 'object' && typeof b[propname] === 'object') {
      return exports.is_objects_equivalent(a[propname],b[propname])
    } else if(a[propname] !== b[propname]) {
      console.log("NOT equivalent objects. ",propname,"different:",a[propname],"!== ",b[propname])
      return false
    } 
  }
  // Oh all right
  console.log("is equivalent!")
  return true
}

exports.update_external_ref = function(de_json,ref_type,ref_identifier) {
	boofound = false
  for(var k=0;k<de_json.external_refs.length;k++) {
  	if(de_json.external_refs[k].type == ref_type) {
  		//console.log("update_external_ref: MATCH!",ref_type,"==",de_json.external_refs[k].type,"updating identifier:",de_json.external_refs[k].identifier)
  		de_json.external_refs[k].identifier = ref_identifier
  		boofound = true
  	}
  }
  if(boofound == false) {
  	//ss_json.external_refs.push({"identifier": ldmp,"type":"loggernet.ldmp" })
  	//console.log(de_json.name,"update_external_ref: pushing new ref",ref_type+":"+ref_identifier)
		de_json.external_refs.push({"identifier":ref_identifier,"type":ref_type})
  }
  return de_json
}

exports.find_table = function(table_list,table_name) {
	found = false
	for(var m=0;m<table_list.length;m++) {
		if(table_list[m].name.match(table_name)) {
			//console.log("find_table: Match!",table_name)
			found = true
		}
	} 
	return found
}

exports.list_table_names = function(table_array) {
	table_list = []
	for(var m=0;m<table_array.length;m++) {
		table_list.push(table_array[m].name)
	} 
	return table_list.toString()
}

exports.find_array_value = function(table_list,table_name) {
  for(var m=0;m<table_list.length;m++) {
    if(table_list[m].match(table_name)) {
      //console.log("find_table: Match!",table_name)
      return table_list[m]
    }
  } 
}

exports.get_fieldname_ucnrs_match_dsname = function(ds_json) {
  core8 = JSON.parse(fs.readFileSync("ucnrs_core8.json"))
  stations = JSON.parse(fs.readFileSync("stations.json"))

  // Some full station names are shortened for datastreams
  station = tr.get_station_mongoid(ds_json.station_id)
  station_name = station.name
  if(station.name == "Angelo Reserve South Meadow") {
    station_name = "Angelo"
  } else if (station.name == "Blue Oak Ranch") {
    station_name = "Blue Oak"
  }
  name_generic = ds_json.name.replace(station_name,"STATION")
  fieldname = ""
  for (var l=0;l<core8.length;l++) {
    //console.log(l,core8[l].Datastream_Example_Name)
    if(name_generic == core8[l].Datastream_Example_Name) {
      //console.log("\tMATCH!",name_generic,"==",core8[l].Datastream_Example_Name,"-->",core8[l].Core8_TenMin)
      fieldname = core8[l].Core8_TenMin    
    }
  }
  if(fieldname != "") {
    return fieldname
  } else {
    console.log("\tNO MATCH",station_name,ds_json.name)
  }
}



exports.get_fieldname_ucnrs_match_tags = function(ds_json) {
  core8 = JSON.parse(fs.readFileSync("ucnrs_core8.json"))
  //boomatch = false
  fieldnames = []
  // get tag info
  /*  "tags": [
    "ds_Aggregate_Minimum",
    "ds_Medium_Soil",
    "ds_Variable_Temperature",
    "dt_Unit_DegreeCelsius"
  ],*/
  medium = exports.find_array_value(ds_json.tags,"ds_Medium_")
  variable = exports.find_array_value(ds_json.tags,"ds_Variable_")
  aggregate = exports.find_array_value(ds_json.tags,"ds_Aggregate_")
  unit = exports.find_array_value(ds_json.tags,"dt_Unit_")
  attributes = ds_json.attributes

  /*
  console.log("get_fieldname_ucnrs_match_tags:")
  console.log("\tmedium:",medium)
  console.log("\tvariable:",variable)
  console.log("\taggregate:",aggregate)
  console.log("\tunit:",unit)
  console.log("core8.length:",core8.length)
  */
  for (var l=0;l<core8.length;l++) {
    boomatch = false
    //console.log(l,core8[l].Datastream_Example_Name)
    /*    "Medium": "Solar",
    "Measurement": "Radiation",
    "Aggregate": "Minimum",
    "Unit": "KilowattPerSquareMeter",*/
    c8_medium = "ds_Medium_"+core8[l].Medium
    c8_variable = "ds_Variable_"+core8[l].Measurement
    c8_aggregate = "ds_Aggregate_"+core8[l].Aggregate
    c8_unit = "dt_Unit_"+core8[l].Unit
    boomedium = false
    boovariable = false
    booaggregate = false
    boounit = false
    if(c8_medium == medium) { boomedium = true }
    if(c8_variable == variable) {boovariable = true}
    if(c8_aggregate == aggregate) {booaggregate = true}
    if(c8_unit == unit ) {boounit = true}
    if(boomedium == true && boovariable == true && booaggregate == true) {
      boomatch = true
      rank = 1
      if(boounit == true) {rank++}
      if(attributes == core8[l].attributes) {rank+=2}
      fieldnames.push([core8[l].Core8_TenMin,rank])
    }
    /*
    console.log(l,"medium:",medium,"c8:",c8_medium,"boomedium:",boomedium)
    console.log(l,"variable:",variable,"c8:",c8_variable,"boovariable:",boovariable)
    console.log(l,"aggregate:",aggregate,"c8:",c8_aggregate,"booaggregate:",booaggregate)
    console.log(l,"unit:",unit,"c8:",c8_unit,"boounit:",boounit)
    */
    //console.log(l,"match:",boomatch,"medium:",boomedium,"variable:",boovariable,"aggregate:",booaggregate,"unit:",boounit,"name:",ds_json.name)
    /*
    if(boomatch == true) {
      //console.log("\tMATCH!",name_generic,"==",core8[l].Datastream_Example_Name,"-->",core8[l].Core8_TenMin)
      fieldname = core8[l].Core8_TenMin
      return fieldname    
    }
    */
  }
  if(fieldnames.length == 0) {
    console.log("\tNO MATCH. tags did not uniquely identify",station_name,ds_json.name)
  }  else {
    return fieldnames
  }
}


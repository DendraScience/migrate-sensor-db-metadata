/*
Compares vocabularies and allows reconilliation of MySQL export 
and Core8 table
Collin Bode collin@berkeley.edu

## Migration Notes
UCNRS soil moisture has extremely inconsistant naming

### Legacy datastreams 

Solar Radiation (W/m2) <--> Core8 (kW/m2).  Dashboard needs W/m2
	fix: transform-sensodb-influxconfig.js - added legacy_units column to Core8. Creating conversion functions: kw2w()

Photosynthetically Active Radiation all use Variable Code: "PAR umole".  No aggregate included.
	fixed. sensordb_update_par_variablecodes.sql - corrected source in MySQL.	variables2tags.json updated. 

Wind Direction Degrees are all averages, but are not listed as such. Also, one Standard deviation was mislabeled.
	fixed. Manually corrected source in MySQL. Updated variables2tags.json.

Barometric Pressure - Core8 listed variable as "Pressure" not "BarometricPressure". 
	fixed. dendra_map_variablecodes_tags.sql - manually corrected Core8. VariableCode did not list aggregate.  All are averages, updated sql.

Volumetric Water Content - conflict between "Soil Moisture" and "Volumetric Water Content".  They mean the same thing. Opted for "Moisture" to simplify.
	fixed. corrected Fort Ord averages that were not listed as such.  
	fixed? James Reserve has "retired" non-standard soil moisture that is no listed as average. No way to determine if it actually was averaged or not.  However, everything else old or new has been averaged.  So, updating.

TDR Frequency - we didn't know what this was when we entered UCNRS datastreams into the sensor database. Also seemed like DRI didn't know either.
	fixed. James TDR freq variablecode listed as unknown. manually changed to Dielectric to match the other TDR freq datastreams.
	Dielectric variablecode: this is Period actually, i.e. number of milliseconds between cycles, so the opposite of Frequency. Nether are actually Dielectric, which is unitless.
	fixed. created a new variablecode "VWC Period usec" and updated all UCNRS Dielectric to new variablecode.

Panel Temp - 

GEONOR rain gauge = medium was "water" not "precipitation"


*/

fs = require('fs')
tr = require("./transform_functions.js")

core8 = JSON.parse(fs.readFileSync("ucnrs_core8.json"))
variablecodes = JSON.parse(fs.readFileSync("variablecodes2tags.json"))

count_match = 0
count_nomatch = 0

function get_variablecode_tag_match(ds_json,variablecodes) {
  fieldnames = []
	name = ds_json.Datastream_Example_Name
	medium = ds_json.Medium
	variable = ds_json.Measurement
	unit = ds_json.Unit
	legacy_unit = ds_json.Legacy_Unit
	aggregate = ds_json.Aggregate
  attribute = ds_json.Attributes

  console.log(name,"c8_medium:",medium,"c8_variable:",variable,"c8_aggregate:",aggregate,"c8_unit:",unit,"c8_attributes:",attribute)
  
  for (var l=0;l<variablecodes.length;l++) {
    vc_medium = variablecodes[l].Medium
    vc_variable = variablecodes[l].Variable
    vc_aggregate = variablecodes[l].Aggregate
    vc_unit = variablecodes[l].Unit
    vc_comment = variablecodes[l].vc_comment

    if(vc_medium == medium) { 
    	//console.log("\tmedium c8:",medium,"vc:",vc_medium) 
    	if(vc_variable == variable) {
		  	//console.log("\tmedium c8:",medium,"vc:",vc_medium,", variable c8:",variable,"vc:",vc_variable) 
    		if(vc_aggregate == aggregate || (vc_aggregate == "" && aggregate == "")) {
    			//console.log("\t\t\taggregate c8:",aggregate,"vc:",vc_aggregate)
    			if(vc_unit == unit || vc_unit == legacy_unit) {
		    		/*
	    			if(typeof legacy_unit != "") {
	    				console.log("\t\t\t\tunit c8:",unit,"vc:",vc_unit,"legacy:",legacy_unit)
	    			} else {
	    				console.log("\t\t\t\tunit c8:",unit,"vc:",vc_unit)  
	    			}
	    			console.log("\t\t\t\t\t MATCH! ADDING FIELD")
	    			*/
    			  console.log("\tMATCH! ADDING. vc_medium:",medium,"vc_variable:",variable,"vc_aggregate:",aggregate,"vc_unit:",unit,"vc_attributes:",attribute)
 			      fieldnames.push(name)
    			}
    		}
    	}    	
    }
  }
  if(fieldnames.length == 0) {
    console.log("\tNO MATCH. tags did not uniquely identify",name)
    count_nomatch++
  }  else {
  	count_match++
    return fieldnames
  }
}

// loop through Core8
for (var m=0;m<core8.length;m++) {
	fieldnames = get_variablecode_tag_match(core8[m],variablecodes)
	console.log("\t",fieldnames,"\n")
}
console.log("TOTALS Core8:",core8.length,"VariableCodes:",variablecodes.length)
console.log("Core8 tag matches to VariableCodes:",count_match,", non-matches:",count_nomatch)

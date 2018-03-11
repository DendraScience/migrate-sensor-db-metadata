/*
Dendra Map Datastream Names to Attributes
@author=CollinBode
@Date=2018-02-18
@email=collin@berkeley.edu

Script will iterate through datastream directory and check each *.datastream.json file for
particular attributes in the name of the datatream.  These are known aspects of the Eel River CZO and UCNRS 
datastream names and it is not recommended for general use elsewhere.

*/
console.log("\n Datastream names to attributes mapping starting \n")

fs = require("fs")
args = process.argv.slice(2)
parent_path = args[0] // Requires trailing slash, e.g. "../data/migration2.1-rivendell/" 
org_slug = args[1]	 // "erczo"
path = parent_path+org_slug+"/datastream/"  // "../data/migration2.1-rivendell/erczo/datastream/" 
console.log('usage: node transform-sensordb-map-names-to-attributes.js <migration_path/>')

function parse_tags(ds_json) {
	/* 
  "tags": [
  "ds_Medium_Air",
  "ds_Variable_Speed",
  "dt_Unit_MeterPerSecond"
	],
  */
  ds_medium = ""
  ds_variable = ""
  ds_unit = ""
  ds_aggregate = ""

	for(var j=0;j<ds_json.tags.length;j++) {
		tag_parts = ds_json.tags[j].split("_")
		pref = tag_parts[1]
		suf = tag_parts[2]
		if(pref == "Medium") {
			ds_medium = suf
		} else if (pref == "Variable") {
			ds_variable = suf 
		} else if (pref == "Unit") {
			ds_unit = suf
		} else if (pref == "Aggregate") {
			ds_aggregate = suf
		} else {
			console.log(ds_json.name,"pref: ",pref,"has no match",suf)
		}
	}
	return {
		"medium":ds_medium,
		"variable":ds_variable,
		"unit":ds_unit,
		"aggregate":ds_aggregate
	} 
}

function inches2meters(val) {
	if(val == '2') {
		valout = '0.05'
	} else if (val == '4') {
		valout = '0.1'
	} else if (val == '8') {
		valout = '0.2'
	} else if (val == '20') {
		valout = '0.5'
	} else {
		valout = (0.0254*val).toString()
	}
	return valout
}

ds_files = fs.readdirSync(path)
console.log('Datastream Path:',path,"files found:",ds_files.length)

// counters
ds_count = 0
ds_no_match = 0
ds_processed = 0
erp_count = 0
vms_count = 0
soilmoisture_count = 0
soiltemp_count = 0
airtemp_count = 0
well_count = 0

// Loop through Datastream JSON files 
for(var i=0;i<ds_files.length;i++) {
	ds_filename = ds_files[i]
	if (ds_filename.match(/datastream.json$/)) {
		ds_modified = true
		ds_count++
		ds_processed++
		ds_json = JSON.parse(fs.readFileSync(path+ds_filename))
		dsname = ds_json.name
		tag = parse_tags(ds_json)
		//
		// Each conditional below is a specific name to attribute case 

		if(tag.medium == "Rock" && tag.variable == "Moisture" && tag.unit == "Kiloohm") {
		// ERP depths parsed 
			erp_count++
			location = dsname.substring(dsname.search('ERP ')+4,dsname.search('-'))
			attribute = dsname.substring(dsname.search('-')+1)
			//console.log("ERP Found!",dsname," Location:",location," Attribute:",attribute)
			ds_json.attributes = {
    		"depth": {
      		"unit_tag": "dt_Unit_Meter",
      		"value": attribute
    		}
  		}
			//output = "REPLACE INTO `dendra_map_datastreams_attributes` VALUES ('"+row.datastreamname+"', 'Depth', NULL, NULL, NULL, NULL, "+attribute+", 'Meter', NULL);"			

		} else if(ds_json.station_id == "58e68cacdf5ce600012602db") {
		// VMS depths
			vms = [
				['A1','1.9','2.1'],['A2','3.5','3.7'],['A3','5.1','5.3'],['A4','6.8','7.0'],['A5','8.4','8.6'],['A6','10.1','10.3'],
				['A7','11.8','12.0'],['A8','13.2','13.4'],['A9','14.8','15.0'],['A10','16.4','16.6'],
				['B1','0.2','1.7'],['B2','1.9','3.2'],['B3','3.4','4.7'],['B4','5.0','6.4'],['B5','6.6','7.9'],['B6','8.2','9.5'],
				['B7','9.8','11.0'],['B8','11.2','12.4'],['B9','12.6','13.8'],['B10','14.1','15.6'],
				['G1','0.2','1.4'],['G2','1.9','3.0'],['G3','3.4','4.5'],['G4','5.0','6.1'],['G5','6.6','7.7'],['G6','8.2','9.3'],
				['G7','9.8','10.8'],['G8','11.2','12.2'],['G9','12.6','13.7'],['G10','14.1','15.3']
			]
			vms_count++
			position = dsname.substring(dsname.search('_')+1)
			//console.log(row.datastreamname," Position: ",position,position.length)
			if(position.length < 4) {
				depth1 = 0
				depth2 = 0
				for(var j=0;j<vms.length;j++) {
					test_position = vms[j][0]
					if(test_position == position) {
						depth1 = Number(vms[j][1])
						depth2 = Number(vms[j][2])
						//console.log("Match!",dsname,test_position,position,"depth1: ",depth1," depth2:",depth2)
						// Insert Attributes
						ds_json.attributes = {
					    "depth": {
					      "unit_tag": "dt_Unit_Meter",
					      "range": [
					        depth1,
					        depth2
					      ]
					    }
					  }
						//console.log(dsname,ds_json.attributes)
					}
				}
			} else {
				console.log("VMS datastream without position!",dsname)
			}

		} else if((dsname.match(/^Soil Moisture L/) || dsname.match(/TDR L/)) && org_slug == "erczo" && tag.unit != "Millivolt") {
			/*	
			Soil Moisture - Rivendell
			Orientation (vertical or horizontal) and depth of probes is very important to understand the data.
			There are several kinds and variable codes for soil moisture. This requires several selects
			TDR's are named with Level, Orientation, Site, then depth in meters.
			"Soil Moisture L1T1_0.25"
			<Soil Moisture ><L1><T><1>_<0.25> 
			Two name prefixes: "TDR L", "Soil Moisture L"
			Orientation:  
				T = vertical, 30 cm probe, 29 in silica flour
				S = horizontal, 7.5 cm probe
			Note: older SM200 probes have a different but similar naming convention.
			<Soil Moisture ><L2><SM>_<10> where the SM is simply soil moisture again and the number is not depth.
			SM200's are in millivolts and should be ignored.
			*/			
			orientation = dsname.substring(dsname.search('_')-2,dsname.search('_')-1)
			if(orientation == 'T') {
				orientation = 'vertical'
			} else if(orientation == 'S') {
				orientation = 'horizontal'
			} else { 
				throw err 
			}
			depth = dsname.substring(dsname.search('_')+1)
			ds_json.attributes = {
		    "depth": {
		      "unit_tag": "dt_Unit_Meter",
		      "value": depth
		    },
		    "orientation": orientation
		  }
			//console.log(dsname," Orientation:",orientation," Depth:",depth)
			console.log(ds_json.attributes)
			soilmoisture_count++

		} else if((dsname.match(/^Soil Moisture CS/) || dsname.match(/^Soil Temp CS/) || dsname.match(/^Elec Conductivity CS/)) && org_slug == "erczo") {
			// CS650 at level 5 have custom names
			// Soil Moisture and Soil Temp - same instruments
			depth = dsname.substring(dsname.search('CS')+2)
			ds_json.attributes = {
		    "depth": {
		      "unit_tag": "dt_Unit_Meter",
		      "value": depth
		    }
		  }
		  if(dsname.match(/^Soil Temp CS/)) {
		  	soiltemp_count++
		  } else {
		  	soilmoisture_count++
		  }
		  console.log(dsname,ds_json.attributes)

		} else if((dsname.match(/^Soil Moisture /) || dsname.match(/TDR L/)) && org_slug == "ucnrs") {
			/* Soil Moisture - UCNRS
			UCNRS soil moisture is pairs of TDRs. One is vertical orientation and the other is horizontal.
			Most horizontal are placed at 4 inch depth (0.1 meter) or 2 inches (0.05 meter).  I don't know
			the depth of the vertical oriented TDRs.
			*/
			if(ds_json.attributes === null || ds_json.attributes === undefined) {
				ds_json.attributes = {}
				//console.log('UCNRS adding attributes',dsname)
			}
			// orientation
			if(dsname.match(/horiz/)) {
				ds_json.attributes.orientation = "horizontal"
			} 
			if(dsname.match(/vert/)) {
				ds_json.attributes.orientation = "vertical"
			}
			// depth
			if(dsname.match(/4/)) {
				ds_json.attributes.depth = {
		      "unit_tag": "dt_Unit_Meter",
		      "value": "0.1"
		    }
		    dsname = dsname.replace("4 in","0.1 m")
			}
			if(dsname.match(/2/)) {
				ds_json.attributes.depth = {
		      "unit_tag": "dt_Unit_Meter",
		      "value": "0.05"
		    }
		    dsname = dsname.replace("2 in","0.05 m")
			}
			if(ds_json.attributes.length == 0) {
				delete ds_json.attributes
			}
			console.log(ds_json.name,"-->",dsname,ds_json.attributes)
			ds_json.name = dsname
			soilmoisture_count++

		} else if(dsname.match(/Soil Temp L/)) {
			/* Rivendell soil temp is similar to soil moisture 
			ex. Soil Temp L1ST_0.00
			<Soil Temp ><L1><ST>_<0.00> 
			Level 1-3, Site T,T2,W <-- I don't know what these are
			Depth in meters. one of the depths is blank
			*/					
			depth = dsname.substring(dsname.search('_')+1)
			ds_json.attributes = {
				"depth": {
					"unit_tag": "dt_Unit_Meter",
					"value": depth
				}
			}
			console.log(dsname,ds_json.attributes)
			soiltemp_count++

		} else if(dsname.match(/Soil Temp /) && dsname.match(/inch depth/) && org_slug == "erczo") {
			// WSSM Angelo Soil Temp 
			// Soil Temp 8 inch depth C WSSM Min
			// Code converts both depth and name from inches to meters
			depth1 = dsname.substring(dsname.search('Temp')+5,dsname.search(' inch'))
			depth = inches2meters(depth1)
			ds_json.attributes = {
				"depth": {
					"unit_tag": "dt_Unit_Meter",
					"value": depth
				}
			}
			dsname = dsname.replace(depth1,depth)
			dsname = dsname.replace("inch", "meter")
			console.log(ds_json.name,"-->",dsname,ds_json.attributes)
			ds_json.name = dsname
			soiltemp_count++

		} else if(dsname.match(/Soil Temp Deg C/) && dsname.match(/ in /) && org_slug == "ucnrs") {			
			// UCNRS standard naming for Soil Temp
			//Soil Temp Deg C 2 in Anza Borrego Min
			// Code converts both depth and name from inches to meters
			depth1 = dsname.substring(dsname.search('Deg C')+6,dsname.search(' in'))
			depth = inches2meters(depth1)
			ds_json.attributes = {
				"depth": {
					"unit_tag": "dt_Unit_Meter",
					"value": depth
				}
			}
			dsname = dsname.replace(depth1,depth)
			dsname = dsname.replace("in", "m")
			console.log(ds_json.name,"-->",dsname,ds_json.attributes)
			ds_json.name = dsname
			soiltemp_count++

		} else if(dsname.match(/Air Temp Deg C/) && dsname.match(/ m /) && org_slug == "ucnrs") {
			// Air Temperature
			// Air Temp Deg C 2 m Hastings Min
			height = dsname.substring(dsname.search('Deg C ')+6,dsname.search(' m '))
			ds_json.attributes = {
				"height": {
					"unit_tag": "dt_Unit_Meter",
					"value": height
				}
			}
			console.log(dsname,ds_json.attributes)
			airtemp_count++

		} else if(dsname.match(/Air Temp /) && dsname.match(/ m height/) && org_slug == "erczo") {
			// Air Temperature
			// Air Temp 2 m height C WSSM
			height = dsname.substring(dsname.search('Temp')+5,dsname.search(' m '))
			ds_json.attributes = {
				"height": {
					"unit_tag": "dt_Unit_Meter",
					"value": height
				}
			}
			console.log(dsname,ds_json.attributes)
			airtemp_count++

		} else if(dsname.match(/Air Temp Delta/) && org_slug == "erczo") {
			// Air Temperature
			//Air Temp Delta 10m-2m C WSSM Max
			height1 = dsname.substring(dsname.search('Delta')+6,dsname.search('m-'))
			height2 = dsname.substring(dsname.search('m-')+2,dsname.search('m C'))
			ds_json.attributes = {
				"height": {
					"unit_tag": "dt_Unit_Meter",
					"range":[height1,height2]
				}
			}
			console.log(dsname,ds_json.attributes)
			airtemp_count++

		} else if(dsname.match(/Air Temp Delta/) && org_slug == "ucnrs") {
			// Air Temperature
			//Air Temp Delta Deg C 10m-2m Anza Borrego
			height1 = dsname.substring(dsname.search('Deg C')+6,dsname.search('m-'))
			height2 = dsname.substring(dsname.search('m-')+2,dsname.search('m '))
			ds_json.attributes = {
				"height": {
					"unit_tag": "dt_Unit_Meter",
					"range":[height1,height2]
				}
			}
			console.log(dsname,ds_json.attributes)
			airtemp_count++
		} else if (dsname.match(/Well/) && !dsname.match(/CO2/) && org_slug == "erczo") {
			/* Wells (depths, pressures, and temp)
			information needed to calculate water level is included in attributes
			depth = total depth of well to bedrock
			wellhead_height = "stick-up" or height above ground where the cable comes out.
			cable_length = length of the transducer cable
			water depth equation = wellhead_height + cable_length - water_level 
			Well 16 Water Level m
			Well 3 Pressure psi
			Well 16 Water Temp C
			*/
			well_numbers = {
				"1": ["9.5","0","7.13"],
				"10": ["27.4","0.07","22.09"],
				"12": ["7.21","0.744","7.04"],
				"13": ["18.44","0.604","17.39"],
				"14": ["32.92","0.744","32.0"],
				"15": ["33.22","0.35","28.38"],
				"16": ["34.29","0.25","26.4"],
				"2": ["12.2","0.3","12.15"],
				"3": ["14.4","0","12.45"],
				"5": ["25.3","0.06","23.09"],
				"6": ["19.9","0.08","13.18"],
				"7": ["19.8","0.23","16.58"],
				"500": ["","",""],
				"501": ["","",""],
				"502": ["","",""]
			} 

			well_info_object = {
					"depth":{
						"unit":"dt_Unit_Meter",
						"value":"0"
					},
					"wellhead_height":{
						"unit":"dt_Unit_Meter",
						"value":"0"
					},
					"cable_length": {
						"unit":"dt_Unit_Meter",
						"value":"0"						
					}
			}

			if(dsname.match(/Pressure/)) {
				match2 = ' Pressure'
			} else {
				match2 = ' Water'
			}

			wellnum = dsname.substring(dsname.search('Well')+5,dsname.search(match2))
			//console.log(dsname,"wellnum=",wellnum)
			ds_json.attributes = well_info_object
			well_info_array = well_numbers[wellnum]
			ds_json.attributes.depth.value = well_info_array[0]
			ds_json.attributes.wellhead_height.value = well_info_array[1]
			ds_json.attributes.cable_length.value = well_info_array[2]
			console.log(dsname,ds_json.attributes)
			well_count++
			
		// FINISHED WITH ATTRIBUTE MODIFICATION
		} else {
			//console.log(ds_filename,"has no attributes that need to be modified.")
			ds_processed--
			ds_modified = false
		}
		// Write JSON back to file
		if(ds_modified == true) {
			// Write JSON file
			ds_json_string = JSON.stringify(ds_json,null,2)
			//console.log('Updating Datastream',ds_filename)
			fs.writeFileSync(path+ds_filename,ds_json_string,'utf-8')
		}
	} else {
		ds_no_match++
		console.log("Not Datastream JSON file!",ds_filename)
	}
}
console.log('DONE! '+ds_processed+' Datastreams processed out of',ds_count,'with',ds_no_match,'not matched.')
console.log("	ERPs found:",erp_count)
console.log("	VMS found:",vms_count)
console.log("	Soil moisture found:",soilmoisture_count)
console.log("	Soil temp found:",soiltemp_count)
console.log("	Air temp found:",airtemp_count)
console.log("	Wells found:",well_count)

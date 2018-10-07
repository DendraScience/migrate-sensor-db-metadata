/*
	Quail Ridge is getting special treatment again.  Attributes were never converted to metric. 
	Stangely, neither were the fieldnames. 
*/

fs = require("fs")
tr = require("./transform_functions.js")

function inches2mm(val) {
	if(val == '2') {
		valout = '50'
	} else if (val == '4') {
		valout = '100'
	} else if (val == '8') {
		valout = '200'
	} else if (val == '20') {
		valout = '500'
	} else {
		valout = (25.4*val).toString()
	}
	return valout
}

ds_path = "../data/migration3-incidents/ucnrs/station/quail-ridge/attribute_change/" 
console.log(ds_path)
ds_files = fs.readdirSync(ds_path)
ds_count = 0
ds_string_count = 0
ds_null = 0
// Loop through Datastream JSON files 
for(var i=0;i<ds_files.length;i++) {
	ds_filename = ds_files[i]
	if (ds_filename.match(/datastream.json$/)) {
		boo_export = false
		ds_count++
		ds_json = JSON.parse(fs.readFileSync(ds_path+ds_filename))
		if(typeof ds_json.attributes === 'undefined' || typeof ds_json.attributes.depth === 'undefined') {
			console.log(i,"NO attributes. Skip.",ds_json.name)
		} else {
			console.log(ds_json.name,Object.keys(ds_json.attributes))
			/*
			"attributes": {
		    "depth": {
		      "unit": "dt_Unit_Inch",
		      "value": 4
		    }
		  }
		  */

		  old_unit = ds_json.attributes.depth.unit
		  old_value = ds_json.attributes.depth.value
			if(old_unit == "dt_Unit_Inch") {
				ds_json.attributes.depth.unit = "dt_Unit_Millimeter"
				ds_json.attributes.depth.value = inches2mm(old_value)
				// change datastream name
				old_part = old_value.toString()+" in "
				new_part = ds_json.attributes.depth.value.toString()+" mm "
				ds_json.name = ds_json.name.replace(old_part,new_part)
				console.log(ds_json.name,old_unit,old_value,"-->",ds_json.attributes.depth.unit,ds_json.attributes.depth.value)
				boo_export = true
			}
		}
		if(boo_export == true) {
			console.log("\t",ds_json.attributes)
			// change datastream name
			old_part = old_value.toString()+"_in_"
			new_part = ds_json.attributes.depth.value.toString()+"_mm_"
			ds_filename = ds_filename.replace(old_part,new_part)
			// Write to file
			ds_json.name = ds_json.name.replace(old_part,new_part)
			ds_json_string = JSON.stringify(ds_json,null,2)
			console.log("\texporting.",ds_filename)
			ds_string_count++
			fs.writeFileSync(ds_path+ds_filename,ds_json_string,'utf-8')
		}
		//if(ds_count > 2) { break }

	} else {
		console.log("NOT JSON",ds_filename)
	}
} 
console.log("Attributes fixer Quail DONE. Datastreams processed:",ds_count,", des-strung:",ds_string_count,", null:",ds_null)

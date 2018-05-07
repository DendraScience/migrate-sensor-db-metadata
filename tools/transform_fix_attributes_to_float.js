/*
	ERCZO datastreams never had character cleaning like the UCNRS did.
	Influx doesn't like things like (). 

*/

fs = require("fs")
tr = require("./transform_functions.js")
//ds_path = "../data/migration2.1-rivendell/ucnrs/datastream/" 
orgs = ['erczo','ucnrs']
for (var k=0;k<orgs.length;k++) {
	org_slug = orgs[k]
	ds_path = "../data/migration2.1-rivendell/"+org_slug+"/datastream/" 
	console.log(ds_path)
	ds_files = fs.readdirSync(ds_path)
	ds_count = 0
	ds_string_count = 0
	ds_null = 0
	// Loop through Datastream JSON files 
	for(var i=0;i<ds_files.length;i++) {
		ds_filename = ds_files[i]
		if (ds_filename.match(/.json$/)) {
			boo_export = false
			ds_count++
			ds_json = JSON.parse(fs.readFileSync(ds_path+ds_filename))
			if(typeof ds_json.attributes === 'undefined') {
				//console.log(i,"NO attributes. Skip.",ds_json.name)
			} else {
				//console.log(ds_json.name,Object.keys(ds_json.attributes))
				for (var key in ds_json.attributes) {
					if(typeof ds_json.attributes[key].value === 'string') {
						val = ds_json.attributes[key].value
						fval = parseFloat(ds_json.attributes[key].value)
						console.log(i,ds_json.name,"String. converting to float",val,"-->",fval)
						ds_json.attributes[key].value = fval
						boo_export = true
					} else if(ds_json.attributes[key].value === null) {
						ds_null++
						boo_export = true
						console.log(i,"NULL.",ds_json.name,key,"==",ds_json.attributes[key].value) //,ds_json.attributes[key].value,typeof ds_json.attributes[key].value)
						delete ds_json.attributes[key]
						//console.log(i,"NULL DELETED.",ds_json.name,key,"==",ds_json.attributes[key].value) 
					}
				}
			}
			if(boo_export == true) {
				console.log("\t",ds_json.attributes)
				// Write to file
				ds_json_string = JSON.stringify(ds_json,null,2)
				console.log("\texporting.",ds_filename)
				ds_string_count++
				//fs.writeFileSync(ds_path+ds_filename,ds_json_string,'utf-8')
			}
		} else {
			//console.log("NOT JSON",ds_filename)
		}
	} 
	console.log("Attributes fixer DONE."+org_slug+" Datastreams processed:",ds_count,", des-strung:",ds_string_count,", null:",ds_null)
}
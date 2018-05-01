// Delete json files that have been manually edited and moved to dendra-managed
fs = require("fs")
args = process.argv.slice(2)
parent_path = args[0] // Requires trailing slash, e.g. "../data/migration2.1-rivendell/"
org_slug = args[1] // "erczo" or "ucnrs"
ds_path = parent_path+org_slug+"/datastream/" 

// Get list of Datastreams from directory
dm_path = "../data/dendra-managed/ucnrs/datastream/"
dm_files = fs.readdirSync(dm_path)
console.log('\nManually Edited Datastream count:',dm_files.length)

// Loop through Datastream JSON files 
ds_files = fs.readdirSync(ds_path)
for(var i=0;i<ds_files.length;i++) {
	ds_filename = ds_files[i]
	if (ds_filename.match(/.json$/)) {
		//console.log(i,ds_filename)
		for(var j=0;j<dm_files.length;j++) {
			if(dm_files[j] == ds_filename) {
				console.log(i,"MATCH! ",ds_filename,"==",dm_files[j],j)
				fs.unlinkSync(ds_path+ds_filename)
			}
		}
	}
}

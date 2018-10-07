/*
Migrate datastreams and stations into the same directory
@author: Collin Bode
@date: 2018-09-17

Purpose: run through station directory and datastream directory and copy both into organization
*/

fs = require("fs")
tr = require("./transform_functions.js")

// Argument processing of paths
args = process.argv.slice(2)
parent_path = args[0] // Requires trailing slash, e.g. "../data/migration2.1-rivendell/"
target_path = args[1] // Requires trailing slash, e.g. "../data/migration3-incidents/"
org_slug = args[2] // "erczo" or "ucnrs"
cpath = "../data/dendra-managed/"+org_slug+"/"
ppath = parent_path+org_slug+"/" 
tpath = target_path+org_slug+"/" 
dir_list = [ppath,cpath]

if(fs.existsSync(ppath) == false || fs.existsSync(tpath) == false) {
	console.log('usage: node ./transform-sensordb-insert-externalrefs-stations.js <migration_path/> <organization_slug>')
	console.log("\tDIR does not exist! Skipping.",ppath)
	process.exit()
}
console.log("\n Organization DIR:",ppath)


// Loop through Both Migration and Dendra-managed directories
for(var k=0;k<dir_list.length;k++) {
	// Loop through Datastreams and copy only that station's to new dir
	ss_path = dir_list[k]+'station/'
	if (!fs.existsSync(ss_path)) {
		console.log("DIR DOESN'T EXIST:"+ss_path+". CONTINUING...")
	  continue
	}

	// Get list of stations from directory
	//ss_path = ppath + 'station/'
	ss_files = fs.readdirSync(ss_path)
	console.log('Stations Path:',ss_path,"files found:",ss_files.length)

	// Loop through Station JSON files in org directory 
	ss_count = 0
	for(var i=0;i<ss_files.length;i++) {
		ss_filename = ss_files[i]
		if (ss_filename.match(/station.json$/)) {
			ss_count++
			ss_json = JSON.parse(fs.readFileSync(ss_path+ss_filename))
			ssid = ss_json._id

			// Make directory named after slug
			tpath_slug = tpath+'station/'+ss_json.slug+'/'
			try {
		    fs.mkdirSync(tpath_slug)
		  } catch (err) {
		    if (err.code !== 'EEXIST') throw err
		  }

			// Save Station JSON to new directory
			ss_json_string = JSON.stringify(ss_json,null,2)
			fs.writeFileSync(tpath_slug+ss_filename,ss_json_string,'utf-8')			
			console.log("Writen:"+tpath_slug+ss_filename)		
			
			// Loop through Both Migration and Dendra-managed directories
			for(var k=0;k<dir_list.length;k++) {
				// Loop through Datastreams and copy only that station's to new dir
				ds_path = dir_list[k]+'datastream/'
				if (!fs.existsSync(ds_path)) {
					console.log("DIR DOESN'T EXIST:"+ds_path)
				  continue
				}
				ds_files = fs.readdirSync(ds_path)
				console.log('Datastream Path:',ds_path,"files found:",ds_files.length)
				ds_count = 0
				for(var j=0;j<ds_files.length;j++) {
					ds_filename = ds_files[j]
					if (ds_filename.match(/datastream.json$/)) {
						ds_json = JSON.parse(fs.readFileSync(ds_path+ds_filename))
						// If Datastream station_id matches station, copy it to new location
						if(ds_json.station_id == ssid) {
							ds_json_string = JSON.stringify(ds_json,null,2)
							fs.writeFileSync(tpath_slug+ds_filename,ds_json_string,'utf-8')			
							console.log("\tWriten:"+ds_filename)		
							ds_count++
						}
					}
				}	
			}
			console.log("Station "+ss_json.slug+" found "+ds_count+" datastreams out of "+ds_files.length+"\n")
		} else {
			console.log("Not JSON file!",ss_filename)
		}
	}
}

console.log('DONE! '+ss_count+' Stations processed.')


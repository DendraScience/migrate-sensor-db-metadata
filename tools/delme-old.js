/*
Station ID inserter to Datastreams 
@author: Collin Bode
@date: 2018-02-28
*/
console.log("\n Station ID inserter to Datastreasms starting \n")

fs = require("fs")
args = process.argv.slice(2)
path = args[0] // Requires trailing slash, e.g. "../data/migration2.1-rivendell/" 
console.log('usage: node stationid_inserter_2datastreams.js <migration_path/>')
console.log('path found: ',path)
k = 0
l = 0

var get_station_mongo_promise = new Promise(function(resolve,stationpath,odm_station_id) {
		fs.readdir(stationpath,function(err,sfiles) {
			mongo_station_id = 'LALALALA'
			for (var j=0;j<sfiles.length;j++) {
				sfile_name = sfiles[j]
				//console.log(i,j,sfile_name)
				if (sfile_name.match(/.json$/)) {
					sfile_path = stationpath+sfile_name
					sfile_content = fs.readFileSync(sfile_path)
					jstation = JSON.parse(sfile_content)
					//console.log(jstation)
					sid = Number(jstation.external_refs[0].identifier)
					if(sid == odm_station_id) {
						console.log(j,jsf.name,', slug:',jstation.slug,', odm_station_id:',sid," = ",odm_station_id)
						//jsf.station_id = jstation._id
						mongo_station_id = jstation._id
						break
					}
				}				
			}
			resolve(mongo_station_id)
	})
});

// Loop through all files in datastream directory
dspath = path+'datastream/' 
//fs.readdir(dspath,function(err,files) {
files = ['ds_Medium_Air.ds_Variable_BarometricPressure.1608.datastream.json','ds_Medium_Air.ds_Variable_BarometricPressure.47.datastream.json']
for (var i=0;i<files.length;i++) {
	file_name = files[i]
	console.log(i,file_name)
	
	if (file_name.match(/.json$/)) {
		var dsfile = dspath+file_name
		file_content = fs.readFileSync(dsfile)
		var jsf = JSON.parse(file_content)
		
		// Loop through all stations in station directory 
		// Check for matching odm.stationid
		//console.log('before:',jsf.name,', station_id:',jsf.station_id)
		stationpath = path+'station/'
		odm_station_id = Number(jsf.external_refs[0].identifier)
		get_station_mongo_promise.then(function(stationpath,odm_station_id) {

		
		//get_station_mongoid(stationpath,odm_station_id).then(function(results) {
			jsf.station_id = results
			console.log('after:',jsf.name,', station_id:',jsf.station_id)
			// Write JSON file
			//jsf_out = JSON.stringify(jsf,null,2)
			//console.log('updating: ',dsfile)
			//fs.writeFileSync(dsfile,jsf_out,'utf-8')
		});
		//})

	} else {
		console.log("Not JSON file!",file_name)
	}
}
console.log("Done ",i," files processed.",k,"files matched with stations.")

//})
console.log("\n EXIT \n")
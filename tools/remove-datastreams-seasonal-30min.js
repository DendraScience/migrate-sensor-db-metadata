/* 
Datastream Diet
Purpose: to remove all datastreams that are now managed by other methods. 
Seasonal: climate, water year, and other aggregates are now generated by the aggregate engine. 
30min: now generated on the fly by aggregate engine.
Sample Methodology: Avg, Min, Max, Stdev, Cumulative, Sample are now folded into the same datastream.
ERCZO: 759 datastreams removed
UCNRS: 583 datastreams removed
*/

fs = require("fs")
tr = require("./transform_functions.js")
path = require("path")

// parameters
orgs = ["erczo","ucnrs"]
compost = "../compost/deprecated_datastreams/"
path_root = "../data/"

for (var i in orgs) {
	org = orgs[i]
	org_path = path_root+org+"/station/"
	console.log(org_path)
	compost_org = compost+org+"/"
	console.log(compost_org)

	// Seasonal datastreams - Find
	seasonal_path_list =[] 
	tr.recurse_dir(org_path,seasonal_path_list,RegExp(/seasonal.datastream.json$/i))
	//console.log(seasonal_path_list)
	console.log(org,'Seasonal Datastream count:',seasonal_path_list.length)

	// Seasonal datastreams - move to compost	
	for (var j in seasonal_path_list) {
		ds_name = seasonal_path_list[j][1]
		ds_path = seasonal_path_list[j][0]
		//console.log(ds_path+ds_name,"-->",compost_org+ds_name)
		fs.rename(ds_path+ds_name,compost_org+ds_name, (err)=>{
			if(err) throw err
			else console.log('moved',ds_name,'to',compost_org)
		})
	}

	// 30 minute datastreams - move to compost 
	// Seasonal datastreams - Find
	thirtymin_path_list =[] 
	tr.recurse_dir(org_path,thirtymin_path_list,RegExp(/30min.datastream.json$/i))
	//console.log(seasonal_path_list)
	console.log(org,'30min Datastream count:',thirtymin_path_list.length)

	// Seasonal datastreams - move to compost	
	for (var j in thirtymin_path_list) {
		ds_name = thirtymin_path_list[j][1]
		ds_path = thirtymin_path_list[j][0]
		//console.log(ds_path+ds_name,"-->",compost_org+ds_name)
		fs.rename(ds_path+ds_name,compost_org+ds_name, (err)=>{
			if(err) throw err
			else console.log('moved',ds_name,'to',compost_org)
		})
	}
}

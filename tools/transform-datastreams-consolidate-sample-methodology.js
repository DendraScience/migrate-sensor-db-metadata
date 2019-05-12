/* 
Datastream Diet: consolidate sample methodology
Purpose: to detect multiple sampling methodologies for the same instrument
and consolidate them into a single datastream. 
Sample Methodologies: Avg, Min, Max, Stdev, Cumulative
erczo Deprecated Datastreams: 759 (seasonal,30min)
erczo Datastream count: 980
	avg count 183
	min count 3
	max count 5
	med count 0
	stdev count 2
	cum count 16
	other count 0
	no aggregates 771

ucnrs Deprecated Datastreams: 583 (seasonals)
ucnrs Datastream count: 1130
	avg count 468
	min count 222
	max count 228
	med count 0
	stdev count 56
	cum count 27
	other count 0
	no aggregates 129
*/

fs = require("fs")
tr = require("./transform_functions.js")
path = require("path")

// parameters
orgs = ["erczo","ucnrs"]
compost = "../compost/deprecated_datastreams/"
path_root = "../data/"

function get_query_name(agg,name) {
	regex = /agg/gi
	query_name = name.replace(regex,'*')
	if(agg == 'cum') {
		console.log(query_name)
	}
	return query_name
}

function match_agg(agg_list,test_query_name){
	console.log("match_agg(agg_list("+agg_list.length+"),",test_query_name,")")
	for (var l=0; l<agg_list.length;l++) {
		list_query_name = agg_list[l][2]
		//console.log(avg,"=?=",pref)
		if(list_query_name.match(/test_query_name/)) {
			console.log("MATCH! ",test_query_name,"==",list_query_name,"-->",agg_list[l][1])
			return agg_list[l][1]
		}
	}
}

for (var i in orgs) {
	org = orgs[i]
	org_path = path_root+org+"/station/"
	console.log(org_path)
	compost_org = compost+org+"/"
	console.log(compost_org)

	// Datastreams - Find
	ds_path_list =[] 
	tr.recurse_dir(org_path,ds_path_list,RegExp(/datastream.json$/i))
	//console.log(seasonal_path_list)
	console.log(org,'Datastream count:',ds_path_list.length)

	// Datastreams - categorize sample methods
	avg_list = []
	min_list = []
	max_list = []
	med_list = []
	stdev_list = []
	cum_list = []
	other_list = []
	no_aggs = 0

	for (var j=0; j<ds_path_list.length;j++) {
		ds_filename = ds_path_list[j][1]
		ds_path = ds_path_list[j][0]
		ds_json = JSON.parse(fs.readFileSync(ds_path+ds_filename))
		agg = tr.get_tag(ds_json,'ds_Aggregate_')
		name = ds_json.name.toLowerCase()
		if(typeof agg != 'undefined') {
			//console.log(ds_json.name,agg)
			if(agg == 'ds_Aggregate_Average') {
				query_name = get_query_name("avg",name)
				avg_list.push([ds_path, ds_filename, query_name])	
			} else if(agg == 'ds_Aggregate_Maximum') {
				query_name = get_query_name("max",name)
				max_list.push([ds_path, ds_filename, query_name])	
			} else if(agg == 'ds_Aggregate_Median') {
				query_name = get_query_name("med",name)
				med_list.push([ds_path, ds_filename, query_name])
			} else if(agg == 'ds_Aggregate_Minimum') {
				query_name = get_query_name("",name)
				min_list.push([ds_path, ds_filename, query_name])
			} else if(agg == 'ds_Aggregate_StandardDeviation') {
				query_name = get_query_name("",name)
				stdev_list.push([ds_path, ds_filename, query_name])
			} else if(agg == 'ds_Aggregate_Cumulative') {
				query_name = get_query_name("",name)
				cum_list.push([ds_path, ds_filename, query_name])
			} else {
				other_list.push([ds_path,ds_filename,ds_json.name.toLowerCase()])
			}
		} else {
			no_aggs++
		}
	}

	// What did we find?
	console.log('avg count',avg_list.length)
	console.log('min count',min_list.length)
	console.log('max count',max_list.length)
	console.log('med count',med_list.length)
	console.log('stdev count',stdev_list.length)
	console.log('cum count',cum_list.length)
	console.log('other count',other_list.length)
	console.log('no aggregate',no_aggs)

	// Try to match avg,min,max,stdev to a single datasream
	// Assumes avg is in all of them
	ds_list = []
	for (var k=0;k<avg_list.length;k++) {
		pref = avg_list[k][2]
		combined_list = []
		temp_list = []
		temp_list.push(match_agg(max_list,pref))
		temp_list.push(match_agg(med_list,pref))
		temp_list.push(match_agg(min_list,pref))
		temp_list.push(match_agg(stdev_list,pref))
		temp_list.push(match_agg(cum_list,pref))
		temp_list.push(match_agg(other_list,pref))
		for (var m=0; m<temp_list.length;m++) {
			if(typeof temp_list[m] != 'undefined') {
				combined_list.push(temp_list[m])
			}
		}

		if(combined_list.length > 0) {
			combined_list.push(avg_list[k][1])
			//combined_list.push("\t\t\t\t")
			ds_list.push(combined_list)
		}	
	}
	console.log(org,'aggregate count:',ds_list.length)

	// try again with cumulative
	ds_cum_list = []
	for (var k=0;k<cum_list.length;k++) {
		pref = cum_list[k][2]
		combined_list = []
		temp_list = []
		temp_list.push(match_agg(avg_list,pref))
		temp_list.push(match_agg(max_list,pref))
		temp_list.push(match_agg(med_list,pref))
		temp_list.push(match_agg(min_list,pref))
		temp_list.push(match_agg(stdev_list,pref))
		temp_list.push(match_agg(other_list,pref))
		for (var m=0; m<temp_list.length;m++) {
			if(typeof temp_list[m] != 'undefined') {
				combined_list.push(temp_list[m])
			}
		}

		if(combined_list.length > 0) {
			combined_list.push(avg_list[k][1])
			combined_list.push("\t\t\t\t")
			ds_cum_list.push(combined_list)
		}	
	}
	console.log(ds_cum_list)
	console.log(org,'cumulative count:',ds_cum_list.length)


}

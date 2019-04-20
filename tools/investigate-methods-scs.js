/*
Compare Methods to JSON
Author: Collin Bode
Date: 2019-03-18
Purpose: Compare the Campbell SCS JSON files to our exported Methods. Do we have any matches?
*/

fs = require("fs")
tr = require("./transform_functions.js")
path = require("path")

// File paths
wpath = "../compost/migration4-methods/"

//wpath = "../../../dendra_dev/equipment_library/"
//equip_path = wpath+"equipment_library/CampbellSci_Equipment_List_Full/"
equip_path = wpath+"equipment_library/"
method_path = wpath+"method/"

// Run through methods directory gather list of path & files	
method_filepath_list = []
tr.recurse_dir(method_path,method_filepath_list,RegExp(/method.json$/i)) // Note: RegEx is not really used
console.log("Methods Traverse complete. list length:",method_filepath_list.length)

// Run through JSON equipment directory gather list of path & files	
equip_filepath_list = []
tr.recurse_dir(equip_path+"json/",equip_filepath_list,RegExp(/scs.json$/i)) // Note: RegEx is not really used
console.log("Campbell json for CR1000 Traverse complete. list length:",equip_filepath_list.length)

// Run through SCS equipment directory gather list of path & files	
scs_filepath_list = []
tr.recurse_dir(equip_path+"CampbellSci_Equipment_List_Full/",scs_filepath_list,RegExp(/.scs$/i)) // Note: RegEx is not really used
console.log("Campbell SCS Traverse complete. list length:",scs_filepath_list.length)

// Run through SCS equipment directory gather list of path & files	
images_filepath_list = []
tr.recurse_dir(equip_path+"CampbellSci_Equipment_List_Full/images/",images_filepath_list,RegExp(/.*/)) // Note: RegEx is not really used
console.log("Campbell images Traverse complete. list length:",images_filepath_list.length)

// How many JSON files use a particular image?
// Images matched: 423 out of 206 total images.
match = 0
for (var l=0;l<images_filepath_list.length;l++) {
	imatch = 0
	ifilename = images_filepath_list[l][1]
	console.log(l,ifilename)
	for (var e=0;e<equip_filepath_list.length;e++) {
		efilename = equip_filepath_list[e][1]
		//console.log(l,ifilename,e,efilename)
		eq = JSON.parse(fs.readFileSync(equip_filepath_list[e][0]+equip_filepath_list[e][1],'utf8'))

		if(ifilename == eq.ImageFile) {
			//console.log("MATCH!",l,ifilename,"===",e,eq.ImageFile)
			match++
			imatch++
		}
	}
	console.log(ifilename,"matches:",imatch)	
}
console.log("Images matched:",match,"out of",images_filepath_list.length,"total images.")

/*
// How many SCS files use a particular image?
// Images matched: 1042 out of 206 total images.
match = 0
for (var l=0;l<images_filepath_list.length;l++) {
	imatch = 0
	ifilename = images_filepath_list[l][1]
	console.log(l,ifilename)
	for (var s=0;s<scs_filepath_list.length;s++) {
		sfilename = scs_filepath_list[s][1]
		//console.log(l,ifilename,s,sfilename)
		scs_binary = fs.readFileSync(scs_filepath_list[s][0]+scs_filepath_list[s][1],'utf8')
		scs = scs_binary.toString().split('\r\n')
		image = ""
		for (var r=0;r<scs.length;r++) {
			row = scs[r]
			pair = row.split('=')
			if(pair.length == 1) {
				continue
			}
			if(pair[0] == 'ImageFile') {
				image = pair[1]
				//console.log("\t",r,sfilename,"image:",image)
				break
			}
		}
		if(ifilename == image) {
			//console.log("MATCH!",l,ifilename,"===",s,image)
			match++
			imatch++
		}
	}
	console.log(ifilename,"matches:",imatch)	
}
console.log("Images matched:",match,"out of",images_filepath_list.length,"total images.")
*/

/* 
// Compare Method Name with JSON filename: only 23 matches
match = 0
for (var l=0;l<equip_filepath_list.length;l++) {
	filename = equip_filepath_list[l][1]
	eq = JSON.parse(fs.readFileSync(equip_filepath_list[l][0]+equip_filepath_list[l][1],'utf8'))
	//console.log(filename, eq.Shortname)

	pref = filename.split(".")[0]
	//console.log(pref)

	for (var m=0;m<method_filepath_list.length;m++) {
		meth = JSON.parse(fs.readFileSync(method_filepath_list[m][0]+method_filepath_list[m][1],'utf8'))
		if(meth.MethodName.toLowerCase().indexOf(pref) > -1) {
			console.log("MATCH!",l,pref,"===",m,meth.MethodName)
			match++
		} 
	}
}
console.log("Matches:",match,"out of",method_filepath_list.length,"methods.")
*/
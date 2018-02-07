/* 
* duplicate_id_finder.js
* @author=collin bode
* @date=2018-01-07
*/

console.log("\n Duplicate id finder starting \n")

// Recurse through directory structure and get list of files
fs = require("fs")
dir = require('node-dir')
dirname = "../data/"
var files = dir.files(dirname, {sync:true})
//console.log(files)
console.log('JSON file count:',files.length)

// Pull valid MongoIDs from JSON
id_array = new Array()
for (var i=0;i<files.length;i++) {
	if (files[i].match(/.json$/)) {
		//console.log(files[i])
		file_content = fs.readFileSync(files[i])
		jsf = JSON.parse(file_content)
		if(jsf._id === undefined) {
			console.log('JSON ID UNDEFINED:',files[i])
		} else {
			id_length = jsf._id.length
			if(jsf._id.length == 24) {
				id_array.push([jsf._id,jsf.name,files[i]])
				//console.log(id_length,jsf._id,jsf.name)
			}	
		}
	} else {
		console.log('NOT JSON: ',files[i])
	}
}
console.log('Mongo IDs harvested:',id_array.length)

// Run through IDs and see if there are duplicates
dups_array = new Array()
for (var i=0;i<id_array.length;i++) {
	test_id = id_array[i][0]
	test_name = id_array[i][1]
	test_path = id_array[i][2]
	for (var j=0;j<id_array.length;j++) {
		if(test_id == id_array[j][0] && i != j) {
			if(test_name == id_array[j][2]) {
				console.log('Dup, but same datastream. Names match.',test_name)
			} else {
				dups_array.push([test_id,test_name,test_path,id_array[j][1],"\n"])
				console.log('DUP! ',test_name,'==',id_array[j][1])
				console.log('     ',test_path,'-->',id_array[j][2])
			}
		}
	}	
}
console.log('DUPS found: ',dups_array.length)

// Write DUPS to file
fs.writeFile("dups.csv", dups_array, function(err) {
    if(err) {
        return console.log(err);
    }

    console.log("The file was saved!");
}); 

/*
// Write DUPS to file
//fs.writeFileSync('dups.csv',jsf_out,'utf-8')
dup_file = fs.open('dups.csv','w')
for (var i=0;i<dups_array.length;i++) {
	dup_file.writeln(dups_array[i][0],dups_array[i][1],dups_array[i][2])
}
dup_file.close()
*/
/*
// Loop through all files and extract mongo IDs 
fs.readdir(path,function(err,files) {
	for (var i=0;i<files.length;i++) {
		file_name = files[i]
		console.log(i,file_name)

		if(file_name.match(/z_/)) {
			console.log("Already Processed: ",file_name)
		} 
		else if (file_name.match(/.json$/)) {
			file_content = fs.readFileSync(path+file_name)
			jsf = JSON.parse(file_content)
			console.log('before',file_name,jsf.name,jsf._id)
			delete jsf._id
			console.log('after',file_name,jsf.name,jsf._id)

			// Write JSON file
			jsf_out = JSON.stringify(jsf,null,2)
			fs.writeFileSync(path+'fix/'+file_name,jsf_out,'utf-8')

		} else {
			console.log("Not JSON file!",file_name)
		}
	}
	console.log("Done with file list",i,files.length)
})
*/
console.log("\n EXIT \n")
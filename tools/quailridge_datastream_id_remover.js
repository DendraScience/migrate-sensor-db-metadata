/* 
* quail_ridge_datastream_id_remover.js
* @author=collin bode
* @date=2018-01-07
*/

console.log("\n Quail Ridge id remover starting \n")

fs = require("fs")
path = "../data/migration2-happyhybrid/datastream/"

// Loop through all files in datastream directory 
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


console.log("\n EXIT \n")
/* 
* json_id_remover.js
* @author=collin bode
* @date=2018-01-07
*/

console.log("\n JSON id remover starting \n")

fs = require("fs")
args = process.argv.slice(2)
path = args[0] // Requires trailing / "../data/migration2-happyhybrid/datastream/" 
console.log('json_id_remover ',path)

// Loop through all files in datastream directory 
fs.readdir(path,function(err,files) {
	for (var i=0;i<files.length;i++) {
		file_name = files[i]
		console.log(i,file_name)
		
		if (file_name.match(/.json$/)) {
			file_content = fs.readFileSync(path+file_name)
			jsf = JSON.parse(file_content)
			console.log('before',file_name,jsf.name,jsf._id)
			delete jsf._id
			console.log('after',file_name,jsf.name,jsf._id)

			// Write JSON file
			jsf_out = JSON.stringify(jsf,null,2)
			outpath = path+'fix/'+file_name
			console.log('no id file: ',outpath)
			fs.writeFileSync(outpath,jsf_out,'utf-8')

		} else {
			console.log("Not JSON file!",file_name)
		}
	}
	console.log("Done with file list",i,files.length)
})

console.log("\n EXIT \n")
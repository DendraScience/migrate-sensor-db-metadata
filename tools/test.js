fs = require("fs")
tr = require("./transform_functions.js")
path = require("path")

sname_list = JSON.parse(fs.readFileSync("remove-stationname-from-datastreams.json"))

for (var name in sname_list) {
	console.log(name)
	for (var m=0;m<sname_list[name].length;m++) {
		console.log("\t",sname_list[name][m])
	}
}
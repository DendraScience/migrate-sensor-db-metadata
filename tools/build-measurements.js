/*
Build Measurements
*/

fs = require("fs")
tr = require("./transform_functions.js")
path = require("path")
csv = require("csv-parser")

// parameters
orgs = ["erczo"]  // ["erczo","ucnrs","chi"]
path_root = "../data/"

medium_variable_list = JSON.parse(fs.readFileSync("medium_variable_list.json"))


for (var j=0;j<medium_variable_list.length;j++) {
	row = medium_variable_list[j]
	console.log(row)
}

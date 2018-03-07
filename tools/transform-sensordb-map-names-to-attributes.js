/*
Dendra Map Datastream Names to Attributes
@author=CollinBode
@Date=2018-02-18
@email=collin@berkeley.edu
*/

// Imports
mysql = require('mysql')
fs = require('fs')

// Pick which MySQL Server to use
hostname = "localhost"
f = ['collin','river']

//hostname = "gall.berkeley.edu"
//f = fs.readFileSync("../../odm.pw").toString().split('\n')
// user = f[0]
// password = f[1]

conn = mysql.createConnection({
	host: hostname,
	user: f[0],
	password: f[1],
	database: "odm"
})


conn.connect(function(err) {
	if(err) throw err
	console.log("Connected to local ODM!")
	
	// ERP depths parsed 
	sql = "SELECT datastreamid,datastreamname FROM datastreams WHERE variablecode = 'Resistance' AND MC_Name = 'Angelo Reserve'"
	conn.query(sql,function(err,result,fields) {
		if(err) throw err
		Object.keys(result).forEach(function(key) {
			row = result[key]
			name = row.datastreamname 
			location = name.substring(name.search('ERP ')+4,name.search('-'))
			attribute = name.substring(name.search('-')+1)
			//console.log(row.datastreamname," Location:",location," Attribute:",attribute)
			attribute_num = Number(attribute)
			//console.log(attribute,attribute_num)
			if(!isNaN(attribute_num)) {
				output = "REPLACE INTO `dendra_map_datastreams_attributes` VALUES ('"+row.datastreamname+"', 'Depth', NULL, NULL, NULL, NULL, "+attribute+", 'Meter', NULL);"
				console.log(output)
				conn.query(output,function(err,insert_result) { if(err) throw err })
			}
		})
		//conn.end()
		//console.log("Result:",result)
	})


	// VMS depths parsed 
	vms = [
		['A1','1.9','2.1'],
		['A2','3.5','3.7'],
		['A3','5.1','5.3'],
		['A4','6.8','7.0'],
		['A5','8.4','8.6'],
		['A6','10.1','10.3'],
		['A7','11.8','12.0'],
		['A8','13.2','13.4'],
		['A9','14.8','15.0'],
		['A10','16.4','16.6'],
		['B1','0.2','1.7'],
		['B2','1.9','3.2'],
		['B3','3.4','4.7'],
		['B4','5.0','6.4'],
		['B5','6.6','7.9'],
		['B6','8.2','9.5'],
		['B7','9.8','11.0'],
		['B8','11.2','12.4'],
		['B9','12.6','13.8'],
		['B10','14.1','15.6'],
		['G1','0.2','1.4'],
		['G2','1.9','3.0'],
		['G3','3.4','4.5'],
		['G4','5.0','6.1'],
		['G5','6.6','7.7'],
		['G6','8.2','9.3'],
		['G7','9.8','10.8'],
		['G8','11.2','12.2'],
		['G9','12.6','13.7'],
		['G10','14.1','15.3']
	]
	//conn.connect(function(err) {
	if(err) throw err
	sql = "SELECT datastreamid,datastreamname FROM datastreams WHERE stationname like 'VMS'";
	conn.query(sql,function(err,result,fields) {
		if(err) throw err
		Object.keys(result).forEach(function(key) {
			row = result[key]
			name = row.datastreamname 
			position = name.substring(name.search('_')+1)
			//console.log(row.datastreamname," Position: ",position,position.length)
			if(position.length < 4) {
				depth1 = 0
				depth2 = 0
				for(var j=0;j<vms.length;j++) {
					test_position = vms[j][0]
					if(test_position == position) {
						depth1 = Number(vms[j][1])
						depth2 = Number(vms[j][2])
						//console.log("Match!",test_position,position,"depth1: ",depth1," depth2:",depth2)
						// Insert Attributes
						output = "REPLACE INTO `dendra_map_datastreams_attributes` VALUES ('"+row.datastreamname+"', 'Depth', NULL, NULL, "+depth1+", "+depth2+", NULL, 'Meter', NULL);"
						console.log(output)
						conn.query(output,function(err,insert_result) { if(err) throw err })
					}
				}
			} else {
				console.log("VMS datastream without position!",name)
			}
		})
		//conn.end()
	})
	
	/*
	Soil Moisture 
	Orientation (vertical or horizontal) and depth of probes is very important to understand the data.
	There are several kinds and variable codes for soil moisture. This requires several selects
	TDR's are named with Level, Orientation, Site, then depth in meters.
	"Soil Moisture L1T1_0.25"
	<Soil Moisture ><L1><T><1>_<0.25> 
	Two name prefixes: "TDR L", "Soil Moisture L"
	Orientation:  
		T = vertical, 30 cm probe, 29 in silica flour
		S = horizontal, 7.5 cm probe
	*/
	sql = "SELECT datastreamid,datastreamname FROM datastreams WHERE "+ 
	"(DatastreamName like '%Soil Moisture L%'"+
	" OR DatastreamName like '%TDR L%')"+
	" AND MC_Name = 'Angelo Reserve'"+ 
	" AND MethodId != 29"
	conn.query(sql,function(err,result) {
		if(err) throw err
		Object.keys(result).forEach(function(key) {
			row = result[key]
			name = row.datastreamname 
			orientation = name.substring(name.search('_')-2,name.search('_')-1)
			if(orientation == 'T') {
				orientation = 'vertical'
			} else if(orientation == 'S') {
				orientation = 'horizontal'
			} else { 
				throw err 
			}
			depth = Number(name.substring(name.search('_')+1))
			//console.log(row.datastreamname," Orientation:",orientation," Depth:",depth)
			output1 = "REPLACE INTO `dendra_map_datastreams_attributes` VALUES ('"+row.datastreamname+"', 'Depth', NULL, NULL, NULL, NULL, "+depth+", 'Meter', NULL);"
			output2 = "REPLACE INTO `dendra_map_datastreams_attributes` VALUES ('"+row.datastreamname+"', 'Orientation', NULL, NULL, NULL, NULL, NULL, NULL, '"+orientation+"');"
			console.log(output1)
			console.log(output2)
			conn.query(output1,function(err,insert_result) { if(err) throw err })
			conn.query(output2,function(err,insert_result) { if(err) throw err })
		}) // end Object
	}) // end conn.query
	// end Soilt Moisture

	// Soil Temperature 
	// Depths but no orientation. One is blank.
	sql = "SELECT datastreamid,datastreamname FROM datastreams WHERE "+ 
	"DatastreamName like '%Soil Temp L%'"+
	" AND MC_Name = 'Angelo Reserve'"
	conn.query(sql,function(err,result) {
		if(err) throw err
		Object.keys(result).forEach(function(key) {
			row = result[key]
			name = row.datastreamname 
			depth = Number(name.substring(name.search('_')+1))
			//console.log(row.datastreamname," Depth:",depth)
			if(!isNaN(depth)) {
				output = "REPLACE INTO `dendra_map_datastreams_attributes` VALUES ('"+row.datastreamname+"', 'Depth', NULL, NULL, NULL, NULL, "+depth+", 'Meter', NULL);"
				console.log(output)
				//conn.query(output,function(err,insert_result) { if(err) throw err })
			} else { console.log(name," NOT VALID!!")}
		}) // end Object
		conn.end()
	}) // end conn.query
	// end Soil Temperature

})

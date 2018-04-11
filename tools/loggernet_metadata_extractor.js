/*
loggernet_metadata_extractor.js
@author: collin Bode
@date: 2018-03-27
Purpose: to parse the LoggerNet XML configuration file
and extract ifnormation about the stations and their tables
*/
fs = require('fs')
parseString = require('xml2js').parseString

/*
Station Object
{
	"name": "RML2_3",
	"organization_slug":"erczo",
	"status_tables": [
		{
			"name": "Public",
			"fields": [lots of fields]
		}
	],
	"data_tables": [
		{
			"name":"Table203",
			"fields": [
				'BattV',
			  'L203Temp',
			  'Well13_psi',
			  'Well13_WaterLevel_m',
			  'Well13_ToC',
			  'Well14_psi',
			  'Well14_WaterLevel_m',
			  'Well14_ToC'
			]
		}
	]
}
*/

// For each organization/instance of loggernet, extract stations and tables
stations = []
org_slugs = ["ucnrs","erczo"]
for (var o=0;o<org_slugs.length;o++) {
	org_slug = org_slugs[o]
	csi_name = "CsiLgrNet_"+org_slug+".xml"
	xml_data = fs.readFileSync(csi_name)
	console.log("Parsing ",org_slug,"in",csi_name,"for loggernet stations and tables")
	parseString(xml_data, function(err,dj) {
		if(err) { console.log('ERROR',err) } 
		brokers = dj['lgrnet-config']['data-brokers'][0]['data-broker']
		broker_count = brokers.length
		for (var i =0;i<broker_count;i++) {
			station = {}
			station.name = brokers[i]['$'].name
			station.organization_slug = org_slug
			// Sagehen decrepit stations
			if(lstation.name.match("Station") && org_slug == "ucnrs") {
				station.organization_slug = "sagehen"
				console.log('Sagehen!',lstation.name)
			}

			station.data_tables = []
			//station.status_tables = []
			if(typeof brokers[i].table !== 'undefined') {
				console.log(i,station.name,"table count",brokers[i].table.length)
				for (var j=0;j<brokers[i].table.length;j++) {
					table_name = brokers[i].table[j]['$'].name
					fields = []
					for(var k=0;k<brokers[i].table[j]['column'].length;k++) {
						fields.push(brokers[i].table[j]['column'][k]['$'].name)
					}
					if(table_name == "Status" || table_name == "Public" || table_name == "DataTableInfo") {
						//station.status_tables.push({"name":table_name,"fields":fields})
						console.log("\t status table:",table_name)
					} else {
						station.data_tables.push({"name":table_name,"fields":fields})
						console.log("\t data table:",table_name)
					}
					//console.log("\t fields:",fields)
				}
			}
			stations.push(station)
		}
		//console.log("station json:",stations)
	})
}

// Write station list to file
stations_str = JSON.stringify(stations,null,4)
fs.writeFileSync('stations_loggernet.json',stations_str,'utf-8')
console.log("DONE!")
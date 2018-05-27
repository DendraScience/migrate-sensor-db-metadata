/*
loggernet_metadata_extractor.js
@author: collin Bode
@date: 2018-03-27
Purpose: to parse the LoggerNet XML configuration file
and extract information about the stations and their tables
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
filedate =  "2018-05-26" //"2018-04-11"

org_slugs = ["ucnrs","erczo"]
for (var o=0;o<org_slugs.length;o++) {
	stations = []
	org_slug = org_slugs[o]
	csi_name = "/Users/collin/dendra_dev/LoggerNetConfigs/"+"CsiLgrNet_"+org_slug+"_"+filedate+".xml"
	xml_data = fs.readFileSync(csi_name)
	console.log("Parsing ",org_slug,"in",csi_name,"for loggernet stations and tables")
	parseString(xml_data, function(err,dj) {
		if(err) { console.log('ERROR',err) } 

		// Brokers seem to be CSI for loggers	
		brokers = dj['lgrnet-config']['data-brokers'][0]['data-broker']
		broker_count = brokers.length
		for (var i =0;i<broker_count;i++) {
			station = {}
			station.name = brokers[i]['$'].name
			if(station.name.match(/[Ss]tation/)) {
				station.organization_slug = 'sagehen'
			} else {
				station.organization_slug = org_slug
			}
			station.program_name = brokers[i]['$']['program-name']
			station.data_tables = []
			//console.log(station.name,station.program_name)
			//station.status_tables = []
			if(typeof brokers[i].table !== 'undefined') {
				//console.log(i,station.name,"table count",brokers[i].table.length)
				for (var j=0;j<brokers[i].table.length;j++) {
					table_name = brokers[i].table[j]['$'].name
					fields = []
					for(var k=0;k<brokers[i].table[j]['column'].length;k++) {
						fields.push(brokers[i].table[j]['column'][k]['$'].name)
					}
					if(table_name == "Status" || table_name == "Public" || table_name == "DataTableInfo") {
						//station.status_tables.push({"name":table_name,"fields":fields})
						//console.log("\t status table:",table_name)
					} else {
						station.data_tables.push({"name":table_name,"fields":fields})
						//console.log("\t data table:",table_name)
					}
					//console.log("\t fields:",fields)
				}
			}
			stations.push(station)
		}

		// Start Time of current cache of data is dependent on the program being loaded
		// So we have to find the datetime of program under devices
		start_count = 0
		devices = dj['lgrnet-config']['devices'][0]['device']
		for (var l=0;l<devices.length;l++) {
			device_name = devices[l]['$'].name
			for(var m=0;m<stations.length;m++) {
				if(device_name == stations[m].name) {
					//console.log("Logger Found! dev:",device_name,", station:",stations[m].name)
					settings = dj['lgrnet-config']['devices'][0]['device'][l]['class-dev'][0]['settings'][0]['setting']
					//console.log("settings length:",settings.length)					
					for(var n=0;n<settings.length;n++) {
						//console.log(device_name,settings[n]['$']['id'])
						if(settings[n]['$']['id'] == 13) {
							program_startdate = settings[n]['$']['when']
							if(program_startdate != "1990-01-01T00:00:00") {
								console.log(device_name,",when:",program_startdate)
								stations[m].program_startdate = program_startdate
								start_count++
							} else {
								console.log(device_name,'indeterminate start date. skipping.')
							}
						}
					}
				}
			} 
		}
		//console.log("station json:",stations)
	})

	// Export organization station list to file
	stations_str = JSON.stringify(stations,null,4)
	fs.writeFileSync('stations_loggernet_'+org_slug+'_'+filedate+'.json',stations_str,'utf-8')	
	console.log(org_slug,"Program start dates. Found:",start_count,", Total Stations:",stations.length)
}

// Write station list to file
//stations_str = JSON.stringify(stations,null,4)
//fs.writeFileSync('stations_loggernet_2018-04-11.json',stations_str,'utf-8')
console.log("DONE!")
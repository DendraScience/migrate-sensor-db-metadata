/* 
* @author=collin bode
* @date=2017-12-18
*/

console.log("\n UCNRS Battery Voltage Creator \n")
fs = require("fs")
path = "../data/migration2-happyhybrid/datastream/"

station_text = fs.readFileSync("stations.js")
stations = JSON.parse(station_text)
console.log('number of stations:',stations.list.length)


function get_station_id(stations,station_id) {
  for(var i=0;i<stations.list.length;i++) {
    station = stations.list[i]
    if(station.station_id == station_id) {
      console.log("FOUND! ",station.name, station.station_id,station._id)
      return station._id
    }
  }
}

//teststation = get_station_id(stations,335)
//console.log("testation:",teststation)

// List of Station ID, Datastream ID, Name, FieldName, StartDate
battery_list = [
  [334,3082,"Precipitation mm Blue Oak,2011-06-03 13:00:00"],
  [356,3146,"Precipitation Geonor mm SNARL,2012-07-11 12:00:00"],
  [335,3350,"Precipitation mm Angelo,2013-05-07 15:10:00"],
  [333,3297,"Precipitation mm Hastings,2011-01-31 16:50:00"],
  [336,3390,"Precipitation mm Bodega,2012-06-27 14:50:00"],
  [337,3427,"Precipitation mm Deep Canyon,2010-09-29 10:10:00"],
  [338,3467,"Precipitation mm Burns,2010-09-30 11:00:00"],
  [339,3491,"Precipitation mm Chickering,2013-08-21 11:10:00"],
  [341,3528,"Precipitation mm Elliott,2010-09-28 16:00:00"],
  [343,3576,"Precipitation mm James,2009-12-31 22:30:00"],
  [344,3605,"Precipitation mm Jepson,2013-04-30 09:50:00"],
  [345,3642,"Precipitation mm Rancho Marino,2011-02-01 13:40:00"],
  [346,3681,"Precipitation mm BigCreek Whale,2016-07-09 02:50:00"],
  [347,3692,"Precipitation mm BigCreek Highlands,2016-07-09 02:50:00"],
  [350,3717,"Precipitation mm McLaughlin,2011-12-14 14:20:00"],
  [351,3770,"Precipitation mm Motte,2010-09-28 10:30:00"],
  [354,3823,"Precipitation mm Santa Cruz Island,2013-01-01 00:00:00"],
  [355,3876,"Precipitation mm Sedgwick,2011-05-18 14:50:00"],
  [356,3929,"Precipitation mm SNARL,2012-07-11 12:00:00"],
  [357,3982,"Precipitation mm Anza Borrego,2013-04-30 13:40:00"],
  [358,4022,"Precipitation mm Stunt Ranch,2012-06-22 12:30:00"],
  [359,4046,"Precipitation mm Granites,2010-09-30 17:50:00"],
  [361,4095,"Precipitation mm WhiteMt Barcroft,2003-11-01 15:40:00"],
  [362,4118,"Precipitation mm WhiteMt Crooked,2005-04-15 19:00:00"],
  [363,4147,"Precipitation mm Younger,2015-09-02 16:50:00"],
  [364,4176,"Precipitation mm Sagehen Creek,1997-04-02 21:00:00"],
  [364,4184,"Precipitation Geonor mm Sagehen Creek,1997-04-02 21:00:00"],
  [342,4203,"Precipitation mm Fort Ord,2016-11-30 12:10:00"]
]

// Load Voltage JSON
jsonText = '{"name": "Battery Voltage volts Quail Ridge Min","station_id": "MONGOID",'+
  '"description": "TBD","tags": ["ds_Medium_Precipitation","ds_Variable_Precipitation","dt_Unit_Millimeter"],'+
  '"external_refs": [{"identifier": "-9999","type": "odm.datastreams.datastreamid"},'+
  '{"identifier": "-99", "type": "odm.stations.stationid"}],'+
  '"datapoints_config": [{"params": {"query": {"datastream_id": -9999,"compact": true,"time_adjust": -28800}},'+
  '"begins_at": "2013-04-30T13:40:00Z","path": "/legacy/datavalues-ucnrs"}],'+
  '"source_type": "sensor","state": "ready","enabled": true}'
jsonVolt = JSON.parse(jsonText)
console.log('Name:',jsonVolt.name)

for (var i=0;i<battery_list.length;i++) {
  sid = battery_list[i][0].toString()
  dsid = battery_list[i][1]
  dsname = battery_list[i][2]
  start_date = battery_list[i][3]
  station_mongoid = get_station_id(stations,sid)
  console.log(i,dsname,start_date,station_mongoid)

  // Assign the JSON values from the array
  jsonVolt.name = dsname
  jsonVolt.station_id = station_mongoid
  jsonVolt.external_refs[0].identifier = dsid.toString()
  jsonVolt.external_refs[1].identifier = sid
  jsonVolt.datapoints_config[0].params.query.datastream_id = dsid
  jsonVolt.datapoints_config[0].begins_at = start_date 

  // Write the new JSON file
  re = new RegExp(" ", 'g');
  file_out_name = jsonVolt.name.replace(re,"_")+".datastream.json" // replace all spaces with underscores
  jsonVolt_out = JSON.stringify(jsonVolt,null,2)
  fs.writeFileSync(path+file_out_name,jsonVolt_out,'utf-8')

}

console.log("\n EXIT \n")
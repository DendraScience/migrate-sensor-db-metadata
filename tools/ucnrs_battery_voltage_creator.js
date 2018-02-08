/* 
* quail_ridge_datastream_migrator.js
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
  [334,3111, "Battery Voltage volts Blue Oak Min", "2011-06-03 13:00:00"],
  [345,3122, "Battery Voltage volts Rancho Marino Min", "2011-11-01 13:40:00"],
  [333,3326, "Battery Voltage volts Hastings Min", "2011-01-31 16:50:00"],
  [335,3379, "Battery Voltage volts Angelo Min", "2013-05-07 15:10:00"],
  [337,3456, "Battery Voltage volts Deep Canyon Min", "2010-09-29 10:10:00"],
  [341,3557, "Battery Voltage volts Elliott Min", "2010-09-28 16:00:00"],
  [343,3594, "Battery Voltage volts James Min", "2009-12-31 22:30:00"],
  [345,3671, "Battery Voltage volts Rancho Marino Min", "2011-02-01 13:40:00"],
  [350,3746, "Battery Voltage volts McLaughlin Min", "2011-12-14 14:20:00"],
  [351,3799, "Battery Voltage volts Motte Min", "2010-09-28 10:30:00"],
  [354,3852, "Battery Voltage volts Santa Cruz Island Min", "2013-01-01 00:00:00"],
  [355,3905, "Battery Voltage volts Sedgwick Min", "2011-05-18 14:50:00"],
  [356,3958, "Battery Voltage volts SNARL Min", "2012-07-11 12:00:00"],
  [357,4011, "Battery Voltage volts Anza Borrego Min", "2013-04-30 13:40:00"],
  [360,4076, "Battery Voltage volts WhiteMt Summit Min", "2003-09-10 20:00:00"],
  [361,4100, "Battery Voltage volts WhiteMt Barcroft Min", "2003-11-01 15:40:00"],
  [362,4123, "Battery Voltage volts WhiteMt Crooked Min", "2005-04-15 19:00:00"],
  [363,4159, "Battery Voltage volts Younger Min", "2015-09-02 16:50:00"],
  [364,4180, "Battery Voltage volts Sagehen Creek Min", "1997-04-02 21:00:00"],
  [342,4197, "Battery Voltage volts Fort Ord Min", "2016-11-30 12:10:00"],
  [348,4248, "Battery Voltage volts BigCreek Gatehouse Min", "2013-08-22 12:00:00"],
  [344,4267, "Battery Voltage volts Jepson Min", "2013-04-30 09:50:00"]
]

// Load Voltage JSON
jsonText = '{"name": "Battery Voltage volts Quail Ridge Min","station_id": "MONGOID",'+
  '"description": "TBD","tags": ["ds_Aggregate_Minimum","ds_Medium_Battery","ds_Variable_Voltage","dt_Unit_Volt"],'+
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
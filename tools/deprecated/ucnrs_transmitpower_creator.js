/* 
* @author=collin bode
* @date=2018-02-07
*/

console.log("\n UCNRS Transmission Creator \n")
fs = require("fs")
path = "../data/migration2.1-rivendell/datastream/"

station_text = fs.readFileSync("stations.js")
stations = JSON.parse(station_text)
console.log('number of stations:',stations.list.length)

function get_station_id(stations,station_id) {
  for(var i=0;i<stations.list.length;i++) {
    station = stations.list[i]
    if(station.station_id == station_id) {
      //console.log("FOUND! ",station.name, station.station_id,station._id)
      return station._id
    }
  }
}

//teststation = get_station_id(stations,335)
//console.log("testation:",teststation)

// List of Station ID, Datastream ID, Name, FieldName, StartDate
power_list = [
  [356,3148,"TX REFLECTED POWER SNARL,Reflected Power","2012-07-11 12:00:00","Reflected Power"],
  [336,3405,"TX REFLECTED POWER Bodega,Reflected Power","2012-06-27 14:50:00","Reflected Power"],
  [338,3482,"TX REFLECTED POWER Burns,Reflected Power","2010-09-30 11:00:00","Reflected Power"],
  [339,3506,"TX REFLECTED POWER Chickering,Reflected Power","2013-08-21 11:10:00","Reflected Power"],
  [344,3620,"TX REFLECTED POWER Jepson,Reflected Power","2014-01-01 12:00:00","Reflected Power"],
  [358,4037,"TX REFLECTED POWER Stunt Ranch,Reflected Power","2012-06-22 12:30:00","Reflected Power"],
  [359,4061,"TX REFLECTED POWER Granites,Reflected Power","2010-09-30 17:50:00","Reflected Power"],
  [345,4284,"TX REFLECTED POWER Rancho Marino,Reflected Power","2011-02-01 13:40:00","Reflected Power"],
  [356,3147,"TX FORWARD POWER SNARL,Forward Power","2012-07-11 12:00:00","Forward Power"],
  [336,3404,"TX FORWARD POWER Bodega,Forward Power","2012-06-27 14:50:00","Forward Power"],
  [338,3481,"TX FORWARD POWER Burns,Forward Power","2010-09-30 11:00:00","Forward Power"],
  [339,3505,"TX FORWARD POWER Chickering,Forward Power","2013-08-21 11:10:00","Forward Power"],
  [344,3619,"TX FORWARD POWER Jepson,Forward Power","2014-01-01 12:00:00","Forward Power"],
  [358,4036,"TX FORWARD POWER Stunt Ranch,Forward Power","2012-06-22 12:30:00","Forward Power"],
  [359,4060,"TX FORWARD POWER Granites,Forward Power","2010-09-30 17:50:00","Forward Power"],
  [345,4283,"TX FORWARD POWER Rancho Marino,Forward Power","2011-02-01 13:40:00","Forward Power"]
]

// Load Voltage JSON
jsonText = '{"name": "DUMMY DATASTREAM","station_id": "MONGOID",'+
  '"description": "TBD","tags": ['+
  '"ds_Medium_Instrument","ds_Variable_RadioTransmission","dt_Unit_DecibelMilliwatt"],'+
  '"external_refs": [{"identifier": "-9999","type": "odm.datastreams.datastreamid"},'+
  '{"identifier": "-99", "type": "odm.stations.stationid"}],'+
  '"datapoints_config": [{"params": {"query": {"datastream_id": -9999,"compact": true,"time_adjust": -28800}},'+
  '"begins_at": "2013-04-30T13:40:00Z","path": "/legacy/datavalues-ucnrs"}],'+
  '"source_type": "sensor","state": "ready","enabled": true}'
jsonVolt = JSON.parse(jsonText)
console.log('Name:',jsonVolt.name)

for (var i=0;i<power_list.length;i++) {
  sid = power_list[i][0].toString()
  dsid = power_list[i][1]
  dsname = power_list[i][2]
  start_date = power_list[i][3]
  transmission_type = power_list[4]
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
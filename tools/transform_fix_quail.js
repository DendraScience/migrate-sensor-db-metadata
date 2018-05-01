/*
	Quail Ridge Datastreams were hand crafted. Need modification
	"_id": "5a37e71ba546db0001547681",
  "name": "Quail Ridge",
  "station_id" : "352",
  "loggernet":"ucqr_quailridge",
  "table_type":"Core8_TenMin"

  current:
   "db": "station_quail_ridge"
   "fc": "ten_minute_data"
   "sc": "\"time\", \"TC_C_2_Min\""
*/

fs = require("fs")
tr = require("./transform_functions.js")
ds_path = "../data/dendra-managed/ucnrs/datastream/" 
ds_files = fs.readdirSync(ds_path)

// Get fieldname lists
function match_influx_fieldname(sc_field) {
	quail_fields = ["time","AT_C_Avg","AT_C_Max","AT_C_Min","BP_mB_Avg","BP_mb_Avg","Batt_volt_Avg","Batt_volt_Max","Batt_volt_Min","CS616_2_Avg","CS616_50_Avg","CS616_V_Avg","Day_of_Year","ForwardTxX10","Hour","HourMin","LWMCon_Tot","LWMDry_Tot","LWMWet_Tot","LWmV_Avg","Leaf_Wet_MCon_Tot","Leaf_Wet_MDry_Tot","Leaf_Wet_MWet_Tot","Leaf_Wet_mV_Avg","PAR_Avg","PAR_Max","PAR_Min","PCPN_accumulated","PCPN_in_Tot","PCPN_intrvl_Tot","PCPN_tot","PTemp_Avg","RGTemp_C_Avg","RH_pct_Avg","RH_pct_Max","RH_pct_Min","RS_kw_m2_Avg","RS_kw_m2_Max","RS_kw_m2_Min","RS_kw_m2_Std","ReflectTxX10","Soil_T100_C_Avg","Soil_T100_C_Max","Soil_T100_C_Min","Soil_T200_C_Avg","Soil_T200_C_Max","Soil_T200_C_Min","Soil_T20_C_Avg","Soil_T20_C_Max","Soil_T20_C_Min","Soil_T2_C_Avg","Soil_T2_C_Max","Soil_T2_C_Min","Soil_T4_C_Avg","Soil_T4_C_Max","Soil_T4_C_Min","Soil_T500_C_Avg","Soil_T500_C_Max","Soil_T500_C_Min","Soil_T50_C_Avg","Soil_T50_C_Max","Soil_T50_C_Min","Soil_T8_C_Avg","Soil_T8_C_Max","Soil_T8_C_Min","Sta_ID","TC_C_2_Avg","TC_C_2_Max","TC_C_2_Min","VWC2_Avg","VWC50_Avg","VWC_V_Avg","WS_mph_Max","WS_mph_Min","WS_mph_Std","WS_mph_WVc_1_","WS_mph_WVc_2_","WS_mph_WVc_3_","WS_mph_WVc_4_","WS_ms_Max","WS_ms_Min","WS_ms_Std","batt_volt_Avg","batt_volt_Max","batt_volt_Min","mean_vector_wind_dir","mean_wind_vector_mag","mean_wind_vel","sd_wind_dir"]
	for(var j=0;j<quail_fields.length;j++) {
		qfield = quail_fields[j]
		//console.log("\t",sc_field,"<-->",qfield)
		if(qfield == sc_field) {
			//console.log("MATCH!",sc_field,"==",qfield)
			return qfield
		} 
	}
}

function get_alternate_fieldname(sc_field) {
	dri2c8 = JSON.parse(fs.readFileSync("./DRI_to_Core8.json"))
	for(var j=0;j<dri2c8.length;j++) {
		c8_TenMin = dri2c8[j].TenMin
		c8_Core8 = dri2c8[j].Core8_TenMin
		//console.log("\t",sc_field,"<-->",c8_TenMin)
		if(c8_TenMin == sc_field) {
			//console.log("MATCH!",sc_field,"==",c8_TenMin)
			return c8_Core8
		} 
		/*
		if(c8_Core8 == sc_field) {
			console.log("Core8 found!?",sc_field,"==",c8_Core8)
			return c8_TenMin
		} 
		*/
	}
}

// Test get_alternate_fieldname
//sf = "Soil_T8_C_Avg"
//c8 = get_alternate_fieldname(sf)
//console.log(sf,"-->",c8)


// Loop through Datastream JSON files 
for(var i=0;i<ds_files.length;i++) {
	ds_filename = ds_files[i]
	if (ds_filename.match(/.json$/) && ds_filename.match(/Quail/)) {
		ds_json = JSON.parse(fs.readFileSync(ds_path+ds_filename))
		// Pull existing values
		dpc = ds_json.datapoints_config[0]
		db = dpc.params.query.db
		fc = dpc.params.query.fc
		sc = dpc.params.query.sc
		//console.log(ds_json.name,", db:",db,", fc:",fc,", sc:",sc) 

		// Assign desired values
		ndb = "station_ucqr_quailridge"
		nfc = "source_tenmin"
		ds_json.datapoints_config[0].params.query.db = ndb
		ds_json.datapoints_config[0].params.query.fc = nfc
		ds_json.datapoints_config[0].params.query.api = "ucnrs"
		ds_json.datapoints_config[0].params.query.coalesce = false

		field1 = sc.split(",")[1].replace("\"","").replace("\"","").replace(" ","")
		field2 = match_influx_fieldname(field1)
		if(typeof field2 !== 'undefined') {
			field3 = get_alternate_fieldname(field2)
			//console.log(field1,field2,field3)
			if(field1 != field3 && typeof field3 !== 'undefined') {
				nsc = "\"time\", \""+field1+"\", \""+field3+"\""
				ds_json.datapoints_config[0].params.query.sc = nsc
				ds_json.datapoints_config[0].params.query.coalesce = true		
				console.log(nsc)
			}	else {
				ds_json.datapoints_config[0].params.query.coalesce = false				
			}
		} else {
			console.log("NO!",ds_filename,"<--",field1)
		}
		//console.log(ds_json.name,", db:",ndb,", fc:",nfc) //,", sc:",nsc) 
		//console.log(ds_json.name,", db:",db,", fc:",fc,", sc:",sc)		
		// Write to file
		ds_json_string = JSON.stringify(ds_json,null,2)
		//console.log("\tProcessed! InfluxDB config_points created. Writing file:",ds_filename,ds_json_string)
		fs.writeFileSync(ds_path+ds_filename,ds_json_string,'utf-8')
	} else {
		//console.log("NOT QUAIL!!!",ds_filename)
	}
} 

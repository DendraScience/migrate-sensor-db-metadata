-- SQL Export of Methods to Thing Types
-- Collin Bode
-- 2019-03-11
-- 

mysql> desc methods;
+-------------------+---------------------+------+-----+---------+----------------+
| Field             | Type                | Null | Key | Default | Extra          |
+-------------------+---------------------+------+-----+---------+----------------+
| MethodID          | bigint(20) unsigned | NO   | PRI | NULL    | auto_increment |
| MethodName        | varchar(255)        | NO   | UNI | NULL    |                |
| MethodDescription | text                | YES  |     | NULL    |                |
| MethodLink        | text                | YES  |     | NULL    |                |
mysql> desc datastreams;
| VariableCode        | varchar(50)          | NO   | MUL | NULL    |                |
| VariableID          | smallint(5) unsigned | NO   | MUL | NULL    |                |
| MethodName          | varchar(255)         | NO   | MUL | NULL    |                |
| MethodID            | smallint(5) unsigned | NO   | MUL | NULL    |                |
| DeviceName          | varchar(255)         | YES  |     | NULL    |                |

| RangeMin            | decimal(8,2)         | YES  |     | NULL    |                |
| RangeMax            | decimal(8,2)         | YES  |     | NULL    |                |
+---------------------+----------------------+------+-----+---------+----------------+
24 rows in set (0.00 sec)

-- SQL TEMPLATE
SELECT 
FROM
WHERE
AND
ORDER BY

-- UCNRS cleaning required. Air Temp and Rain gage temp were both listed as wind speed

-- Change method from Wind sensor back to HMP50 temp/rh
SELECT datastreamid, datastreamname, variablecode, variableid, devicename, rangemin, rangemax 
FROM datastreams WHERE methodid = 18 AND variablecode LIKE "Air Temp C%" ORDER BY datastreamid;
38 rows in set (0.00 sec)

UPDATE datastreams SET methodid = 79 WHERE methodid = 18 AND variablecode LIKE 
"Air Temp C%";
Query OK, 38 rows affected (0.00 sec)
Rows matched: 38  Changed: 38  Warnings: 0

-- Change method from Wind Sensor back to Rain Gage
SELECT datastreamid, datastreamname, variablecode, variableid, devicename, rangemin, rangemax 
FROM datastreams WHERE methodid = 18 AND variablecode LIKE "Rain Gauge Temp C" ORDER BY datastreamid;
19 rows in set (0.00 sec)

SELECT datastreamid, datastreamname, variablecode, variableid, devicename, rangemin, rangemax, methodid, methodname FROM datastreams WHERE datastreamid = 3350;

| datastreamid | datastreamname           | variablecode | variableid | devicename | rangemin | rangemax | methodid | methodname      |
+--------------+--------------------------+--------------+------------+------------+----------+----------+----------+-----------------+
|         3350 | Precipitation mm Angelo  | Rainfall mm  |         35 | NULL       |     0.00 |   500.00 |       83 | TB4-L Rain Gage |

UPDATE datastreams SET methodid = 83 WHERE methodid = 18 AND variablecode LIKE "Rain Gauge Temp C";
Query OK, 19 rows affected (0.00 sec)
Rows matched: 19  Changed: 19  Warnings: 0


-- NOT ALL METHODS HAVE DATASTREAMS
94 rows in methods
72 Methods with datastreams
22 Methods unused
246 Method - VariableCode combinations


-- DEVICE VALID RANGE MIN/MAX IS DIFFERENT FOR MANY DATASTREAMS FOR THE SAME METHOD
-- DEVICES HAVE MULTIPLE VARIABLECODES
--> ADDED TO SQL/CREATE_VIEW/VW_EXPORT_METHODS.SQL
CREATE OR REPLACE VIEW vw_export_method AS   
SELECT  
	m.methodid,  m.methodname, d.variablecode,  
	count(*) as datastream_count, 
	min(d.RangeMin) as RangeMin_min,  max(d.RangeMin) as RangeMin_max,   
	min(d.RangeMax) as RangeMax_min,  max(d.RangeMax) as RangeMax_max, 
	(max(d.RangeMin) - min(d.RangeMin)) as RangeMin_diff, 
	(max(d.RangeMax) - min(d.RangeMax)) as RangeMax_diff  
FROM methods as m, datastreams as d  
WHERE m.methodid = d.methodid  
GROUP BY m.methodid, d.variablecode   
ORDER BY m.methodid, d.variablecode;


RangeMin_diff = 0 and RangeMax_diff = 0; -- 27, 172 
RangeMin_diff = 0; -- 42, 204 
RangeMax_diff = 0; -- 31, 178 
rangemin_diff IS NULL: 32
rangemax_diff IS NULL: 49 

SELECT m.methodid,m.methodname, r.rangemin_diff, r.rangemax_diff  
FROM methods as m LEFT OUTER JOIN method_ranged as r ON m.methodid = r.methodid   
WHERE r.rangemin_diff is NULL;
+----------+-------------------------------------------+---------------+---------------+
| methodid | methodname                                | rangemin_diff | rangemax_diff |
+----------+-------------------------------------------+---------------+---------------+
|       24 | Logger Record Count                       |          NULL |          NULL |
|       29 | SM200 Soil Moisture Sensor                |          NULL |          NULL |
|       38 | OWL_Logger                                |          NULL |          NULL |
|       39 | Float n Chain gage                        |          NULL |          NULL |
|       44 | Campbell-Scientific AM 16/32A             |          NULL |          NULL |
|       45 | Campbell-Scientific CS500 Probe           |          NULL |          NULL |
|       48 | R.M. Young Wind Sentry 03001-L            |          NULL |          NULL |
|       51 | ICT International SL5 Smart Logger        |          NULL |          NULL |
|       54 | Derived Evapotranspiration                |          NULL |          NULL |
|       66 | Kavlico Pressure Transducer               |          NULL |          NULL |
|       64 | Convert mV to meters for wells            |          NULL |          0.00 |
|       74 | ISCO 6712 Full-Size Portable Sampler      |          NULL |          NULL |
|       75 | Thermo Scientific Element 2 ICP-MS        |          NULL |          NULL |
|       76 | CO2 Meter K-33 ICB 30 pct CO2 Sensor      |          NULL |          NULL |
|       84 | TCAV-L Soil Temperature Thermocouple      |          NULL |          NULL |
|       88 | CPN 503DR Hydroprobe                      |          NULL |          NULL |
|       89 | Convert  ICT International HRM Sap Sensor |          NULL |          NULL |
|       90 | eN2100 eKo Node                           |          NULL |          NULL |
|       95 | eS1100 Soil Moisture Sensor               |          NULL |          NULL |
|      104 | Decagon Leaf Wetness Sensor eKo Mote      |          NULL |          NULL |
|      110 | RM Young Wind Monitor 05106-L             |          NULL |          NULL |
|      111 | Echo Volumetric Water Content Sensor      |          NULL |          NULL |
|      112 | WindSonic 2D                              |          NULL |          NULL |
|      113 | CM3 Pyranometer                           |          NULL |          NULL |
|      115 | Campbell Scientific CS215                 |          NULL |          NULL |
|      116 | Unihedron SQM-LR                          |          NULL |          NULL |
+----------+-------------------------------------------+---------------+---------------+
26 rows in set (0.00 sec)



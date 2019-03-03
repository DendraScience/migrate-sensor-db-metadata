Incident Investigation

select count(*) from incidents;  542

desc incidents;
+------------------+---------------------+------+-----+---------+----------------+
| Field            | Type                | Null | Key | Default | Extra          |
+------------------+---------------------+------+-----+---------+----------------+
| IncidentID       | bigint(20) unsigned | NO   | PRI | NULL    | auto_increment |
| StartTime        | datetime            | YES  |     | NULL    |                |
| StartPrecision   | varchar(50)         | YES  |     | NULL    |                |
| EndTime          | datetime            | YES  |     | NULL    |                |
| EndPrecision     | varchar(50)         | YES  |     | NULL    |                |
| StationNames     | varchar(255)        | NO   |     | NULL    |                |
| Datastream_Names | text                | YES  |     | NULL    |                |
| Title            | char(50)            | NO   |     | NULL    |                |
| Description      | text                | YES  |     | NULL    |                |
| Reported_By      | varchar(96)         | NO   |     | NULL    |                |
| Date_Reported    | datetime            | NO   |     | NULL    |                |
| Comments         | text                | YES  |     | NULL    |                |
+------------------+---------------------+------+-----+---------+----------------+
12 rows in set (0.00 sec)
ALTER TABLE incidents ADD column MC_Name varchar(50);


select comments, count(*) from incidents group by comments;
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------+
| comments                                                                                                                                                                                                                                                                        | count(*) |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------+
| NULL                                                                                                                                                                                                                                                                            |       37 |
|                                                                                                                                                                                                                                                                                 |      379 |
| Flagged 1091 records for Sap Station3 between Start and End dates                                                                                                                                                                                                               |        1 |
| no flags - no data in the database yet                                                                                                                                                                                                                                          |        1 |
| value for this timestamp was flagged                                                                                                                                                                                                                                            |      103 |
| [1/11/2010 Ginger] Flagged 12,133 datavalues where station is WSAM or WSHQ and LocalDateTime > '2010-01-05 13:20' and LocalDateTime <= '2010-01-08 14:30'                                                                                                                       |        1 |
| [1/11/2010 Ginger] Flagged 2,845 datavalues where station is Angelo Meadow (WSAM) and datastreamid=4 (Rainfall) and LocalDateTime >= '2009-11-12' and LocalDateTime <= '2009-12-11 12:00'                                                                                       |        1 |
| [1/11/2010 Ginger] Flagged 24 datavalues for these two stations where VariableCode like "Total Solar Radiation%" and (LocalDateTime > '2010-01-05 12:20' and LocalDateTime < '2010-01-05 13:00').                                                                               |        1 |
| [1/11/2010 Ginger] Flagged 38,558 datavalues where station is Cahto Peak and LocalDateTime > '2009-12-08 16:45' and LocalDateTime < '2010-01-08 14:30:00'                                                                                                                       |        1 |
| [1/25/2010 Ginger] Flagged 48 datavalues where (LocalDateTime >= '2009-09-11 08:00:51' and LocalDateTime <= '2009-09-11 16:00:51') and (DatastreamID=376 or DatastreamID=378 or DatastreamID=388)                                                                               |        1 |
| [12/1/09 Ginger] Flagged 66 values.  SQL: update datavalues set QualifierCode = concat(QualifierCode," IR_4") where stationname="Cahto Peak WS" and LocalDateTime >= '2009-11-12 12:30:00' and LocalDateTime <= '2009-11-12 15:00:00'                                           |        1 |
| [12/1/09 Ginger] Flagged the following values between 2009-08-24 00:00:00 and 2009-10-26 00:00:00: **ERPs** (all Rivendell stations): Flagged 290304 values. **Well 6** : Flagged 3024 values **Well 7** : Flagged 3024 values                                                  |        1 |
| [12/4/09 Ginger] Flagged 102,388 values.  SQL: update datavalues set QualifierCode = concat(QualifierCode," IR_3") where (datastreamid=2 or datastreamid=3) and LocalDateTime < '2009-10-25 12:45:00'                                                                           |        1 |
| [12/4/09 Ginger] Flagged the timestamps on either side of the gap (22 values).  SQL: update datavalues set QualifierCode = concat(QualifierCode," IR_5") where stationname="Cahto Peak WS" and (LocalDateTime = '2009-11-12 14:45:00' or LocalDateTime = '2009-11-13 09:15:00') |        1 |
| [2010-03-30 Ginger] Flagged 1,078 values between Start and End times for Sap Station3                                                                                                                                                                                           |        1 |
| [2010-03-30 Ginger] Flagged 988 values between Start and End times for Sap Station3                                                                                                                                                                                             |        1 |
| [2010-03-31 Ginger] Flagged values between Start and End times for Sap Station3: 56 records (orig flag=NV) + 1400 records (orig flag=P)                                                                                                                                         |        1 |
| [2010-04-05 Ginger] Flagged 1,140 values between Start and End times for Sap Station2                                                                                                                                                                                           |        1 |
| [2010-04-05 Ginger] Flagged 1,292 values between Start and End times for Sap Station2                                                                                                                                                                                           |        1 |
| [2010-04-05 Ginger] Flagged 828 values between Start and End times for Sap Station2                                                                                                                                                                                             |        1 |
| [2010-04-05 Ginger] Flagged values between Start and End times for Sap Station2: 12 records (orig flag=NV) + 378 records (orig flag=P)                                                                                                                                          |        1 |
| [2010-04-05 Ginger] Flagged values between Start and End times for Sap Station2: 4 records (orig flag=NV) + 1338 records (orig flag=P)                                                                                                                                          |        1 |
| [2010-04-06 Ginger] Flagged 1,365 values between Start and End times for Sap Station2                                                                                                                                                                                           |        1 |
| [2010-04-30 Ginger] Flagged 293,337 values for Sagehen1 where method=Stevens Hydra Probe                                                                                                                                                                                        |        1 |
| [2010-04-30 Ginger] Flagged 302,760 values for Sagehen7 where method=Stevens Hydra Probe                                                                                                                                                                                        |        1 |
| [2010-09-24 Ginger] Flagged Rainfall mm for the two gauges at Rivendell Level 2_2 2010-09-18 19:20 thru 2010-09-19 19:20 (96 values).  Flagged Rainfall mm for  Riv Level 1_2 for 2010-09-23 16:00 (1 value) since this measurement is probably due to cleaning out the gauges. |        1 |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------+
26 rows in set (0.01 sec)



-- QUALIFIERS TABLE: where data is flagged as bad.  436 records.
-- Clean up Qualifiers table and remove the relevant components (valid,flag)
-- See Below for why / which redundant qualifiers are excluded.  
CREATE OR REPLACE VIEW vw_export_qualifiers AS 
SELECT 
	QualifierID as qid,
	CAST(mid(QualifierCode,locate('_',QualifierCode)+1,4) AS UNSIGNED) AS IncidentID,
	LEFT(QualifierCode,locate(' ',QualifierCode)) AS flag,
	IncludeInGrid as valid,
	QualifierCode,
	QualifierDescription     
FROM qualifiers
WHERE 
	mid(QualifierCode,locate('_',QualifierCode)+1,4) REGEXP '^[0-9]+$' AND
	QualifierID != 12 AND QualifierID != 15 AND QualifierID != 17 AND QualifierID != 24 AND QualifierID != 25 AND 
	QualifierID != 27 AND QualifierID != 28 AND QualifierID != 73 AND QualifierID != 74 AND QualifierID != 76 AND QualifierID != 77  
ORDER BY qid;


-- PROBLEM: there are redundant flags for incident reports. supposed to be one to one.
select * from qualifiers_strip where IncidentID = 1 or IncidentID = 4 or IncidentID = 6 or IncidentID = 7 or IncidentID = 14 or IncidentID = 53 or IncidentID = 54 or IncidentID = 272 or IncidentID = 525 or IncidentID = 541 order by incidentid;

SELECT IncidentID,StartTime,Title,StationNames,Datastream_Names FROM incidents WHERE 
IncidentID = 1 or IncidentID = 4 or IncidentID = 6 or IncidentID = 7 or IncidentID = 14 or IncidentID = 53 or IncidentID = 54 or IncidentID = 272 or IncidentID = 525 or IncidentID = 541 order by incidentid;

-- Look at redundant qualifiers
SELECT q.*,i.title 
FROM qualifiers_strip as q, incidents as i 
WHERE 
	q.IncidentID = i.IncidentID and 
	(q.IncidentID = 1 or q.IncidentID = 4 or q.IncidentID = 6 or q.IncidentID = 7 or 
	q.IncidentID = 14 or q.IncidentID = 53 or q.IncidentID = 54 or 
	q.IncidentID = 272 or q.IncidentID = 525 or q.IncidentID = 541)  
ORDER BY q.IncidentID, q.qid;

+-----+------------+------+-------+---------------------------------------------------------------------+-------------------------------------------+
| qid | IncidentID | flag | valid | Description                                                         | title                                     |
+-----+------------+------+-------+---------------------------------------------------------------------+-------------------------------------------+
| x 12 |          1 | P    |     1 | Passed sanity check; see incident report IR_1                       | Bear damage                               |
|  22 |          1 | U    |     1 | Unchecked value; see incident report IR_1                           | Bear damage                               |

| x 15 |          4 | P    |     0 | Passed sanity check; see incident report IR_4                       | Station Logger Code Rewrite               |
|  23 |          4 | VB   |     0 | Value below range; see incident report IR_4                         | Station Logger Code Rewrite               |

| x 17 |          6 | P    |     0 | Passed sanity check; see incident report IR_6                       | Logger re-code - units change + new value |
| x 24 |          6 | VB   |     0 | Value below range; see incident report IR_6                         | Logger re-code - units change + new value |
|  26 |          6 | VE   |     0 | Value exceeds range; see incident report IR_6                       | Logger re-code - units change + new value |

|  18 |          7 | P    |     0 | Passed sanity check; see incident report IR_7                       | Changed delay time on logger              |
| x 25 |          7 | VB   |     0 | Value below range; see incident report IR_7                         | Changed delay time on logger              |
| x 27 |          7 | VE   |     0 | Value exceeds range; see incident report IR_7                       | Changed delay time on logger              |

| x 28 |         14 | P    |     0 | Passed sanity check; see incident report IR_14                      | Water Damage to Multiplexer               |
|  29 |         14 | U    |     0 | Unchecked value; see incident report IR_14                          | Water Damage to Multiplexer               |

| x 73 |         53 | P    |     0 | Passed sanity check; see incident report IR_53                      | Power Outage                              |
| x 74 |         53 | U    |     0 | Unchecked value; see incident report IR_53                          | Power Outage                              |
|  75 |         53 | VB   |     0 | Value below range; see incident report IR_53                        | Power Outage                              |

| x 76 |         54 | U    |     0 | Unchecked value; see incident report IR_54                          | Power Outage                              |
| x 77 |         54 | P    |     0 | Passed sanity check; see incident report IR_54                      | Power Outage                              |
|  78 |         54 | VB   |     0 | Value below range; see incident report IR_54                        | Power Outage                              |

| 223 |       !295! | P    |     1 | Power loss at night only for 2 weeks; see incident report IR_295    | Well Water Sampling                       |
| 224 |        272 | X    |     0 | Well Water Sampling; see incident report IR_272                     | Well Water Sampling                       |
| 463 |        525 | P    |     1 | Soil temperature thermocouples replaced; see incident report IR_525 | Replaced HMP60 and LI200X                 |
| 464 |        525 | P    |     1 | Replaced HMP60 and LI200X; see incident report IR_525               | Replaced HMP60 and LI200X                 |
| 479 |        552!541! | X    |     0 | Soil Temp at 2 and 8 inches switched; see incident report IR_552    | SCI station audit and sensor swap         |
| 480 |        541 | X    |     0 | SCI station audit and sensor swap; see incident report IR_541       | SCI station audit and sensor swap         |
+-----+------------+------+-------+---------------------------------------------------------------------+-------------------------------------------+
24 rows in set, 72 warnings (0.01 sec)

-- QUALIFIER TABLE REDUNDANCY: ignore certain ID's. 
QualfierID: 12,15,17,24,25,27,28,73,74,76,77,

-- 
-- Join Qualifiers to Incidents 
CREATE OR REPLACE VIEW vw_export_incident AS 
	SELECT i.IncidentID,
		timestampadd(HOUR,8,i.StartTime) as StartTime,
		i.StartPrecision,
		timestampadd(HOUR,8,i.EndTime) as EndTime,
		i.EndPrecision,
		i.StationNames, 
		i.Datastream_Names,
		i.Title, 
		i.Description,
		i.Reported_By, 
		i.Date_Reported,
		i.Comments,
		i.StationIDs,
		i.DatastreamIDs,
		i.MC_Name,
		q.qid,q.flag,
		q.valid,
		q.QualifierCode,
		q.QualifierDescription 
	FROM incidents as i LEFT JOIN vw_export_qualifiers as q 
	ON i.IncidentID = q.IncidentID;

CREATE OR REPLACE VIEW vw_export_incident_erczo AS 
	SELECT * FROM vw_export_incident WHERE MC_Name = 'Angelo Reserve';
CREATE OR REPLACE VIEW vw_export_incident_ucnrs AS 
	SELECT * FROM vw_export_incident WHERE MC_Name = 'UCNRS';


-- Finding StationIDs
-- python code: dendra_dev/annotations/incident_stationname2id.py
-- Fix problem fields
UPDATE incidents SET stationnames = 'Riv Level 5_1' WHERE incidentid = 49;
UPDATE incidents SET stationnames = 'Angelo,Anza Borrego,BigCreek Gatehouse,BigCreek Highlands,BigCreek Whale,Blue Oak Ranch,Bodega,Burns,Chickering,Dawson,Deep Canyon,Elliott,Fort Ord,Granites,Hastings,James,Jepson,McLaughlin,Motte,Quail Ridge,Rancho Marino,Sagehen Creek' WHERE incidentid = 550;

-- Need two new columns to incidents to add the ID arrays
-- MySQL doesn't like arrays, so these will be text
ALTER TABLE `incidents` ADD COLUMN `StationIDs` varchar(255);
ALTER TABLE `incidents` ADD COLUMN `DatastreamIDs` varchar(255);

-- Script inserts ids into new StationIDs column 
sql = "UPDATE `incidents` SET `StationIDs` = %s WHERE IncidentID = %s";

-- Datastreams are a lot more complicated. 
-- python code: dendra_dev/annotations/incident_datastreamname2id.py
-- Some have DatastreamIDs, use them
-- Some have Datastream Names exact match
-- Some are All Well datastreams: require identifying Well ID
-- "ALL" & "NONE"
-- All remaining will probably have to be done by hand

-- Well Datastreams
SELECT 
	CAST(mid(DatastreamName,locate(' ',DatastreamName)+1,4) AS UNSIGNED) AS WellNum, 
	DatastreamID    
FROM datastreams 
WHERE 
	DatastreamName like "%well%" AND 
	DatastreamName not like "%Manual%" AND
	DatastreamName not like "CO2%"
ORDER BY WellNum; 

SELECT CAST(mid(DatastreamName,locate(' ',DatastreamName)+1,4) AS UNSIGNED) AS WellNum, DatastreamID FROM datastreams WHERE DatastreamName like "%well%" AND DatastreamName not like "%Manual%" AND DatastreamName not like "CO2%" ORDER BY WellNum;

-- ORPHANED INCIDENTS
-- id 2: GageHeight inside HQ, OWL. <-- OWL logger data was never entered into the sensor database.  Not actually relevant. 
-- can I flag this as enabled: false?
-- id 96: 	Rainwater collector at W7 needs replacement
-- not an automated instrument (plastic water collector). Not sure how to deal with this.

-- Fix Misbehaving Incident fields
UPDATE incidents SET Datastream_Names = '' WHERE IncidentID = 

-- id 1: the original "Bear Damage".  resistance probes, wells, and rain collector
UPDATE incidents SET Datastream_Names = 'Well 6, Well 7, ERP, 389, 390, 391, 392' WHERE IncidentID = 1;

-- id 6: changed units on solar Angelo HQ WS   Angelo Meadow WS  
UPDATE incidents SET Datastream_Names = '53,54,55,56,838,839,841,842,1623,1625,1626,1628,1629,1631,1632,1634' WHERE IncidentID = 6;

-- id 4: Datastream ID 4 Rainfall - WSAM
UPDATE incidents SET Datastream_Names = 'DSID 4' WHERE IncidentID = 9;

-- id 10:  Rainfall mm RG2 (id 390)
UPDATE incidents SET Datastream_Names = '390, 1617' WHERE IncidentID = 10;

-- id 11:  Rainfall mm RG3 (id 391)
UPDATE incidents SET Datastream_Names = '391, 1618' WHERE IncidentID = 11;

-- id 12:  Rainfall mm RG1 (id 389)
UPDATE incidents SET Datastream_Names = '389, 1616' WHERE IncidentID = 12;

-- id 13:  	Air Relative Humidity RLL1_2 (376),Air Relative Humidity RLL2_2 (378), Air Relative Humidity RLL3_2 (388)
UPDATE incidents SET Datastream_Names = '376, 378, 388' WHERE IncidentID = 13;

-- id 25 & 26: All datastreams where method = Stevens Hydra Probes (Sagehen, tower1, tower7)
SELECT DatastreamID, DatastreamName FROM datastreams WHERE DatastreamName like "%Soil%Probe%Sag%" AND StationName = "Sagehen1"; -- "Sagehen7";

-- id 27: 381-386
UPDATE incidents SET Datastream_Names = '381, 382, 383, 384, 385, 386' WHERE IncidentID = 27;

-- id 44: Water Level m. (1328) -- desctription: The transducer distance has not been verified for this well since the date given in "Start Time"; therefore, values after that date are subject to later modification and should be used with caution.
UPDATE incidents SET Datastream_Names = '1328, 1329, 1330, 1331, 1332, 1333, 1334' WHERE IncidentID = 44;

-- id 48: Water Level m -- desctription: This is preliminary data, which has not been published or reviewed for quality, external events, equipment problems etc., and therefore should not be used for research without consulting the person who acquired the data. 
UPDATE incidents SET Datastream_Names = '1328, 1329, 1330, 1331, 1332, 1333, 1334' WHERE IncidentID = 48;

-- id 51: Air Temperature (C) and Relative Humidity sensor
UPDATE incidents SET Datastream_Names = '376, 1638, 375, 1599' WHERE IncidentID = 51; 

-- id 68: Well 3, IsCo pump station (pressuremV=381, waterlevelm=1330)
UPDATE incidents SET Datastream_Names = '381, 1330' WHERE IncidentID = 68;

-- id 70: Level 5 power outage | L5_1 datalogger, Well 15 Pressure PSI (1469), Well 16 Pressure PSI (1471), Well 15 Water Level m (1478), Well 16 Water Level m (1479), Air Temp C (1468), Water Temp C (1472), Battery Voltage (1467)
UPDATE incidents SET Datastream_Names = 'all datastreams' WHERE IncidentID = 70;

-- id 72: Wells 5, 6, 7, 12, 16.
UPDATE incidents SET Datastream_Names = 'Well 5, Well 6, Well 7, Well 12, Well 16' WHERE IncidentID = 72;

-- id 74: all datastreams: 1456-1466, 1598, 1610, 1614, 1643, 1648, 1653
UPDATE incidents SET Datastream_Names = 'all datastreams' WHERE IncidentID = 74;

-- id 75: Angelo HQ WS rain gauge (41,1622)
UPDATE incidents SET Datastream_Names = '41, 1622, 1781' WHERE IncidentID = 75;

-- id 82: Well 16 (1471,1472,1479)
UPDATE incidents SET Datastream_Names = '1471, 1472, 1479, 1669' WHERE IncidentID = 82;

-- id 87: Pressure sensor data in well 3 (381 = pressure mV, 1330 = water level)
UPDATE incidents SET Datastream_Names = 'Well 3' WHERE IncidentID = 87;

-- id 88: River_ht (DS id 380)
UPDATE incidents SET Datastream_Names = '380, 1680' WHERE IncidentID = 88;

-- id 97: rain gauge precipitation
UPDATE incidents SET Datastream_Names = '389, 390, 391, 392, 1616, 1617, 1618, 1619' WHERE IncidentID = 97;

-- id 98: S Series TDR sensors on Level 2. Some other SM200 sensors on levels 1 and 2 were also affected.
UPDATE incidents SET StationNames = 'Riv Level 2_2' WHERE IncidentID = 98;
UPDATE incidents SET StationIDs = '7' WHERE IncidentID = 98;
UPDATE incidents SET Datastream_Names = '404,405,406,407,408,409,410,411,412,413,414' WHERE IncidentID = 98;

-- id 99: 'pressure transducers in wells 1, 12, 2, 13, 14'
UPDATE incidents SET Datastream_Names = 'all Well 1, Well 12, Well 2, Well 13, Well 14' WHERE IncidentID = 99;
UPDATE incidents SET Datastream_Names = 'all Well 7 datastreams' WHERE IncidentID = 108;
UPDATE incidents SET Datastream_Names = 'all datastreams' WHERE IncidentID = 105;
UPDATE incidents SET Datastream_Names = 'all Well 15 datastreams' WHERE IncidentID = 111;
UPDATE incidents SET Datastream_Names = 'all Well 5 datastreams, all Well 6 datastreams, all Well 7 datastreams,' WHERE IncidentID = 115;
UPDATE incidents SET Datastream_Names = 'all Well 5 datastreams, all Well 6 datastreams, all Well 7 datastreams,' WHERE IncidentID = 117;

-- id 104: Rain gauges
UPDATE incidents SET Datastream_Names = '390,391,392,1617,1618,1619' WHERE IncidentID = 104;

-- id 112: Well 15 Pressure psi, Well 15 Water Level m,Well 15 Water Level m 30min,Well 15 Water Temp C, WLevel m, Well 16 Water Level m 30min,Well 16 Water Temp C 
UPDATE incidents SET Datastream_Names = 'Well 15, Well 16' WHERE IncidentID = 112;

-- id 113: The pressure transducer in well 15 was replaced. At 1600 the datalogger was unplugged, and it was powered back on at 1632.
UPDATE incidents SET Datastream_Names = 'Well 15' WHERE IncidentID = 113;

-- id 121: Pressure transducers in wells 12,2,13,14, 5, 6, 7, 15, 16
UPDATE incidents SET Datastream_Names = 'well 12, well 2, well 13, well 14, well 5, well 6, well 7, well 15, well 16' WHERE IncidentID = 121;

-- id 125: Rain gauge at level 1
UPDATE incidents SET Datastream_Names = '389,1616' WHERE IncidentID = 125;

-- id 126:  Pressure transducers in wells 6, 15, 16
UPDATE incidents SET Datastream_Names = 'Well 6, Well 15, Well 16' WHERE IncidentID = 126;

-- id 129: Removed the pressure transducer from Elder creek.
UPDATE incidents SET Datastream_Names = '380,1680' WHERE IncidentID = 129;

-- id 130: Pressure transducer removed while changes were made.
UPDATE incidents SET Datastream_Names = 'Well 14' WHERE IncidentID = 130;

-- id 131: Removed the transducer from the well. 
UPDATE incidents SET Datastream_Names = 'Well 16' WHERE IncidentID = 131;

-- id 135: Air Temp C Riv 2_3,Battery Voltage Riv2_3,Well 13 Pressure psi,Well 13 WaterTemp C,Well 13 WaterLevel m,Well 14 Pressure psi,Well 14 Water Level m,Well 14 Water Temp C 
UPDATE incidents SET Datastream_Names = 'all datastreams' WHERE IncidentID = 135;

-- id 161: Rainfall mm (datastreamID 41)
UPDATE incidents SET Datastream_Names = '41,1622,1781' WHERE IncidentID = 161;

-- id 164: Air Temp RLL1_2 \n Air Relative Humidity RLL1_2
UPDATE incidents SET Datastream_Names = '376,1638,375,1599' WHERE IncidentID = 164;

-- id 165: Air Relative humidity
UPDATE incidents SET Datastream_Names = '388,1640' WHERE IncidentID = 165;

-- id 190: BP Riv 2_2 [Riv Level 2_2]
UPDATE incidents SET Datastream_Names = '393, 1611' WHERE IncidentID = 190;

--  id 234: 'DSID:  2995,2996, 2997, 2998, 2999, 3000, 3001, 3002, 3003, 3004'
UPDATE incidents SET Datastream_Names = '2995, 2996, 2997, 2998, 2999, 3000, 3001, 3002, 3003, 3004' WHERE IncidentID = 234;

-- id 251: Sagehorn weather station data logger 
UPDATE incidents SET Datastream_Names = 'all datastreams' WHERE IncidentID = 251;

-- id 262 All rain gauges at these stations (rain gauge test)
UPDATE incidents SET Datastream_Names = '1728, 1729, 1776, 1777, 1778, 1779, 1785, 1786, 1787, 1788, 1789, 1790, 1791, 1792, 1793, 1794, 2959, 2952, 2953, 3048' WHERE IncidentID = 262;

-- id 263: The wind speed and direction. 
UPDATE incidents SET Datastream_Names = '2966,2964,2965' WHERE IncidentID = 263;

-- id 264: DSID 2959 Rainfall mm TB4 WSSR
--     	   DSID 3048 Rainfall Cumulative mm Sagehorn
UPDATE incidents SET Datastream_Names = 'DSID 2959 Rainfall mm TB4 WSSR, DSID 3048 Rainfall Cumulative mm Sagehorn' WHERE IncidentID = 264;

-- id 324: Entire station
UPDATE incidents SET Datastream_Names = 'all datastreams' WHERE IncidentID =324;

-- id 357:  'DSID 1787 Rainfall mm TB4 Level 2
--			DSID 1790 Rainfall Cumulative mm TB4 Level 2
--			DSID 1789 Rainfall mm TB4 Level 5
--			DSID 1792 Rainfall Cumulative mm TB4 Level 5'
UPDATE incidents SET Datastream_Names = '1787,1789,1790,1792' WHERE IncidentID = 357;

-- id 369: All GeoNor sensor datastreams
UPDATE incidents SET Datastream_Names = '3143, 3142, 3144, 3146' WHERE IncidentID = 369;

-- id 370: GeoNor sensor. Streams 3143, 3142, 3144, 3146
UPDATE incidents SET Datastream_Names = '3143, 3142, 3144, 3146' WHERE IncidentID = 370;

-- id 371: Barometric presssure sensor, DS3426
UPDATE incidents SET Datastream_Names = '3426' WHERE IncidentID = 371;

-- id 372: Temp/RH Sensor -- Sagehorn (WSSR)
UPDATE incidents SET Datastream_Names = '2956, 2957' WHERE IncidentID = 372;

-- id 424: GeoNor precipitation gauge  (SNARL)
UPDATE incidents SET Datastream_Names = '3142, 3143, 3144, 3146' WHERE IncidentID = 424;

-- id 425: Temp/RH \n Temp streams, min, max, av. \n RH streams, min, max, av.
UPDATE incidents SET Datastream_Names = '3521, 3522, 3523, 3524, 3525, 3526' WHERE IncidentID = 425;
UPDATE incidents SET EndTime = '2017-02-14 10:30:00' WHERE IncidentID = 425;
-- 425: HPM50 Temp/RH failed at 6pm Feb 6, new sensor will be installed in a few days.
-- 432: This report supeceeds Incident 425. Temp/RH sensor replaced at 10am Feb 14
UPDATE incidents SET Description = 'HPM50 Temp/RH failed at 6pm Feb 6 2017. Replaced at 10am Feb 14' WHERE IncidentID = 425;
UPDATE incidents SET Comments = 'value for this timestamp was flagged' WHERE IncidentID = 425;
DELETE FROM incidents WHERE IncidentID = 432;

-- id 426: Rain gauge - TB4-L, affecting Precipitation and Precipitation_Totaled
UPDATE incidents SET Datastream_Names = '3084,3083,3082' WHERE IncidentID = 426;

-- id 427: Rain gauge - TB4-L - Precipitation and \n Precipiation_Totaled
UPDATE incidents SET Datastream_Names = '4244, 4245' WHERE IncidentID = 427;

-- id 428: Rain gauge - TB4-L, Precipitation and Precipitation_Totaled --Big Creek Gatehouse
UPDATE incidents SET Datastream_Names = '4244, 4245' WHERE IncidentID = 428;

-- id 429: Soil temperature thermocouple sensor at 4 inches in depth \n Variable: Avg_Soil_Temp_4_Inches \n Datastream: Soil Temp Deg C 4 in Chickering Avg
UPDATE incidents SET Datastream_Names = '3498' WHERE IncidentID = 429;

-- id 430: Soil temperature thermocouples at 2 and 20 inches in \n depth: \n Datastream IDs: 3497 and 3500
UPDATE incidents SET Datastream_Names = '3497, 3500' WHERE IncidentID = 430;

-- id 431: Soil temperature thermocouple sensor at 8 inches in \n depth: \n Datastream ID: 3499
UPDATE incidents SET Datastream_Names = '3499' WHERE IncidentID = 431;

-- id 444: Barometric sensor
UPDATE incidents SET Datastream_Names = '3426' WHERE IncidentID = 444;

-- id 467: All station sensors effected, any data collected during the shutdown is unusable
UPDATE incidents SET Datastream_Names = 'all datastreams' WHERE IncidentID = 467;

-- id 492: Tipping bucket (rainfall and total rainfall)
UPDATE incidents SET Datastream_Names = '3576,3577' WHERE IncidentID = 492;

-- id 516: Temp/rh
UPDATE incidents SET Datastream_Names = '3818,3816,3817,3819,3820' WHERE IncidentID = 516;

-- id 517: Temp/rh
UPDATE incidents SET Datastream_Names = '3818,3816,3817,3819,3820' WHERE IncidentID = 517;

-- id 518: GeoNor precipitation gauge
UPDATE incidents SET Datastream_Names = '3142,3143,3144,3146' WHERE IncidentID = 518;

-- id 519:  Quantum (PAR) Solar radiation (RAD)
UPDATE incidents SET Datastream_Names = '3912,3913,3914' WHERE IncidentID = 519;

-- id 520: logger clock
UPDATE incidents SET Datastream_Names = 'all datastreams' WHERE IncidentID = 520;

-- id 521: logger
UPDATE incidents SET Datastream_Names = 'all datastreams' WHERE IncidentID = 521;

-- id 522: Photosynthetic radiation sensor (PAR), Li190
UPDATE incidents SET Datastream_Names = '3859,3860,3861' WHERE IncidentID = 522;

-- id 523: Rainfall, Anemometer
UPDATE incidents SET Datastream_Names = '3876,3877,3878,3864,3865,3866,3867,3862,3868,3863' WHERE IncidentID = 523;

-- id 524: Device: LI190SB Variables: PAR umole (AVG, MIN, MAX) Datastreams: 3333, 3334, and 3335
UPDATE incidents SET Datastream_Names = '3333,3334,3335' WHERE IncidentID = 524;

-- id 527: CR1000 clock corrected
UPDATE incidents SET Datastream_Names = 'all datastreams' WHERE IncidentID = 527;

-- id 540: loggers -- Dynamax Sap Flow probes added. loggers were offline during this time.
UPDATE incidents SET Datastream_Names = 'all datastreams' WHERE IncidentID = 540;

-- id 541: Anemometer swapped PAR swapped RAD swapped
UPDATE incidents SET Datastream_Names = '3806,3807,3808,3802,3803,3804,3805,3811,3812,3813,3814,3809,3815' WHERE IncidentID = 541;

-- id 543: All equipment, due to logger program update.
UPDATE incidents SET Datastream_Names = 'all datastreams' WHERE IncidentID = 543;

-- id 548: All equipment, due to logger program update.
UPDATE incidents SET Datastream_Names = 'all datastreams' WHERE IncidentID = 548;

-- id 549: Precipitation; accumulated and period. All precipitation during period was due to simulated  rainfall tests.
UPDATE incidents SET Datastream_Names = '3823,3824,3825' WHERE IncidentID = 549;

-- id 550: all DRI datastreams
UPDATE incidents SET Datastream_Names = 'all datastreams' WHERE IncidentID = 550;

-- id 543: Logger only, all sensors remain unchanged
UPDATE incidents SET Datastream_Names = 'all datastreams' WHERE IncidentID = 543;

-- id 554: GeoNor precipitation sensor
UPDATE incidents SET Datastream_Names = '3142,3143,3144,3146' WHERE IncidentID = 554;



UPDATE incidents SET Datastream_Names = '' WHERE IncidentID = 

-- NULL END DATES FIXED  40 incidens
UPDATE incidents SET EndTime = '' WHERE IncidentID = 

-- barometer died, then I removed it
UPDATE incidents SET EndTime = StartTime WHERE IncidentID = 28;
UPDATE incidents SET StartTime = '2010-08-26 00:00:00' WHERE IncidentID = 28;
UPDATE incidents SET Comments = 'Barometer was never replaced.' WHERE IncidentID = 28;

-- 

UPDATE incidents SET EndTime = "2010-11-20 18:00:00" WHERE IncidentID = 28;

-- FIX QUALIFIER CODE 
UPDATE qualifiers SET QualifierCode = "P IR_133" WHERE QualifierID = 147;
UPDATE qualifiers SET IncludeInGrid = 1 WHERE QualifierID = 147;

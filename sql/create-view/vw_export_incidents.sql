-- SQL to create export view of incident reports
-- See dendra_dev/annoation/incident investigation.sql for cleaning
-- that went on before this could be exported.
-- Subsequent scipts to run:  
-- 	extract-sensordb-export-incidents.sh
--	extract-sensordb-export-incidents.js
-- 	extract-sensordb-export-incidents-wendy.js

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

-- Separate Organizations into their own views
CREATE OR REPLACE VIEW vw_export_incident_erczo AS 
	SELECT * FROM vw_export_incident WHERE MC_Name = 'Angelo Reserve';
CREATE OR REPLACE VIEW vw_export_incident_ucnrs AS 
	SELECT * FROM vw_export_incident WHERE MC_Name = 'UCNRS';

-- Convert all UCNRS references to Imperial units to Metric
-- Depths inches to mm
--  2 in 	50 mm
--	4 in 	100 mm
-- 	8 in 	200 mm
-- 20 in 	500 mm
-- NOTE:  Manually update Fort Ord soil moisture comment in Sensor Database.  Add mm translation in paren.
-- NOTE: Manually remove 'in' from James soil moisture datastreamname in Sensor Database.  "Soil Moisture TDR freq in vert James"
-- UPDATE table_name SET field = REPLACE(field, 'foo', 'bar') WHERE INSTR(field, 'foo') > 0;
UPDATE datastreams_copy SET DatastreamName = REPLACE(DatastreamName, ' 2 in ', ' 50 mm') WHERE INSTR(DatastreamName, ' 2 in ') > 0 AND mc_name = 'UCNRS';
UPDATE datastreams_copy SET DatastreamName = REPLACE(DatastreamName, ' 4 in ', ' 100 mm') WHERE INSTR(DatastreamName, ' 4 in ') > 0 AND mc_name = 'UCNRS';
UPDATE datastreams_copy SET DatastreamName = REPLACE(DatastreamName, ' 8 in ', ' 200 mm') WHERE INSTR(DatastreamName, ' 8 in ') > 0 AND mc_name = 'UCNRS';
UPDATE datastreams_copy SET DatastreamName = REPLACE(DatastreamName, ' 20 in ', ' 500 mm') WHERE INSTR(DatastreamName, ' 20 in ') > 0 AND mc_name = 'UCNRS';

UPDATE datastreams_copy SET DatastreamName = REPLACE(DatastreamName, ' 2 inch ', ' 50 mm') WHERE INSTR(DatastreamName, ' 2 inch ') > 0 AND StationName = 'South Meadow WS';
UPDATE datastreams_copy SET DatastreamName = REPLACE(DatastreamName, ' 4 inch ', ' 100 mm') WHERE INSTR(DatastreamName, ' 4 inch ') > 0 AND StationName = 'South Meadow WS';
UPDATE datastreams_copy SET DatastreamName = REPLACE(DatastreamName, ' 8 inch ', ' 200 mm') WHERE INSTR(DatastreamName, ' 8 inch ') > 0 AND StationName = 'South Meadow WS';
UPDATE datastreams_copy SET DatastreamName = REPLACE(DatastreamName, ' 20 inch ', ' 500 mm') WHERE INSTR(DatastreamName, ' 20 inch ') > 0 AND StationName = 'South Meadow WS';


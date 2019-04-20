-- EXPORT THING TYPES (METHODS)
-- WITH VARIABLECODES AND VALID RANGE, WHICH ARE ON DATASTREAMS
-- THIS IS NOT THE FULL LIST OF METHODS, REQUIRES SEPARATE EXPORT
CREATE OR REPLACE VIEW vw_export_devices AS   
SELECT  
	v.*,
	d.DatastreamID,
	d.MethodID 
FROM devices as v, datastreams as d     
WHERE v.DeviceID = d.DeviceID;


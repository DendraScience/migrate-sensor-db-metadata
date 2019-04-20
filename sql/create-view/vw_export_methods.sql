-- EXPORT THING TYPES (METHODS)
-- WITH VARIABLECODES AND VALID RANGE, WHICH ARE ON DATASTREAMS
-- THIS IS NOT THE FULL LIST OF METHODS, REQUIRES SEPARATE EXPORT
CREATE OR REPLACE VIEW vw_export_methods AS   
SELECT  
	m.methodid,  m.methodname, d.variableid, v.variablecode,  
	count(*) as datastream_count, 
	min(d.RangeMin) as RangeMin_min,  max(d.RangeMin) as RangeMin_max,   
	min(d.RangeMax) as RangeMax_min,  max(d.RangeMax) as RangeMax_max, 
	(max(d.RangeMin) - min(d.RangeMin)) as RangeMin_diff, 
	(max(d.RangeMax) - min(d.RangeMax)) as RangeMax_diff  
FROM methods as m, datastreams as d, variables as v   
WHERE m.methodid = d.methodid  AND d.variableid = v.variableid 
GROUP BY m.methodid, v.variablecode   
ORDER BY m.methodid, v.variablecode;
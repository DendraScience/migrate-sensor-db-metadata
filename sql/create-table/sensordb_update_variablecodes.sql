-- UPDATE ALL PHOTOSYNTHETICALLY ACTIVE RADIATION (PAR) VARIABLECODES
-- UCNRS PAR variablecodes do not incude aggregates
-- PAR umole
-- PAR Micromoles per second per meter squared. Photosynthetic Photon Flux Density (PPFD). 
-- Radiation, incoming PAR
-- micromoles of photons per square meter per second
-- Other, Field Observation, Average, Climate
-- Created 4 new variablecodes using web UI, then assign them using this script.
-- Performed on database 2018-04-13 by Collin Bode
-- SELECT datastreamid,datastreamname,variablecode FROM datastreams WHERE mc_name = "UCNRS" AND variablecode like "PAR umole%";

UPDATE datastreams 
	SET VariableCode = "PAR umole Avg" 
	WHERE mc_name = "UCNRS" 
		AND variablecode = "PAR umole" 
		AND datastreamname like "%Avg%";

UPDATE datastreams 
	SET VariableCode = "PAR umole Max" 
	WHERE mc_name = "UCNRS" 
		AND variablecode = "PAR umole" 
		AND datastreamname like "%Max%";

UPDATE datastreams 
	SET VariableCode = "PAR umole Min" 
	WHERE mc_name = "UCNRS" 
		AND variablecode = "PAR umole" 
		AND datastreamname like "%Min%";

UPDATE datastreams 
SET VariableCode = "VWC Period uSec" 
WHERE mc_name = "UCNRS" 
AND variablecode = "Dielectric";
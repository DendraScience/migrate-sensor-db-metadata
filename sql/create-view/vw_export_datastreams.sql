CREATE OR REPLACE VIEW `vw_export_datastreams` AS
SELECT

  -- ----------------------------
  -- "attributes": {
  --   "height": {
  --     "unit_tag": "dt_Unit_Meter"
  --   }
  -- },

  ( SELECT CONCAT('dt_Unit_', `dendra_map_datastreams_attributes`.`dt_Unit`)
    FROM `dendra_map_datastreams_attributes`
    WHERE (`dendra_map_datastreams_attributes`.`DatastreamName` = `datastreams`.`DatastreamName` AND `dendra_map_datastreams_attributes`.`Key` = 'Height')
    ) AS `attributes$height$unit_tag`,

  -- ----------------------------
  -- "attributes": {
  --   "height": {
  --     "value": 10
  --   }
  -- },

  ( SELECT `dendra_map_datastreams_attributes`.`Value`
    FROM `dendra_map_datastreams_attributes`
    WHERE (`dendra_map_datastreams_attributes`.`DatastreamName` = `datastreams`.`DatastreamName` AND `dendra_map_datastreams_attributes`.`Key` = 'Height')
    ) AS `attributes$height$value`,

  -- ----------------------------
  -- "attributes": {
  --   "height": {
  --     "delta": [1, 5]
  --   }
  -- },

  ( SELECT `dendra_map_datastreams_attributes`.`Delta_0`
    FROM `dendra_map_datastreams_attributes`
    WHERE (`dendra_map_datastreams_attributes`.`DatastreamName` = `datastreams`.`DatastreamName` AND `dendra_map_datastreams_attributes`.`Key` = 'Height')
    ) AS `attributes$height$delta$0`,
  ( SELECT `dendra_map_datastreams_attributes`.`Delta_1`
    FROM `dendra_map_datastreams_attributes`
    WHERE (`dendra_map_datastreams_attributes`.`DatastreamName` = `datastreams`.`DatastreamName` AND `dendra_map_datastreams_attributes`.`Key` = 'Height')
    ) AS `attributes$height$delta$1`,

  -- ----------------------------
  -- "attributes": {
  --   "height": {
  --     "range": [1, 5]
  --   }
  -- },

  ( SELECT `dendra_map_datastreams_attributes`.`Range_0`
    FROM `dendra_map_datastreams_attributes`
    WHERE (`dendra_map_datastreams_attributes`.`DatastreamName` = `datastreams`.`DatastreamName` AND `dendra_map_datastreams_attributes`.`Key` = 'Height')
    ) AS `attributes$height$range$0`,
  ( SELECT `dendra_map_datastreams_attributes`.`Range_1`
    FROM `dendra_map_datastreams_attributes`
    WHERE (`dendra_map_datastreams_attributes`.`DatastreamName` = `datastreams`.`DatastreamName` AND `dendra_map_datastreams_attributes`.`Key` = 'Height')
    ) AS `attributes$height$range$1`,

  -- ----------------------------
  -- "attributes": {
  --   "depth": {
  --     "unit_tag": "dt_Unit_Meter"
  --   }
  -- },

  ( SELECT CONCAT('dt_Unit_', `dendra_map_datastreams_attributes`.`dt_Unit`)
    FROM `dendra_map_datastreams_attributes`
    WHERE (`dendra_map_datastreams_attributes`.`DatastreamName` = `datastreams`.`DatastreamName` AND `dendra_map_datastreams_attributes`.`Key` = 'Depth')
    ) AS `attributes$depth$unit_tag`,

  -- ----------------------------
  -- "attributes": {
  --   "depth": {
  --     "value": 10
  --   }
  -- },

  ( SELECT `dendra_map_datastreams_attributes`.`Value`
    FROM `dendra_map_datastreams_attributes`
    WHERE (`dendra_map_datastreams_attributes`.`DatastreamName` = `datastreams`.`DatastreamName` AND `dendra_map_datastreams_attributes`.`Key` = 'Depth')
    ) AS `attributes$depth$value`,

  -- ----------------------------
  -- "attributes": {
  --   "depth": {
  --     "delta": [1, 5]
  --   }
  -- },

  ( SELECT `dendra_map_datastreams_attributes`.`Delta_0`
    FROM `dendra_map_datastreams_attributes`
    WHERE (`dendra_map_datastreams_attributes`.`DatastreamName` = `datastreams`.`DatastreamName` AND `dendra_map_datastreams_attributes`.`Key` = 'Depth')
    ) AS `attributes$depth$delta$0`,
  ( SELECT `dendra_map_datastreams_attributes`.`Delta_1`
    FROM `dendra_map_datastreams_attributes`
    WHERE (`dendra_map_datastreams_attributes`.`DatastreamName` = `datastreams`.`DatastreamName` AND `dendra_map_datastreams_attributes`.`Key` = 'Depth')
    ) AS `attributes$depth$delta$1`,

  -- ----------------------------
  -- "attributes": {
  --   "depth": {
  --     "range": [1, 5]
  --   }
  -- },

  ( SELECT `dendra_map_datastreams_attributes`.`Range_0`
    FROM `dendra_map_datastreams_attributes`
    WHERE (`dendra_map_datastreams_attributes`.`DatastreamName` = `datastreams`.`DatastreamName` AND `dendra_map_datastreams_attributes`.`Key` = 'Depth')
    ) AS `attributes$depth$range$0`,
  ( SELECT `dendra_map_datastreams_attributes`.`Range_1`
    FROM `dendra_map_datastreams_attributes`
    WHERE (`dendra_map_datastreams_attributes`.`DatastreamName` = `datastreams`.`DatastreamName` AND `dendra_map_datastreams_attributes`.`Key` = 'Depth')
    ) AS `attributes$depth$range$1`,

  -- ----------------------------
  -- "datapoints_config": [
  --   {
  --     "connection": "legacy",
  --     "begins_at": "2017-05-28T09:50:23.106Z",
  --     "ends_before": "2017-05-28T09:50:23.106Z",
  --     "params": {
  --       "query": {
  --         "datastream_id": 3090,
  --         "time_adjust": -28800
  --       }
  --     },
  --     "path": "/datavalues-ucnrs"
  --   }
  -- ],

  `datastreams`.`StartDate` AS `datapoints_config$0$begins_at`,
  `datastreams`.`EndDate` AS `datapoints_config$0$ends_before`, 
  "true" AS `datapoints_config$0$params$query$compact`,
  `datastreams`.`DatastreamID` AS `datapoints_config$0$params$query$datastream_id`,
  -28800 AS `datapoints_config$0$params$query$time_adjust`,
  
  -- path to table is dependent on the organization
  -- '/legacy/datavalues-ucnrs' AS `datapoints_config$0$path`,
  ( SELECT CONCAT('/legacy/',`dendra_map_mcollections_organizations`.`legacy_path`) 
    FROM `dendra_map_mcollections_organizations`  
    WHERE `dendra_map_mcollections_organizations`.`MC_Name` = `datastreams`.`MC_Name`
  ) AS `datapoints_config$0$path`,
  
  -- ----------------------------
  -- "derivation_description": "Calculated server-side based on the Celsius datastream.",
  IF(`datastreams`.`FieldName` LIKE "converted from%",`datastreams`.`MethodName`, NULL ) AS `derivation_description`,
  
  -- ----------------------------
  -- "derived_from_datastream_ids": [
  --   "592f155746a1b867a114e021"
  -- ],
  -- IF(`datastreams`.`FieldName` LIKE "converted from%",(CONCAT('[',REPLACE(fieldname, 'converted from ', ''),']')), NULL ) AS `derived_from_datastream_ids`,
  
  -- ----------------------------
  -- "description": "Blue Oak Ranch average air temperature in degree Fahrenheit at 10 meter height.",
  `datastreams`.`Comments` AS `description`,

  -- ----------------------------
  -- "enabled": true,
  IF(`datastreams`.`EndDate` is NULL,"true","false") AS `enabled`,

  -- ----------------------------
  -- "external_refs": [
  --   {
  --     "identifier": "3090",
  --     "type": "odm.datastreams.datastreamid"
  --   },
  --   {
  --     "identifier": "334",
  --     "type": "odm.stations.stationid",
  --     "url": "http://sensor.berkeley.edu/index_ucnrs.html"
  --   }
  -- ],
  -- datastream_id
  CAST(`datastreams`.`DatastreamID` AS CHAR(50)) AS `external_refs$0$identifier`,
  'odm.datastreams.DatastreamID' AS `external_refs$0$type`,
  -- station_id
  CAST(`datastreams`.`StationID` AS CHAR(50)) AS `external_refs$1$identifier`,
  'odm.stations.StationID' AS `external_refs$1$type`,
  -- derived_id or loggernet.field  (mutually exclusive)
  CAST( IF(`datastreams`.`FieldName` LIKE "converted from%", REPLACE(fieldname, 'converted from ', ''), fieldname) AS CHAR(50)) AS `external_refs$2$identifier`, 
  IF(`datastreams`.`FieldName` LIKE "converted from%", "odm.datastreams.DerivedID", "loggernet.field") AS `external_refs$2$type`,

  -- ----------------------------
  -- "geo": {
  --   "coordinates": [
  --     -121.73638,
  --     37.381666,
  --     574.548
  --   ],
  --   "type": "Point"
  -- },

  -- ----------------------------
  -- "members": [
  --   {
  --     "organization_id": "592f155746a1b867a114e030",
  --     "roles": [
  --       "contact"
  --     ]
  --   },
  --   {
  --     "person_id": "592f155746a1b867a114e040",
  --     "roles": [
  --       "admin",
  --       "contact"
  --     ]
  --   }
  -- ],

  -- ----------------------------
  -- "name": "Blue Oak Ranch Avg Air Temp F 10 m",
  `datastreams`.`DatastreamName` AS `name`,

  -- ----------------------------
  -- "organization_id": "592f155746a1b867a114e030",
 `dendra_map_mcollections_organizations`.`organization_id` AS `organization_id`,

  -- ----------------------------
  -- "preferred_uom_ids": [
  --   "degree-fahrenheit"
  -- ],

  -- ----------------------------
  -- "source": "edu.berkeley.sensor.ucnrs.legacy.odm",

  -- ----------------------------
  -- "source_type": "sensor",

  'sensor' AS `source_type`,

  -- ----------------------------
  -- "state": "ready" or "retired",
  "ready" AS `state`, 
  -- IF(`datastreams`.`EndDate` is NULL,"ready","retired") AS `state`,

  -- ----------------------------
  -- "station_id": "592f155746a1b867a114e060",
  `datastreams`.`StationID` AS `station_id`,

  -- ----------------------------
  -- "tags": [
  --   "ds_Medium_Air",
  --   "ds_Variable_Temperature",
  --   "dt_Unit_DegreeFahrenheit",
  --   "ds_Aggregate_Average"
  -- ],
    ( SELECT `dendra_map_variablecodes_tags`.`Medium` FROM `dendra_map_variablecodes_tags`
      WHERE `dendra_map_variablecodes_tags`.`VariableCode` = `datastreams`.`VariableCode`
    ) AS `tags$0`,
    ( SELECT `dendra_map_variablecodes_tags`.`Variable` FROM `dendra_map_variablecodes_tags`
      WHERE `dendra_map_variablecodes_tags`.`VariableCode` = `datastreams`.`VariableCode`
    ) AS `tags$1`,
    ( SELECT `dendra_map_variablecodes_tags`.`Unit` FROM `dendra_map_variablecodes_tags`
      WHERE `dendra_map_variablecodes_tags`.`VariableCode` = `datastreams`.`VariableCode`
    ) AS `tags$2`,
    ( SELECT `dendra_map_variablecodes_tags`.`Aggregate` FROM `dendra_map_variablecodes_tags`
      WHERE `dendra_map_variablecodes_tags`.`VariableCode` = `datastreams`.`VariableCode`
    ) AS `tags$3`
  --  ( SELECT `dendra_map_variablecodes_tags`.`Misc` FROM `dendra_map_variablecodes_tags`
  --    WHERE `dendra_map_variablecodes_tags`.`VariableCode` = `datastreams`.`VariableCode`
  --  ) AS `tags$4` 

  -- ----------------------------
  -- "thing_id": "592f155746a1b867a114e070",

  -- ----------------------------
  -- "urls": [
  --   {
  --     "label": "Wiki",
  --     "url": "https://en.wikipedia.org/wiki/Conversion_of_units_of_temperature"
  --   }
  -- ]
FROM `datastreams`, `dendra_map_mcollections_organizations` 
WHERE 
  `datastreams`.`MC_Name` = `dendra_map_mcollections_organizations`.`MC_Name` AND
  `dendra_map_mcollections_organizations`.`transfer_metadata` = 1
;

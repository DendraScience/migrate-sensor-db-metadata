CREATE OR REPLACE VIEW `vw_export_datastreams_seasonal_avg` AS
SELECT 
`attributes$height$unit_tag`,
`attributes$height$value`,
`attributes$height$delta$0`,
`attributes$height$delta$1`,
`attributes$height$range$0`,
`attributes$height$range$1`,
`attributes$depth$unit_tag`,
`attributes$depth$value`,
`attributes$depth$delta$0`,
`attributes$depth$delta$1`,
`attributes$depth$range$0`,
`attributes$depth$range$1`,
`datapoints_config$0$begins_at`,
`datapoints_config$0$ends_before`,
`datapoints_config$0$params$query$compact`,
`datapoints_config$0$params$query$datastream_id`+20000 AS `datapoints_config$0$params$query$datastream_id`,
`datapoints_config$0$params$query$time_adjust`,
"/legacy/datavalues-seasonal" AS `datapoints_config$0$path`,
CONCAT("Seasonal Monthly derived from legacy datastreamid ",CAST(`datapoints_config$0$params$query$datastream_id` AS CHAR)) AS `derivation_description`,
`description`,
`enabled`,
CAST(`datapoints_config$0$params$query$datastream_id`+20000 AS CHAR(50)) AS`external_refs$0$identifier`,
`external_refs$0$type`,
`external_refs$1$identifier`,
`external_refs$1$type`,
-- derived_id is original datastream id
CAST(`datapoints_config$0$params$query$datastream_id` AS CHAR(50)) AS `external_refs$2$identifier`, 
"odm.datastreams.DerivedID" AS `external_refs$2$type`,
`external_refs$3$identifier`,
`external_refs$3$type`,
`external_refs$4$identifier`,
`external_refs$4$type`,
CONCAT(TRIM(`name`)," Seasonal Average") AS `name`,
`organization_id`,
"procedure" AS `source_type`,
`state`,
`station_id`,
`tags$0`,
`tags$1`,
`tags$2`,
"ds_Aggregate_Average" AS `tags$3`,
"ds_Function_Seasonal" AS `tags$4`
FROM `vw_export_datastreams`, `cfg_load_datavalues_day_mma` 
WHERE 
  `vw_export_datastreams`.`datapoints_config$0$params$query$datastream_id` = `cfg_load_datavalues_day_mma`.`DatastreamID`
;

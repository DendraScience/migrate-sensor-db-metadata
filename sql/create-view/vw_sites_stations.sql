CREATE OR REPLACE VIEW `vw_sites_stations` AS
SELECT
  `sites`.`SiteID` AS `SiteID`,
  `sites`.`SiteCode` AS `SiteCode`,
  `sites`.`SiteName` AS `SiteName`,
  `sites`.`MonitoringCollection` AS `MonitoringCollection`,
  `sites`.`Latitude` AS `Latitude`,
  `sites`.`Longitude` AS `Longitude`,
  `sites`.`LatLongDatumName` AS `LatLongDatumName`,
  `sites`.`Elevation_m` AS `Elevation_m`,
  `sites`.`VerticalDatum` AS `VerticalDatum`,
  `sites`.`LocalX` AS `LocalX`,
  `sites`.`LocalY` AS `LocalY`,
  `sites`.`LocalProjection` AS `LocalProjection`,
  `sites`.`PosAccuracy_m` AS `PosAccuracy_m`,
  `sites`.`State` AS `State`,
  `sites`.`County` AS `County`,
  `sites`.`Comments` AS `sites_Comments`,
  `stations`.`StationID` AS `StationID`,
  `stations`.`StationName` AS `StationName`,
  `stations`.`MC_Name` AS `MC_Name`,
  `m`.`organization_id` AS `organization_id`,
  `stations`.`DataLogger` AS `DataLogger`,
  `stations`.`TimeIntervalForUpdate` AS `TimeIntervalForUpdate`,
  `stations`.`TimeUnitsName` AS `TimeUnitsName`,
  `stations`.`FileName` AS `FileName`,
  `stations`.`Comments` AS `stations_Comments`,
  `stations`.`Contact` AS `Contact`
FROM `sites`
  INNER JOIN `stations` ON `sites`.`SiteCode` = `stations`.`SiteCode`, 
  dendra_map_mcollections_organizations as m 
WHERE
  stations.MC_Name = m.MC_Name
;

-- Code to get organization_id
-- select s.stationid,s.stationname,m.organization_id,m.mc_name 
-- FROM stations as s, dendra_map_mcollections_organizations as m 
-- WHERE s.mc_name = m.MC_Name 
-- ORDER BY s.stationname;
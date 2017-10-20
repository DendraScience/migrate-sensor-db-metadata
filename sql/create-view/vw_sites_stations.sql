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
  `stations`.`Organization` AS `Organization`,
  `stations`.`DataLogger` AS `DataLogger`,
  `stations`.`TimeIntervalForUpdate` AS `TimeIntervalForUpdate`,
  `stations`.`TimeUnitsName` AS `TimeUnitsName`,
  `stations`.`FileName` AS `FileName`,
  `stations`.`Comments` AS `stations_Comments`,
  `stations`.`Contact` AS `Contact`
FROM `sites`
  INNER JOIN `stations` ON `sites`.`SiteCode` = `stations`.`SiteCode`
;

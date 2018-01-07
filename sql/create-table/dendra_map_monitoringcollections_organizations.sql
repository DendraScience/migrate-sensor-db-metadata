dendra_map_monitoringcollections_organizations.sql

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for dendra_map_stations_organizations
-- ----------------------------
DROP TABLE IF EXISTS `dendra_map_stations_organizations`;
CREATE TABLE `dendra_map_stations_organizations` (
  `StationID` bigint(20) unsigned NOT NULL,
  `organization_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`StationID`,`organization_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of dendra_map_stations_organizations
-- ----------------------------
BEGIN;
-- insert inserts here
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;

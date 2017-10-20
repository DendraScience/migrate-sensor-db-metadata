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
INSERT INTO `dendra_map_stations_organizations` VALUES (333, 1);
INSERT INTO `dendra_map_stations_organizations` VALUES (334, 1);
INSERT INTO `dendra_map_stations_organizations` VALUES (335, 1);
INSERT INTO `dendra_map_stations_organizations` VALUES (336, 1);
INSERT INTO `dendra_map_stations_organizations` VALUES (337, 1);
INSERT INTO `dendra_map_stations_organizations` VALUES (338, 1);
INSERT INTO `dendra_map_stations_organizations` VALUES (339, 1);
INSERT INTO `dendra_map_stations_organizations` VALUES (340, 1);
INSERT INTO `dendra_map_stations_organizations` VALUES (341, 1);
INSERT INTO `dendra_map_stations_organizations` VALUES (342, 1);
INSERT INTO `dendra_map_stations_organizations` VALUES (343, 1);
INSERT INTO `dendra_map_stations_organizations` VALUES (344, 1);
INSERT INTO `dendra_map_stations_organizations` VALUES (345, 1);
INSERT INTO `dendra_map_stations_organizations` VALUES (346, 1);
INSERT INTO `dendra_map_stations_organizations` VALUES (347, 1);
INSERT INTO `dendra_map_stations_organizations` VALUES (348, 1);
INSERT INTO `dendra_map_stations_organizations` VALUES (349, 1);
INSERT INTO `dendra_map_stations_organizations` VALUES (350, 1);
INSERT INTO `dendra_map_stations_organizations` VALUES (351, 1);
INSERT INTO `dendra_map_stations_organizations` VALUES (352, 1);
INSERT INTO `dendra_map_stations_organizations` VALUES (353, 1);
INSERT INTO `dendra_map_stations_organizations` VALUES (354, 1);
INSERT INTO `dendra_map_stations_organizations` VALUES (355, 1);
INSERT INTO `dendra_map_stations_organizations` VALUES (356, 1);
INSERT INTO `dendra_map_stations_organizations` VALUES (357, 1);
INSERT INTO `dendra_map_stations_organizations` VALUES (358, 1);
INSERT INTO `dendra_map_stations_organizations` VALUES (359, 1);
INSERT INTO `dendra_map_stations_organizations` VALUES (360, 1);
INSERT INTO `dendra_map_stations_organizations` VALUES (361, 1);
INSERT INTO `dendra_map_stations_organizations` VALUES (362, 1);
INSERT INTO `dendra_map_stations_organizations` VALUES (363, 1);
INSERT INTO `dendra_map_stations_organizations` VALUES (364, 1);
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;

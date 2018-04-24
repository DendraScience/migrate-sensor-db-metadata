--SET NAMES utf8mb4;
SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for dendra_map_datastreams_attributes
-- ----------------------------
DROP TABLE IF EXISTS `dendra_map_datastreams_attributes`;
CREATE TABLE `dendra_map_datastreams_attributes` (
  `DatastreamName` varchar(255) CHARACTER SET latin1 NOT NULL,
  `Key` varchar(255) NOT NULL,
  `Delta_0` bigint(20) DEFAULT NULL,
  `Delta_1` bigint(20) DEFAULT NULL,
  `Range_0` bigint(20) DEFAULT NULL,
  `Range_1` bigint(20) DEFAULT NULL,
  `Value` bigint(20) DEFAULT NULL,
  `dt_Unit` varchar(255) DEFAULT NULL,
  `Text` varchar(255) DEFAULT NULL, 
  PRIMARY KEY (`DatastreamName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of dendra_map_datastreams_attributes
-- ----------------------------
BEGIN;
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp 10 m height C WSSM Avg', 'Height', NULL, NULL, NULL, NULL, 10, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp 10 m height C WSSM Avg 30min', 'Height', NULL, NULL, NULL, NULL, 10, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp 10 m height C WSSM Max', 'Height', NULL, NULL, NULL, NULL, 10, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp 10 m height C WSSM Max 30min', 'Height', NULL, NULL, NULL, NULL, 10, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp 10 m height C WSSM Min', 'Height', NULL, NULL, NULL, NULL, 10, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp 10 m height C WSSM Min 30min', 'Height', NULL, NULL, NULL, NULL, 10, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp 2 m height C WSSM Avg', 'Height', NULL, NULL, NULL, NULL, 2, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp 2 m height C WSSM Avg 30min', 'Height', NULL, NULL, NULL, NULL, 2, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp 2 m height C WSSM Max', 'Height', NULL, NULL, NULL, NULL, 2, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp 2 m height C WSSM Max 30min', 'Height', NULL, NULL, NULL, NULL, 2, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp 2 m height C WSSM Min', 'Height', NULL, NULL, NULL, NULL, 2, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp 2 m height C WSSM Min 30min', 'Height', NULL, NULL, NULL, NULL, 2, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta 10m-2m C WSSM Avg', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta 10m-2m C WSSM Avg 30min', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta 10m-2m C WSSM Max', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta 10m-2m C WSSM Max 30min', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta 10m-2m C WSSM Min', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta 10m-2m C WSSM Min 30min', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Angelo Avg', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Angelo Max', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Angelo Min', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Anza Borrego Avg', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Anza Borrego Max', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Anza Borrego Min', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Blue Oak Avg', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Blue Oak Max', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Blue Oak Min', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Bodega Avg', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Burns Avg', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Chickering Avg', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Deep Canyon Avg', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Deep Canyon Max', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Deep Canyon Min', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Elliott Avg', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Elliott Max', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Elliott Min', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Granites Avg', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Hastings Avg', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Hastings Max', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Hastings Min', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Jepson Avg', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Jepson Max', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Jepson Min', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m McLaughlin Avg', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m McLaughlin Max', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m McLaughlin Min', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Motte Avg', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Motte Max', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Motte Min', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Rancho Marino Avg', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Rancho Marino Max', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Rancho Marino Min', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Santa Cruz Island Avg', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Santa Cruz Island Max', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Santa Cruz Island Min', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Sedgwick Avg', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Sedgwick Max', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Sedgwick Min', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m SNARL Avg', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m SNARL Max', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m SNARL Min', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Stunt Ranch Avg', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Younger Avg', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Younger Max', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Air Temp Delta Deg C 10m-2m Younger Min', 'Height', 10, 2, NULL, NULL, NULL, 'Meter', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Soil Temp 2 inch depth C WSSM Avg', 'Depth', NULL, NULL, NULL, NULL, 2, 'Inch', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Soil Temp 2 inch depth C WSSM Max', 'Depth', NULL, NULL, NULL, NULL, 2, 'Inch', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Soil Temp 2 inch depth C WSSM Min', 'Depth', NULL, NULL, NULL, NULL, 2, 'Inch', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Soil Temp 20 inch depth C WSSM Avg', 'Depth', NULL, NULL, NULL, NULL, 20, 'Inch', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Soil Temp 20 inch depth C WSSM Max', 'Depth', NULL, NULL, NULL, NULL, 20, 'Inch', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Soil Temp 20 inch depth C WSSM Min', 'Depth', NULL, NULL, NULL, NULL, 20, 'Inch', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Soil Temp 4 inch depth C WSSM Avg', 'Depth', NULL, NULL, NULL, NULL, 4, 'Inch', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Soil Temp 4 inch depth C WSSM Max', 'Depth', NULL, NULL, NULL, NULL, 4, 'Inch', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Soil Temp 4 inch depth C WSSM Min', 'Depth', NULL, NULL, NULL, NULL, 4, 'Inch', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Soil Temp 8 inch depth C WSSM Avg', 'Depth', NULL, NULL, NULL, NULL, 8, 'Inch', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Soil Temp 8 inch depth C WSSM Max', 'Depth', NULL, NULL, NULL, NULL, 8, 'Inch', NULL);
INSERT INTO `dendra_map_datastreams_attributes` VALUES ('Soil Temp 8 inch depth C WSSM Min', 'Depth', NULL, NULL, NULL, NULL, 8, 'Inch', NULL);
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for dendra_map_variables_tags
-- ----------------------------
DROP TABLE IF EXISTS `dendra_map_variables_tags`;
CREATE TABLE `dendra_map_variables_tags` (
  `VariableCode` varchar(255) CHARACTER SET latin1 NOT NULL,
  `tag` varchar(255) NOT NULL,
  PRIMARY KEY (`VariableCode`,`tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of dendra_map_variables_tags
-- ----------------------------
INSERT INTO `dendra_map_variables_tags` (`VariablCode`,`tag`) 
	SELECT `VariableCode`, `Medium` FROM `dendra_map_variablecodes_pre`;
INSERT INTO `dendra_map_variables_tags` (`VariablCode`,`tag`) 
	SELECT `VariableCode`, `Variable` FROM `dendra_map_variablecodes_pre`;
INSERT INTO `dendra_map_variables_tags` (`VariablCode`,`tag`) 
	SELECT `VariableCode`, `Unit` FROM `dendra_map_variablecodes_pre`;
INSERT INTO `dendra_map_variables_tags` (`VariablCode`,`tag`) 
	SELECT `VariableCode`, `Aggregate` FROM `dendra_map_variablecodes_pre`;

SET FOREIGN_KEY_CHECKS = 1;

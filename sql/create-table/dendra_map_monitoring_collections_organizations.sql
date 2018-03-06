SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for dendra_map_mcollections_organizations
-- ----------------------------
DROP TABLE IF EXISTS `dendra_map_mcollections_organizations`;
CREATE TABLE `dendra_map_mcollections_organizations` (
	`MC_Name`  varchar(255) NOT NULL,
	`slug` varchar(255) NOT NULL,
	`organization_id` VARCHAR(255) NOT NULL,
	`MCID` INT NOT NULL,
	`transfer_metadata` BOOLEAN,
	`legacy_path` VARCHAR(255) NOT NULL,
	PRIMARY KEY (`MC_Name`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of dendra_map_mcollections_organizations
-- ----------------------------
BEGIN;
INSERT INTO `dendra_map_mcollections_organizations` VALUES ('Angelo Reserve','erczo',"58db17e824dc720001671379",2,true,'datavalues2');
INSERT INTO `dendra_map_mcollections_organizations` VALUES ('Blue Oak Ranch Reserve','blue-oak',"58143930650aad2999d57289",14,false,'datavalues-borr');
INSERT INTO `dendra_map_mcollections_organizations` VALUES ('Keck Motes','keck-motes',"5a416c49732a67000130eb4e",8,false,'datavalues-motes');
INSERT INTO `dendra_map_mcollections_organizations` VALUES ('Sagehen','sagehen',"5a3eaabee15cbd00016b9665",10,false,'datavalues-sagehen');
INSERT INTO `dendra_map_mcollections_organizations` VALUES ('UCNRS','ucnrs',"58db17c424dc720001671378",15,true,'datavalues-ucnrs');
INSERT INTO `dendra_map_mcollections_organizations` VALUES ('USGS NWIS','usgs-nwis',"5a4171f0732a67000130eb50",9,false,'datavalues-usgs');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;

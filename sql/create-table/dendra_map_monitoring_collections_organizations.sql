SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for dendra_map_mcollections_organizations
-- ----------------------------
DROP TABLE IF EXISTS `dendra_map_mcollections_organizations`;
CREATE TABLE `dendra_map_mcollections_organizations` (
	`MC_Name`  varchar(255) NOT NULL,
	`organization_id` VARCHAR(255) NOT NULL,
	`MCID` INT NOT NULL,
	`transfer_metadata` BOOLEAN,
	PRIMARY KEY (`MC_Name`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of dendra_map_mcollections_organizations
-- ----------------------------
BEGIN;
INSERT INTO `dendra_map_mcollections_organizations` VALUES ('Angelo Reserve',"58db17e824dc720001671379",2,true);
INSERT INTO `dendra_map_mcollections_organizations` VALUES ('Blue Oak Ranch Reserve',"58143930650aad2999d57289",14,false);
INSERT INTO `dendra_map_mcollections_organizations` VALUES ('Keck Motes',"5a416c49732a67000130eb4e",8,false);
INSERT INTO `dendra_map_mcollections_organizations` VALUES ('Sagehen',"5a3eaabee15cbd00016b9665",10,false);
INSERT INTO `dendra_map_mcollections_organizations` VALUES ('UCNRS',"58db17c424dc720001671378",15,true);
INSERT INTO `dendra_map_mcollections_organizations` VALUES ('USGS NWIS',"5a4171f0732a67000130eb50",9,false);
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
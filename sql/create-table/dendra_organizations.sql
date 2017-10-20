SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for dendra_organizations
-- ----------------------------
DROP TABLE IF EXISTS `dendra_organizations`;
CREATE TABLE `dendra_organizations` (
  `id` int(11) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of dendra_organizations
-- ----------------------------
BEGIN;
INSERT INTO `dendra_organizations` VALUES (1, 'University of California Natural Reserve System', 'infomgr@ucnrs.org', 'http://www.ucnrs.org');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;

/*
Navicat MySQL Data Transfer

Source Server         : 172.16.20.39
Source Server Version : 50724
Source Host           : 172.16.20.39:3306
Source Database       : ssm

Target Server Type    : MYSQL
Target Server Version : 50724
File Encoding         : 65001

Date: 2018-12-12 08:52:03
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `user`
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(10) NOT NULL,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `age` int(10) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `desc` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('1', 'xiong', '111', '10', '山西', '所在的城市');
INSERT INTO `user` VALUES ('2', ',miao', '111', '10', 'dizhi', 'desc');
INSERT INTO `user` VALUES ('3', 'miao', '111', '10', 'dizhi', 'desc');
INSERT INTO `user` VALUES ('4', 'miao', '111', '10', 'dizhi', 'desc');
INSERT INTO `user` VALUES ('5', 'miao', '111', '10', 'dizhi', 'desc');
INSERT INTO `user` VALUES ('6', 'miao', '111', '10', 'dizhi', 'desc');
INSERT INTO `user` VALUES ('7', 'miao', '111', '10', 'dizhi', 'desc');
INSERT INTO `user` VALUES ('8', 'miao', '111', '10', 'dizhi', 'desc');
INSERT INTO `user` VALUES ('9', 'miao', '111', '10', 'dizhi', 'desc');
INSERT INTO `user` VALUES ('11', 'zhangsan', '111', '10', 'dizhi', 'desc');
INSERT INTO `user` VALUES ('12', 'miao', '111', '10', 'dizhi', 'desc');
INSERT INTO `user` VALUES ('13', 'miao', '111', '10', 'dizhi', 'desc');
INSERT INTO `user` VALUES ('14', 'miao', '111', '10', 'dizhi', 'desc');
INSERT INTO `user` VALUES ('15', 'miao', '111', '10', 'dizhi', 'desc');
INSERT INTO `user` VALUES ('16', 'miao', '111', '10', 'dizhi', 'desc');
INSERT INTO `user` VALUES ('17', 'miao', '111', '10', 'dizhi', 'desc');

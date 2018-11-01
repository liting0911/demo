/*
 Navicat Premium Data Transfer

 Source Server         : localhost-root
 Source Server Type    : MySQL
 Source Server Version : 50712
 Source Host           : 127.0.0.1:3306
 Source Schema         : washcloud

 Target Server Type    : MySQL
 Target Server Version : 50712
 File Encoding         : 65001

 Date: 01/11/2018 19:03:44
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for addr_city
-- ----------------------------
DROP TABLE IF EXISTS `addr_city`;
CREATE TABLE `addr_city`  (
  `id` int(6) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '市名',
  `province_id` int(6) UNSIGNED NOT NULL COMMENT '所属省份',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_ac_ap`(`province_id`) USING BTREE,
  CONSTRAINT `addr_city_ibfk_1` FOREIGN KEY (`province_id`) REFERENCES `addr_province` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 659001 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '市信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for addr_info
-- ----------------------------
DROP TABLE IF EXISTS `addr_info`;
CREATE TABLE `addr_info`  (
  `id` int(8) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `province_id` int(6) UNSIGNED NOT NULL COMMENT '省份',
  `city_id` int(6) UNSIGNED NOT NULL COMMENT '市',
  `region_id` int(6) UNSIGNED NOT NULL COMMENT '区',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_ai_province`(`province_id`) USING BTREE,
  CONSTRAINT `addr_info_ibfk_1` FOREIGN KEY (`province_id`) REFERENCES `addr_province` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 45 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '地址组合信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for addr_province
-- ----------------------------
DROP TABLE IF EXISTS `addr_province`;
CREATE TABLE `addr_province`  (
  `id` int(6) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '省名',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 820001 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '省份信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for addr_region
-- ----------------------------
DROP TABLE IF EXISTS `addr_region`;
CREATE TABLE `addr_region`  (
  `id` int(6) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '区名',
  `city_id` int(6) UNSIGNED NOT NULL COMMENT '所属市',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_ar_ac`(`city_id`) USING BTREE,
  CONSTRAINT `addr_region_ibfk_1` FOREIGN KEY (`city_id`) REFERENCES `addr_city` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 659007 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '区信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for alarm
-- ----------------------------
DROP TABLE IF EXISTS `alarm`;
CREATE TABLE `alarm`  (
  `id` int(8) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `device_id` int(10) UNSIGNED NOT NULL COMMENT '设备id',
  `description` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '故障描述',
  `date_update` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '故障产生时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5395 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '设备警报消息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for app_customer
-- ----------------------------
DROP TABLE IF EXISTS `app_customer`;
CREATE TABLE `app_customer`  (
  `id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '随机UUID',
  `nick_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '用户昵称，可以为空',
  `avatar_url` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '头像URL路径，可以为空',
  `gender` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '性别，默认为0代表未知，1代表男，2代表女',
  `phone` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '手机号码，需要绑定',
  `password` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '密码，暂定为空',
  `status` tinyint(1) UNSIGNED NOT NULL COMMENT '状态，1代表正常，2代表禁用',
  `wallet_money` decimal(6, 2) NOT NULL DEFAULT 0.00,
  `wx_open_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '微信授权openId',
  `create_date` datetime(0) NOT NULL COMMENT '创建日期',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `ac_wx_open_id`(`wx_open_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'APP消费者端授权用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for app_wallet_record
-- ----------------------------
DROP TABLE IF EXISTS `app_wallet_record`;
CREATE TABLE `app_wallet_record`  (
  `id` int(8) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `app_customer_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '小程序用户ID',
  `change` decimal(6, 2) NOT NULL DEFAULT 0.00 COMMENT '变动金额',
  `order_num` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '订单号',
  `order_type` enum('Washer','Recharge') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '订单类型',
  `note` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '备注',
  `date_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_app_customer_id`(`app_customer_id`) USING BTREE,
  CONSTRAINT `fk_app_customer_id` FOREIGN KEY (`app_customer_id`) REFERENCES `app_customer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '小程序用户钱包消费记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bill
-- ----------------------------
DROP TABLE IF EXISTS `bill`;
CREATE TABLE `bill`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `bill_num` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '账单编号',
  `alipay_num` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '支付宝单号',
  `business_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商家id',
  `money_actual` int(8) UNSIGNED NOT NULL COMMENT '总的实际结算金额 乘以100存储',
  `money_discount` int(8) UNSIGNED NOT NULL COMMENT '订单总的折扣金额 乘以100存储',
  `order_count` int(6) UNSIGNED NOT NULL COMMENT '订单总数',
  `date_checkout` date NOT NULL COMMENT '结帐日期',
  `state` tinyint(1) UNSIGNED NOT NULL COMMENT '账单状态：1.已结帐 2.未结帐 3.结帐失败',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_bill_user`(`business_id`) USING BTREE,
  CONSTRAINT `bill_ibfk_1` FOREIGN KEY (`business_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 110 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '结账账单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bill_settle_records
-- ----------------------------
DROP TABLE IF EXISTS `bill_settle_records`;
CREATE TABLE `bill_settle_records`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `bill_id` int(10) UNSIGNED NOT NULL COMMENT '账单id',
  `operate_date` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作日期',
  `operate_result` tinyint(1) UNSIGNED NOT NULL COMMENT '操作结果：1. 成功，2：失败',
  `out_biz_no` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '支付宝转出方账户',
  `payee_account` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '支付宝转入方账户',
  `amount` double(10, 2) UNSIGNED NOT NULL COMMENT '金额',
  `payer_show_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '支付宝转出方昵称',
  `payee_real_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '支付宝转入方真实姓名',
  `remark` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '操作备注，如果结算成功：结算结果：{0},结算日期：{1}，金额：{2},如果结算失败：errorDesc',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '结账记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for captche
-- ----------------------------
DROP TABLE IF EXISTS `captche`;
CREATE TABLE `captche`  (
  `key` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '索引key',
  `value` smallint(4) UNSIGNED NOT NULL COMMENT '验证码数值',
  PRIMARY KEY (`key`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '验证码（key，value）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for coupon
-- ----------------------------
DROP TABLE IF EXISTS `coupon`;
CREATE TABLE `coupon`  (
  `id` int(8) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '优惠券ID',
  `user_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商家ID',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '优惠券名称',
  `description` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '描述和使用说明',
  `status` tinyint(1) UNSIGNED NOT NULL COMMENT '状态，1-代表待发布，2-代表已发布，3-代表已下线',
  `threshold_money` double(4, 2) UNSIGNED NOT NULL COMMENT '使用金额门槛，总金额必须等于或超过该值才可以使用该优惠券',
  `quantity` int(5) UNSIGNED NOT NULL COMMENT '优惠券总数量，0代表没有数量限制',
  `use_validity_date_start` datetime(0) NOT NULL COMMENT '使用有效期-开始时间',
  `use_validity_date_end` datetime(0) NOT NULL COMMENT '使用有效期-结束时间',
  `type` tinyint(1) UNSIGNED NOT NULL COMMENT '类型，1-代表优惠指定金额，2-代表打折，3-代表满几减几',
  `arg_settings` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '参数设置，不同优惠券类型有不同的参数设置，JSON格式',
  `restrict_city` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '' COMMENT '使用限定城市',
  `restrict_laundry` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '' COMMENT '使用限定洗衣站点，多个站点使用逗号分隔',
  `restrict_trademark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '' COMMENT '使用限定机器品牌，多个品牌使用逗号分隔',
  `restrict_category` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '' COMMENT '使用限定机器类型，多个类型使用逗号分隔',
  `create_date` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建日期',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 49 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '优惠券信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for coupon_customer
-- ----------------------------
DROP TABLE IF EXISTS `coupon_customer`;
CREATE TABLE `coupon_customer`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `customer_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户ID',
  `coupon_id` tinyint(1) UNSIGNED NOT NULL COMMENT '优惠券ID',
  `status` tinyint(1) UNSIGNED NOT NULL COMMENT '状态，1-代表正常未使用，2-代表已使用，3-代表已失效, 4-已锁定',
  `create_date` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '领取时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `unique_customer_id_coupon_id`(`customer_id`, `coupon_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 109 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户优惠券信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for device
-- ----------------------------
DROP TABLE IF EXISTS `device`;
CREATE TABLE `device`  (
  `id` int(8) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '设备名称',
  `imei` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'imei号 设备识别码',
  `floor_num` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '设备编号，格式：XXF-UXX （如10F-U12 表示在10楼编号为12）',
  `qr_code` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '二维码的机器号',
  `iccid` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'iccid号',
  `type_id` tinyint(2) UNSIGNED NOT NULL COMMENT '设备类型',
  `state` tinyint(2) UNSIGNED NOT NULL COMMENT '设备状态 1:空闲 2:运行 3:故障 4:游离 5:掉线 6:维护 7:上线 8:锁定',
  `online_state` tinyint(2) NOT NULL DEFAULT 2 COMMENT '设备在线状态，1-在线，2-掉线',
  `create_date` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `laundry_id` int(8) UNSIGNED NOT NULL COMMENT '洗衣点id',
  `user_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '设备所属用户ID',
  `number_of_queue` tinyint(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排队人数',
  `business_state` tinyint(2) UNSIGNED NOT NULL DEFAULT 1 COMMENT '设备业务状态：1:可预定 2.可预约。设备状态为“运行\"时“可预约”。设备状态为非“运行”时“可预订”。',
  `topic_info_id` int(8) UNSIGNED NOT NULL DEFAULT 0 COMMENT '阿里云topic信息',
  `bluetooth_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '蓝牙数据命令',
  `latest_state_update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '状态最后更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_device_dt`(`type_id`) USING BTREE,
  INDEX `fk_device_ds`(`state`) USING BTREE,
  INDEX `fk_device_lp`(`laundry_id`) USING BTREE,
  INDEX `fk_topic_id`(`topic_info_id`) USING BTREE,
  CONSTRAINT `device_ibfk_1` FOREIGN KEY (`state`) REFERENCES `device_state` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `device_ibfk_2` FOREIGN KEY (`type_id`) REFERENCES `device_type` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_device_topic_id` FOREIGN KEY (`topic_info_id`) REFERENCES `topic_info` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 176 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '设备信息\r\n' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for device_category
-- ----------------------------
DROP TABLE IF EXISTS `device_category`;
CREATE TABLE `device_category`  (
  `id` char(2) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'ID',
  `name` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '类别名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '设备类别' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for device_maintain
-- ----------------------------
DROP TABLE IF EXISTS `device_maintain`;
CREATE TABLE `device_maintain`  (
  `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `type_id` tinyint(3) UNSIGNED NOT NULL COMMENT '洗衣机类型id',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '洗衣模式名称',
  `cmd_args` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_type_id`(`type_id`) USING BTREE,
  CONSTRAINT `fk_type_id` FOREIGN KEY (`type_id`) REFERENCES `device_type` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 176 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '洗衣模式' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for device_mode_setting
-- ----------------------------
DROP TABLE IF EXISTS `device_mode_setting`;
CREATE TABLE `device_mode_setting`  (
  `id` int(8) UNSIGNED NOT NULL AUTO_INCREMENT,
  `device_id` int(10) UNSIGNED NOT NULL COMMENT '设备id',
  `mode_id` smallint(5) UNSIGNED NOT NULL COMMENT '洗衣模式id',
  `pulse_num` tinyint(3) UNSIGNED NOT NULL COMMENT '脉冲数',
  `program_run_time` smallint(5) UNSIGNED NOT NULL COMMENT '洗衣时长 秒',
  `program_offline_code` varchar(180) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '离线码',
  `price` double(4, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT 'app端显示价格 元',
  `app_program_run_time` smallint(5) UNSIGNED NOT NULL COMMENT 'app端显示洗衣时长 秒',
  `is_available` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '1：打开/0：关闭，即功能是否可以用',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `fk_device_mode_pulse_1`(`device_id`, `mode_id`) USING BTREE,
  INDEX `fk_device_mode`(`mode_id`) USING BTREE,
  CONSTRAINT `device_mode_setting_ibfk_1` FOREIGN KEY (`device_id`) REFERENCES `device` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_device_mode` FOREIGN KEY (`mode_id`) REFERENCES `washer_mode` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1229 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '洗衣程序表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for device_property_value
-- ----------------------------
DROP TABLE IF EXISTS `device_property_value`;
CREATE TABLE `device_property_value`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `device_id` int(8) UNSIGNED NOT NULL COMMENT '设备Id',
  `property_id` int(10) UNSIGNED NOT NULL COMMENT '洗衣参数id',
  `property_value` int(8) UNSIGNED NOT NULL COMMENT '当前设备该洗衣参数设定值',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_device_property_value_2`(`property_id`) USING BTREE,
  INDEX `fk_device_property_value_1`(`device_id`) USING BTREE,
  CONSTRAINT `fk_device_property_value_1` FOREIGN KEY (`device_id`) REFERENCES `device` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_device_property_value_2` FOREIGN KEY (`property_id`) REFERENCES `washer_property` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '设备某洗衣参数值' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for device_state
-- ----------------------------
DROP TABLE IF EXISTS `device_state`;
CREATE TABLE `device_state`  (
  `id` tinyint(2) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '设备状态' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for device_state_history
-- ----------------------------
DROP TABLE IF EXISTS `device_state_history`;
CREATE TABLE `device_state_history`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `device_id` int(8) UNSIGNED NOT NULL COMMENT '设备id',
  `state_id` tinyint(2) UNSIGNED NOT NULL COMMENT '状态',
  `state_start_time` datetime(0) NOT NULL COMMENT '状态开始时间',
  `state_duration` int(7) UNSIGNED NOT NULL COMMENT '状态持续时长(sec)',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_device`(`device_id`, `state_start_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 35858 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '设备历史状态' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for device_trademark
-- ----------------------------
DROP TABLE IF EXISTS `device_trademark`;
CREATE TABLE `device_trademark`  (
  `id` varchar(2) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'ID',
  `name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '品牌名',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '设备品牌' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for device_type
-- ----------------------------
DROP TABLE IF EXISTS `device_type`;
CREATE TABLE `device_type`  (
  `id` tinyint(2) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '类型名',
  `product_type` char(2) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '00：洗衣机，01：洗鞋机，02：干衣机，03：吹风机，0x04：饮水机，0xff：脉冲控制类电器',
  `product_name` char(2) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '设备的工业型号',
  `trademark_id` varchar(2) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '设备品牌id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_dt_trademark_id`(`trademark_id`) USING BTREE,
  INDEX `fk_dt_product_type`(`product_type`) USING BTREE,
  CONSTRAINT `fk_dt_product_type` FOREIGN KEY (`product_type`) REFERENCES `device_category` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_dt_trademark_id` FOREIGN KEY (`trademark_id`) REFERENCES `device_trademark` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '设备类型' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for laundry_point
-- ----------------------------
DROP TABLE IF EXISTS `laundry_point`;
CREATE TABLE `laundry_point`  (
  `id` int(8) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `business_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '所属商家id',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '洗衣点名称',
  `addr_id` int(8) UNSIGNED NOT NULL COMMENT '省市区信息',
  `addr_specific` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '除省市区外-详细地址信息',
  `pay_time` tinyint(3) UNSIGNED NOT NULL COMMENT '最长支付时间 分钟',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_lp_user`(`business_id`) USING BTREE,
  INDEX `fk_lp_ar`(`addr_id`) USING BTREE,
  CONSTRAINT `laundry_point_ibfk_1` FOREIGN KEY (`addr_id`) REFERENCES `addr_info` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `laundry_point_ibfk_2` FOREIGN KEY (`business_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 71 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '洗衣点信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for order_info
-- ----------------------------
DROP TABLE IF EXISTS `order_info`;
CREATE TABLE `order_info`  (
  `id` int(8) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `order_num` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '订单号',
  `pay_mode_id` tinyint(1) UNSIGNED NOT NULL COMMENT '支付方式 1:支付宝 2:微信支付 3:钱包',
  `money_actual` smallint(5) UNSIGNED NOT NULL COMMENT '实际支付金额  (实际金额乘以100后存储）',
  `money_discount` smallint(5) UNSIGNED NOT NULL DEFAULT 0 COMMENT '折扣金额 (实际金额乘以100后存储）',
  `discount_id` int(5) UNSIGNED NOT NULL DEFAULT 0 COMMENT '优惠活动id',
  `source_type` tinyint(2) UNSIGNED NOT NULL COMMENT '订单来源：1:app 2:微信 3:支付宝',
  `business_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商家id',
  `device_id` int(8) UNSIGNED NOT NULL COMMENT '设备id',
  `washer_mode_id` smallint(5) UNSIGNED NOT NULL COMMENT '设备运行模式',
  `order_state` tinyint(2) UNSIGNED NOT NULL COMMENT '订单状态：1.已下单 2.已支付 3.完成 4.故障关闭 5.超时关闭',
  `date_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '订单创建时间',
  `app_customer_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '小程序用户id',
  `startup_param` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '启动参数',
  `pay_time` datetime(0) DEFAULT NULL COMMENT '支付时间，付款完成的时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_order_pm`(`pay_mode_id`) USING BTREE,
  INDEX `fk_order_user`(`business_id`) USING BTREE,
  INDEX `fk_order_device`(`device_id`) USING BTREE,
  CONSTRAINT `order_info_ibfk_1` FOREIGN KEY (`device_id`) REFERENCES `device` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `order_info_ibfk_2` FOREIGN KEY (`pay_mode_id`) REFERENCES `pay_mode` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `order_info_ibfk_3` FOREIGN KEY (`business_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 668 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '订单信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for order_refund
-- ----------------------------
DROP TABLE IF EXISTS `order_refund`;
CREATE TABLE `order_refund`  (
  `id` int(8) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `order_num` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '订单号',
  `user_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商家ID',
  `customer_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '消费者用户ID',
  `device_id` int(8) UNSIGNED NOT NULL COMMENT '设备id',
  `refund_type` enum('Backtrack','Wallet') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'Backtrack' COMMENT '退款方式',
  `status` tinyint(2) UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态，1-审核中，2-通过，3-不通过',
  `user_note` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '用户退款备注',
  `message` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '审核结果',
  `approval_date` datetime(0) DEFAULT NULL COMMENT '审核处理日期',
  `create_date` datetime(0) NOT NULL COMMENT '创建日期',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户主动发起订单退款记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for order_state
-- ----------------------------
DROP TABLE IF EXISTS `order_state`;
CREATE TABLE `order_state`  (
  `id` tinyint(2) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '状态名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '订单状态' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pay_mode
-- ----------------------------
DROP TABLE IF EXISTS `pay_mode`;
CREATE TABLE `pay_mode`  (
  `id` tinyint(1) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '支付方式' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pre_startup_program_cmd
-- ----------------------------
DROP TABLE IF EXISTS `pre_startup_program_cmd`;
CREATE TABLE `pre_startup_program_cmd`  (
  `type_id` tinyint(2) UNSIGNED NOT NULL COMMENT '类型ID',
  `cmd_type` char(2) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'cmd类型',
  `cmd_name` char(2) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'cmd名称',
  PRIMARY KEY (`type_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '预启动命令(如激活/复位等）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for recharge_config
-- ----------------------------
DROP TABLE IF EXISTS `recharge_config`;
CREATE TABLE `recharge_config`  (
  `id` int(8) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `money` decimal(6, 2) UNSIGNED NOT NULL COMMENT '金额',
  `actual_money` decimal(6, 2) UNSIGNED NOT NULL COMMENT '实际金额',
  `state` enum('Effective','Invalid') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'Effective' COMMENT '是否可用',
  `date_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `note` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户充值配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for recharge_record
-- ----------------------------
DROP TABLE IF EXISTS `recharge_record`;
CREATE TABLE `recharge_record`  (
  `id` int(8) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `order_num` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '充值订单号',
  `money` decimal(6, 2) UNSIGNED NOT NULL COMMENT '充值金额',
  `actual_money` decimal(6, 2) UNSIGNED NOT NULL COMMENT '实际支付的金额',
  `state` enum('Ordered','Paid','Completed','Timeout') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '订单的状态',
  `payment` enum('Alipay','WeChatPay','WalletPay','System') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '支付方式',
  `app_customer_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '小程序用户id',
  `note` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '备注',
  `date_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_order_num`(`order_num`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户充值记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for startup_program_command_params
-- ----------------------------
DROP TABLE IF EXISTS `startup_program_command_params`;
CREATE TABLE `startup_program_command_params`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `washer_mode_id` smallint(5) UNSIGNED NOT NULL COMMENT '模式id',
  `parameter_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '参数名称',
  `is_enum` tinyint(1) UNSIGNED NOT NULL COMMENT '是否枚举类型，1 ： 是枚举 ；0:数值型',
  `parameter_default_value` int(11) UNSIGNED NOT NULL COMMENT '参数默认值',
  `parameter_constraint` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '参数限定值',
  `parameter_description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '参数描述',
  `is_visible` tinyint(1) UNSIGNED NOT NULL COMMENT '终端用户是否可见',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '模式启动参数' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for student_score
-- ----------------------------
DROP TABLE IF EXISTS `student_score`;
CREATE TABLE `student_score`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `score` double(255, 0) NOT NULL,
  `class` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `course` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `id` int(8) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `register_wallet_func` enum('Enable','Disable') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'Disable' COMMENT '是否开启新注册用户获钱包额度功能',
  `register_wallet_money` decimal(6, 2) NOT NULL DEFAULT 0.00 COMMENT '新注册用户获钱包额度(元)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统配置项' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for topic_info
-- ----------------------------
DROP TABLE IF EXISTS `topic_info`;
CREATE TABLE `topic_info`  (
  `id` int(10) UNSIGNED NOT NULL COMMENT '规定id=1的记录是AliIOT,id =2 的记录是Neoway',
  `mqtt_provider` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'mqtt服务供应商：AliIOT，Neoway',
  `access_key` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '阿里iot特有,调用阿里iot套件的授权key',
  `access_key_secret` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '阿里iot特有，调用阿里iot套件的授权secret',
  `iot_region_id` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '阿里iot独有，要访问的iot的regionId目前支持的cn-shanghai(华东2)、ap-southeast-1（新加坡）、us-west-1（美西）',
  `iot_product_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT 'iot' COMMENT 'iot套件对应的产品code保持不变即可,默认值\"iot\"',
  `iot_domain` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'Iotapi的服务地址,跟regionId对应',
  `topic_key` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '主题前缀，在阿里iot中对应的是productKey',
  `product_secret` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '阿里iot独有，题哦你topickey配套',
  `publish_suffix_topic` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '云端向模块发送mqtt消息的topic后缀，如/publish ',
  `qos` int(10) UNSIGNED DEFAULT 1 COMMENT '阿里iot的qos，目前可以允许值为0和1；',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'topic信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '主键id',
  `username` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '登录用户名',
  `password` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '登录密码',
  `nickname` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '显示用户名',
  `email` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '邮箱',
  `phone` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '电话',
  `role` tinyint(2) UNSIGNED NOT NULL COMMENT '角色 1:平台超级管理员 2:平台普通管理员 3:商家账号 4:洗衣店管理员 5:财务 6:维修工',
  `state` tinyint(1) UNSIGNED NOT NULL COMMENT '状态 1:待审核 2:审核失败 3:启用 4:禁用',
  `parent_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '父账户id',
  `payment_id` int(8) UNSIGNED NOT NULL DEFAULT 0 COMMENT '支付信息id',
  `app_key` char(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_username`(`username`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for user_config
-- ----------------------------
DROP TABLE IF EXISTS `user_config`;
CREATE TABLE `user_config`  (
  `id` int(8) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '商家用户ID',
  `pay_mode` set('Alipay','WeChatPay','WalletPay','System') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '支持的付款方式',
  `refund_type` enum('Backtrack','Wallet') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'Backtrack' COMMENT '订单退款方式',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_user_id`(`user_id`) USING BTREE,
  CONSTRAINT `fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商家用户配置项' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for user_payment
-- ----------------------------
DROP TABLE IF EXISTS `user_payment`;
CREATE TABLE `user_payment`  (
  `id` int(8) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `business_licence` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '经营许可证号码',
  `checkout_cycle` tinyint(3) UNSIGNED NOT NULL COMMENT '结账周期',
  `bill_start` datetime(0) NOT NULL COMMENT '账单开始日期',
  `pay_mode_id` tinyint(1) UNSIGNED NOT NULL COMMENT '支付方式 1:支付宝 2:微信支付 3:钱包',
  `licence_url` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '经营许可证图片',
  `date_register` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  `alipay_acount` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '支付宝账户',
  `alipay_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '支付宝真实姓名',
  `addr_id` int(8) UNSIGNED NOT NULL COMMENT '省市区信息',
  `addr_specific` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '除省市区外-详细地址信息',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_up_pm`(`pay_mode_id`) USING BTREE,
  INDEX `fk_up_ai`(`addr_id`) USING BTREE,
  CONSTRAINT `user_payment_ibfk_1` FOREIGN KEY (`addr_id`) REFERENCES `addr_info` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `user_payment_ibfk_2` FOREIGN KEY (`pay_mode_id`) REFERENCES `pay_mode` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户支付账户信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for washer_mode
-- ----------------------------
DROP TABLE IF EXISTS `washer_mode`;
CREATE TABLE `washer_mode`  (
  `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `type_id` smallint(5) UNSIGNED NOT NULL COMMENT '洗衣机类型id',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '洗衣模式名称',
  `program_enum_code` char(2) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '洗衣模式的枚举值',
  `pulse_default_num` smallint(5) UNSIGNED NOT NULL COMMENT '默认脉冲数',
  `price` double(4, 2) UNSIGNED DEFAULT 1.00 COMMENT '价格 元',
  `pulse_min` smallint(5) UNSIGNED NOT NULL COMMENT '最小脉冲数',
  `pulse_max` smallint(5) UNSIGNED NOT NULL COMMENT '最大脉冲数',
  `program_default_run_minute` smallint(5) UNSIGNED NOT NULL COMMENT '洗衣程序默认运行分钟数',
  `program_min_run_minute` smallint(5) UNSIGNED NOT NULL COMMENT '洗衣程序最小运行分钟数',
  `program_max_run_minute` smallint(5) UNSIGNED NOT NULL COMMENT '洗衣程序最大运行分钟数',
  `is_available` tinyint(1) UNSIGNED NOT NULL COMMENT '1：打开/0：关闭，即功能是否可以用',
  `is_editable` tinyint(1) UNSIGNED NOT NULL COMMENT '是否可编辑',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 166 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '洗衣模式' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for washer_property
-- ----------------------------
DROP TABLE IF EXISTS `washer_property`;
CREATE TABLE `washer_property`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `type_id` int(6) UNSIGNED NOT NULL COMMENT '设备类型id',
  `property_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '洗衣参数名称',
  `is_enum` tinyint(1) UNSIGNED NOT NULL COMMENT '该洗衣参数是数值型还是枚举型。1：枚举，0：数值',
  `property_default_value` smallint(5) UNSIGNED NOT NULL COMMENT '该洗衣参数默认值',
  `property_constraint` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '该洗衣参数规则，json格式表示所有枚举值或min/max',
  `property_description` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '该洗衣参数详细说明',
  `is_editable` tinyint(1) UNSIGNED NOT NULL COMMENT '是否可编辑',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '洗衣参数表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Procedure structure for P_TimeoutOrderProcess
-- ----------------------------
DROP PROCEDURE IF EXISTS `P_TimeoutOrderProcess`;
delimiter ;;
CREATE DEFINER=`NeoWay_User`@`%` PROCEDURE `P_TimeoutOrderProcess`()
    COMMENT '根据订单的创建时间,将60s内仍未支付的订单置为过期，并修改相应的设备状态'
BEGIN
	/*这种写法也可以：DECLARE done INT DEFAULT FALSE;*/
	DECLARE done INT DEFAULT FALSE;  /*用于判断是否结束循环*/
	DECLARE orderId INT; /*用于存储结果集的记录*/
	
	/*更新前设备的相关信息*/
	DECLARE deviceId INT; 
	DECLARE deviceState INT;
	DECLARE deviceLastDateChange DateTime;
	
	/*定义游标,取出所有的状态为已下单，并且创建时间超过设备所在的洗衣点的超时时间的订单id*/
	DECLARE idCur CURSOR FOR
		SELECT order_info.id, order_info.device_id, device.state, device.latest_state_update_time
		FROM order_info, device, laundry_point
		WHERE order_info.device_id = device.id AND device.laundry_id = laundry_point.id 
		AND order_info.order_state = 1 AND TIMESTAMPDIFF(SECOND, order_info.date_create, NOW()) > laundry_point.pay_time * 60;
		
	
	/*定义 设置循环结束标识done值怎么改变的逻辑*/
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	open idCur;  /*打开游标*/
	
	/*每60S将设备表中所有为运行态的设备修改为空闲态 TODO
	UPDATE device SET device.state = 1 WHERE device.state = 2;*/

	/* 循环开始 */
	REPEAT
	
		FETCH idCur INTO orderId, deviceId, deviceState, deviceLastDateChange;
		IF NOT done THEN  /*数值为非0，MySQL认为是true*/
		
			/*更新设备表状态为空闲*/
			UPDATE device SET device.latest_state_update_time = NOW() ,device.state = 1 WHERE device.id = deviceId;
			
			/*更新订单为超时状态*/
			UPDATE order_info SET order_info.order_state = 5 WHERE order_info.id = orderId;
			
			/*插入设备历史状态*/
			INSERT INTO device_state_history(device_id, state_id, state_start_time, device_state_history.state_duration)
			VALUES(deviceId, deviceState, deviceLastDateChange, IFNULL(TIMESTAMPDIFF(SECOND, deviceLastDateChange, NOW()), 0));
			
		END IF;
	UNTIL done END REPEAT;

	CLOSE idCur;  /*关闭游标*/
	
END
;;
delimiter ;

-- ----------------------------
-- Event structure for E_TimeoutOrderProcess
-- ----------------------------
DROP EVENT IF EXISTS `E_TimeoutOrderProcess`;
delimiter ;;
CREATE DEFINER = `NeoWay_User`@`%` EVENT `E_TimeoutOrderProcess`
ON SCHEDULE
EVERY '60' SECOND STARTS '2018-08-29 15:08:33'
ON COMPLETION PRESERVE
DO CALL P_TimeoutOrderProcess()
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;

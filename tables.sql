#用户表
DROP TABLE IF EXISTS `user`;
#
# Table structure for table 'user'
#

create table user
(
  `user_id`    int(11) unsigned NOT NULL AUTO_INCREMENT, #数据ID
  `username`   varchar(64) NOT NULL DEFAULT '' COMMENT '用户名',
  `password`    varchar(64) NOT NULL DEFAULT '' COMMENT '密码',
  `tel`    varchar(11) NOT NULL DEFAULT '' COMMENT '手机',
  `email` varchar(256) NOT NULL DEFAULT '' COMMENT '邮箱',
  `location`  varchar(64) NOT NULL DEFAULT '' COMMENT '所在地',
  `avatar`   varchar(256) NOT NULL DEFAULT '' COMMENT '头像',
  `tagline`  text COMMENT '签名',
  `bio`   text COMMENT '个人经历',
  `userlevel`  int unsigned NOT NULL DEFAULT 10 COMMENT '用户等级',
  `createtime`  datetime COMMENT '注册时间',
  `lasttime`  datetime COMMENT '上次访问时间',
  `status`  tinyint(1) DEFAULT 0 COMMENT '状态：0：可用、1禁用',
  `validcode`    varchar(64) NOT NULL DEFAULT '' COMMENT '激活码，用于注册激活',
  `is_validate` tinyint(1) DEFAULT 0 COMMENT '是否已激活：0:未激活，1:已激活',
  `token`    varchar(64) NOT NULL DEFAULT '' COMMENT 'token,用于验证登录',
  primary key (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


#用户表
DROP TABLE IF EXISTS `userlog`;

create table userlog
(
  `id`    int(11) unsigned NOT NULL AUTO_INCREMENT, #数据ID
  `user_id`    int(11) unsigned NOT NULL, #用户id
  `time`  datetime COMMENT '访问时间',
  `type`       tinyint(1) DEFAULT 0 COMMENT '类型：0--登录；1--退出',
  primary key (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#密码重置表
DROP TABLE IF EXISTS `passwordresettoken`;
#
# Table structure for table 'user'
#

create table passwordresettoken
(
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,         #数据id
  `user_id`    int(11) unsigned NOT NULL, #数据ID
  `email` varchar(256) NOT NULL DEFAULT '' COMMENT '邮箱',
  `token` varchar(256) NOT NULL DEFAULT '' COMMENT 'token',
  `valid` tinyint(1) DEFAULT 0 COMMENT '是否有效：0:无效，1:有效',
  `timestamp`  datetime COMMENT '申请密码重置时间',
  primary key (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
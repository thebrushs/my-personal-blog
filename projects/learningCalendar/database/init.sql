-- ============================================
-- 个人学习记录应用数据库表设计
-- 数据库：MySQL 8.0+
-- 字符集：utf8mb4
-- 排序规则：utf8mb4_unicode_ci
-- ============================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS study_record_db 
DEFAULT CHARACTER SET utf8mb4 
DEFAULT COLLATE utf8mb4_unicode_ci;

USE study_record_db;

-- ============================================
-- 1. 用户表（user）
-- ============================================
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '用户唯一标识',
    `openid` VARCHAR(64) DEFAULT NULL COMMENT '微信小程序openid',
    `username` VARCHAR(32) DEFAULT NULL COMMENT 'Web后台登录用户名',
    `password_hash` VARCHAR(255) DEFAULT NULL COMMENT '密码哈希值',
    `salt` VARCHAR(64) DEFAULT NULL COMMENT '密码盐值',
    `login_type` TINYINT NOT NULL DEFAULT 1 COMMENT '登录类型：1-小程序微信登录，2-Web账号密码登录，3-两者都绑定',
    `nickname` VARCHAR(32) DEFAULT NULL COMMENT '用户昵称',
    `avatar` VARCHAR(255) DEFAULT NULL COMMENT '用户头像URL',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `is_delete` TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除：0-未删，1-已删',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_openid` (`openid`),
    UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- ============================================
-- 2. 学习记录表（study_record）
-- ============================================
DROP TABLE IF EXISTS `study_record`;
CREATE TABLE `study_record` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '记录唯一标识',
    `user_id` BIGINT NOT NULL COMMENT '所属用户ID',
    `date` DATE NOT NULL COMMENT '记录日期（YYYY-MM-DD）',
    `title` VARCHAR(128) DEFAULT NULL COMMENT 'AI生成/用户编辑的标题',
    `version` INT NOT NULL DEFAULT 1 COMMENT '数据版本号（乐观锁用）',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `is_delete` TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除：0-未删，1-已删',
    PRIMARY KEY (`id`),
    KEY `idx_user_date` (`user_id`, `date`),
    KEY `idx_user_id` (`user_id`),
    CONSTRAINT `fk_record_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='学习记录表';

-- ============================================
-- 3. 学习内容项表（content_item）
-- ============================================
DROP TABLE IF EXISTS `content_item`;
CREATE TABLE `content_item` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '内容项唯一标识',
    `record_id` BIGINT NOT NULL COMMENT '所属记录ID',
    `type` VARCHAR(16) NOT NULL COMMENT '内容类型：text/code/image/video',
    `content` TEXT COMMENT '内容存储',
    `sort` INT NOT NULL DEFAULT 0 COMMENT '排序序号',
    `language` VARCHAR(16) DEFAULT NULL COMMENT '代码类型-编程语言（Python/Java/JS）',
    `metadata` JSON DEFAULT NULL COMMENT '扩展元数据（图片宽高/视频平台等）',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `is_delete` TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除：0-未删，1-已删',
    PRIMARY KEY (`id`),
    KEY `idx_record_id` (`record_id`),
    CONSTRAINT `fk_item_record` FOREIGN KEY (`record_id`) REFERENCES `study_record` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='学习内容项表';

-- ============================================
-- 4. 操作日志表（operation_log）- 用于离线同步
-- ============================================
DROP TABLE IF EXISTS `operation_log`;
CREATE TABLE `operation_log` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '日志唯一标识',
    `user_id` BIGINT NOT NULL COMMENT '操作用户ID',
    `operation_type` VARCHAR(16) NOT NULL COMMENT '操作类型：create/update/delete',
    `target_table` VARCHAR(32) NOT NULL COMMENT '目标表名',
    `target_id` BIGINT NOT NULL COMMENT '目标记录ID',
    `operation_data` JSON DEFAULT NULL COMMENT '操作数据快照',
    `operation_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
    `sync_status` TINYINT NOT NULL DEFAULT 0 COMMENT '同步状态：0-待同步，1-已同步，2-同步失败',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY `idx_user_sync` (`user_id`, `sync_status`),
    KEY `idx_operation_time` (`operation_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='操作日志表';

-- ============================================
-- 初始化测试数据
-- ============================================

-- 插入测试用户
INSERT INTO `user` (`openid`, `username`, `password_hash`, `salt`, `login_type`, `nickname`, `avatar`) VALUES
('test_openid_001', 'testuser', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EH', 'test_salt_001', 3, '测试用户', 'https://example.com/avatar/default.png');

-- 插入测试学习记录
INSERT INTO `study_record` (`user_id`, `date`, `title`, `version`) VALUES
(1, CURDATE(), '今日学习记录', 1),
(1, DATE_SUB(CURDATE(), INTERVAL 1 DAY), '昨日学习笔记', 1);

-- 插入测试内容项
INSERT INTO `content_item` (`record_id`, `type`, `content`, `sort`, `language`, `metadata`) VALUES
(1, 'text', '<p>今天学习了Vue3的组合式API，了解了ref和reactive的区别。</p>', 1, NULL, NULL),
(1, 'code', 'const count = ref(0)\nconst state = reactive({ name: \"test\" })', 2, 'JS', NULL),
(1, 'image', 'https://example.com/images/screenshot1.png', 3, NULL, '{"width": 1080, "height": 720}'),
(2, 'text', '<p>复习了TypeScript的类型系统，重点学习了泛型。</p>', 1, NULL, NULL);

-- ============================================
-- 创建视图：用户学习记录统计视图
-- ============================================
DROP VIEW IF EXISTS `v_user_study_stats`;
CREATE VIEW `v_user_study_stats` AS
SELECT 
    u.id AS user_id,
    u.nickname,
    COUNT(DISTINCT sr.id) AS total_records,
    COUNT(ci.id) AS total_items,
    SUM(CASE WHEN ci.type = 'text' THEN 1 ELSE 0 END) AS text_count,
    SUM(CASE WHEN ci.type = 'code' THEN 1 ELSE 0 END) AS code_count,
    SUM(CASE WHEN ci.type = 'image' THEN 1 ELSE 0 END) AS image_count,
    SUM(CASE WHEN ci.type = 'video' THEN 1 ELSE 0 END) AS video_count,
    MIN(sr.date) AS first_record_date,
    MAX(sr.date) AS last_record_date
FROM `user` u
LEFT JOIN `study_record` sr ON u.id = sr.user_id AND sr.is_delete = 0
LEFT JOIN `content_item` ci ON sr.id = ci.record_id AND ci.is_delete = 0
WHERE u.is_delete = 0
GROUP BY u.id, u.nickname;

-- ============================================
-- 创建存储过程：获取用户某月学习记录
-- ============================================
DROP PROCEDURE IF EXISTS `sp_get_user_monthly_records`;
DELIMITER //
CREATE PROCEDURE `sp_get_user_monthly_records`(
    IN p_user_id BIGINT,
    IN p_year INT,
    IN p_month INT
)
BEGIN
    SELECT 
        sr.id,
        sr.date,
        sr.title,
        sr.version,
        sr.update_time,
        (SELECT COUNT(*) FROM content_item ci WHERE ci.record_id = sr.id AND ci.is_delete = 0) AS item_count
    FROM study_record sr
    WHERE sr.user_id = p_user_id
      AND sr.is_delete = 0
      AND YEAR(sr.date) = p_year
      AND MONTH(sr.date) = p_month
    ORDER BY sr.date DESC;
END //
DELIMITER ;

-- ============================================
-- 创建存储过程：乐观锁更新学习记录
-- ============================================
DROP PROCEDURE IF EXISTS `sp_update_record_with_version`;
DELIMITER //
CREATE PROCEDURE `sp_update_record_with_version`(
    IN p_record_id BIGINT,
    IN p_user_id BIGINT,
    IN p_title VARCHAR(128),
    IN p_old_version INT,
    OUT p_result INT,
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_current_version INT;
    DECLARE v_affected_rows INT;
    
    SET p_result = 0;
    SET p_message = '';
    
    SELECT version INTO v_current_version 
    FROM study_record 
    WHERE id = p_record_id AND user_id = p_user_id AND is_delete = 0;
    
    IF v_current_version IS NULL THEN
        SET p_result = -1;
        SET p_message = '记录不存在或无权限';
    ELSEIF v_current_version != p_old_version THEN
        SET p_result = -2;
        SET p_message = '数据已更新，请刷新后重试';
    ELSE
        UPDATE study_record 
        SET title = p_title, version = version + 1
        WHERE id = p_record_id AND user_id = p_user_id AND version = p_old_version;
        
        SET v_affected_rows = ROW_COUNT();
        IF v_affected_rows > 0 THEN
            SET p_result = 1;
            SET p_message = '更新成功';
        ELSE
            SET p_result = -3;
            SET p_message = '更新失败，请重试';
        END IF;
    END IF;
END //
DELIMITER ;

-- ============================================
-- 创建索引优化建议
-- ============================================
-- 以下索引根据实际查询情况动态添加
-- ALTER TABLE `study_record` ADD INDEX `idx_date` (`date`);
-- ALTER TABLE `content_item` ADD INDEX `idx_type` (`type`);

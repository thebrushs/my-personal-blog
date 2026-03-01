const mysql = require('mysql2/promise');

async function initDatabase() {
    const connection = await mysql.createConnection({
        host: 'localhost',
        user: 'root',
        password: '123456',
        multipleStatements: true
    });

    console.log('Connected to MySQL successfully!');

    await connection.query(`CREATE DATABASE IF NOT EXISTS study_record_db DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci`);
    console.log('Database created!');

    await connection.changeUser({ database: 'study_record_db' });

    await connection.query(`DROP TABLE IF EXISTS content_item`);
    await connection.query(`DROP TABLE IF EXISTS operation_log`);
    await connection.query(`DROP TABLE IF EXISTS study_record`);
    await connection.query(`DROP TABLE IF EXISTS user`);

    await connection.query(`
        CREATE TABLE user (
            id BIGINT NOT NULL AUTO_INCREMENT COMMENT '用户唯一标识',
            openid VARCHAR(64) DEFAULT NULL COMMENT '微信小程序openid',
            username VARCHAR(32) DEFAULT NULL COMMENT 'Web后台登录用户名',
            password_hash VARCHAR(255) DEFAULT NULL COMMENT '密码哈希值',
            salt VARCHAR(64) DEFAULT NULL COMMENT '密码盐值',
            login_type TINYINT NOT NULL DEFAULT 1 COMMENT '登录类型',
            nickname VARCHAR(32) DEFAULT NULL COMMENT '用户昵称',
            avatar VARCHAR(255) DEFAULT NULL COMMENT '用户头像URL',
            create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
            update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
            is_delete TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
            PRIMARY KEY (id),
            UNIQUE KEY uk_openid (openid),
            UNIQUE KEY uk_username (username)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表'
    `);
    console.log('User table created!');

    await connection.query(`
        CREATE TABLE study_record (
            id BIGINT NOT NULL AUTO_INCREMENT COMMENT '记录唯一标识',
            user_id BIGINT NOT NULL COMMENT '所属用户ID',
            date DATE NOT NULL COMMENT '记录日期',
            title VARCHAR(128) DEFAULT NULL COMMENT '标题',
            version INT NOT NULL DEFAULT 1 COMMENT '数据版本号',
            create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
            update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
            is_delete TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
            PRIMARY KEY (id),
            KEY idx_user_date (user_id, date),
            KEY idx_user_id (user_id),
            CONSTRAINT fk_record_user FOREIGN KEY (user_id) REFERENCES user (id) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='学习记录表'
    `);
    console.log('Study_record table created!');

    await connection.query(`
        CREATE TABLE content_item (
            id BIGINT NOT NULL AUTO_INCREMENT COMMENT '内容项唯一标识',
            record_id BIGINT NOT NULL COMMENT '所属记录ID',
            type VARCHAR(16) NOT NULL COMMENT '内容类型',
            content TEXT COMMENT '内容存储',
            sort INT NOT NULL DEFAULT 0 COMMENT '排序序号',
            language VARCHAR(16) DEFAULT NULL COMMENT '代码类型',
            metadata JSON DEFAULT NULL COMMENT '扩展元数据',
            create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
            update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
            is_delete TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
            PRIMARY KEY (id),
            KEY idx_record_id (record_id),
            CONSTRAINT fk_item_record FOREIGN KEY (record_id) REFERENCES study_record (id) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='学习内容项表'
    `);
    console.log('Content_item table created!');

    await connection.query(`
        CREATE TABLE operation_log (
            id BIGINT NOT NULL AUTO_INCREMENT COMMENT '日志唯一标识',
            user_id BIGINT NOT NULL COMMENT '操作用户ID',
            operation_type VARCHAR(16) NOT NULL COMMENT '操作类型',
            target_table VARCHAR(32) NOT NULL COMMENT '目标表名',
            target_id BIGINT NOT NULL COMMENT '目标记录ID',
            operation_data JSON DEFAULT NULL COMMENT '操作数据快照',
            operation_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
            sync_status TINYINT NOT NULL DEFAULT 0 COMMENT '同步状态',
            create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
            PRIMARY KEY (id),
            KEY idx_user_sync (user_id, sync_status),
            KEY idx_operation_time (operation_time)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='操作日志表'
    `);
    console.log('Operation_log table created!');

    await connection.query(`
        INSERT INTO user (openid, username, password_hash, salt, login_type, nickname, avatar) VALUES
        ('test_openid_001', 'testuser', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EH', 'test_salt_001', 3, '测试用户', 'https://example.com/avatar/default.png')
    `);
    console.log('Test user inserted!');

    await connection.end();
    console.log('\nDatabase initialized successfully!');
}

initDatabase().catch(err => {
    console.error('Error:', err.message);
    process.exit(1);
});

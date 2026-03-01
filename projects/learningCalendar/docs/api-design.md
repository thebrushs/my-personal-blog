# 个人学习记录应用 - 服务端接口设计文档

## 一、接口概述

### 1.1 基础信息

- **基础URL**: `https://api.example.com/api/v1`
- **协议**: HTTPS
- **数据格式**: JSON
- **字符编码**: UTF-8
- **版本**: v1

### 1.2 通用响应格式

```json
{
    "code": 200,
    "message": "success",
    "data": {},
    "timestamp": 1700000000000
}
```

### 1.3 错误码定义

| 错误码 | 说明 |
|--------|------|
| 200 | 成功 |
| 400 | 请求参数错误 |
| 401 | 未登录或登录已过期 |
| 403 | 无权限访问 |
| 404 | 资源不存在 |
| 409 | 数据冲突（版本不匹配） |
| 429 | 请求频率过高 |
| 500 | 服务器内部错误 |
| 503 | 服务暂不可用 |

### 1.4 认证方式

- **小程序端**: 使用微信登录获取的 `token` 放入请求头 `Authorization: Bearer {token}`
- **Web后台**: 使用账号密码登录获取的 `token` 放入请求头 `Authorization: Bearer {token}`

---

## 二、用户模块接口

### 2.1 微信小程序登录

**接口路径**: `POST /auth/wechat/login`

**请求参数**:
```json
{
    "code": "微信登录code",
    "nickname": "用户昵称",
    "avatar": "用户头像URL"
}
```

**响应示例**:
```json
{
    "code": 200,
    "message": "登录成功",
    "data": {
        "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
        "tokenExpire": 1700086400000,
        "user": {
            "id": 1,
            "openid": "oXXXXXX",
            "nickname": "用户昵称",
            "avatar": "https://example.com/avatar.png",
            "loginType": 1
        }
    }
}
```

### 2.2 Web后台登录

**接口路径**: `POST /auth/web/login`

**请求参数**:
```json
{
    "username": "用户名",
    "password": "密码"
}
```

**响应示例**:
```json
{
    "code": 200,
    "message": "登录成功",
    "data": {
        "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
        "tokenExpire": 1700086400000,
        "user": {
            "id": 1,
            "username": "testuser",
            "nickname": "用户昵称",
            "avatar": "https://example.com/avatar.png",
            "loginType": 2
        }
    }
}
```

### 2.3 获取用户信息

**接口路径**: `GET /user/info`

**请求头**: `Authorization: Bearer {token}`

**响应示例**:
```json
{
    "code": 200,
    "message": "success",
    "data": {
        "id": 1,
        "openid": "oXXXXXX",
        "username": "testuser",
        "nickname": "用户昵称",
        "avatar": "https://example.com/avatar.png",
        "loginType": 3,
        "createTime": "2024-01-01 10:00:00"
    }
}
```

### 2.4 更新用户信息

**接口路径**: `PUT /user/info`

**请求头**: `Authorization: Bearer {token}`

**请求参数**:
```json
{
    "nickname": "新昵称",
    "avatar": "https://example.com/new-avatar.png"
}
```

---

## 三、学习记录模块接口

### 3.1 获取用户某月学习记录列表

**接口路径**: `GET /records/monthly`

**请求头**: `Authorization: Bearer {token}`

**请求参数**:
| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| year | int | 是 | 年份，如2024 |
| month | int | 是 | 月份，1-12 |

**响应示例**:
```json
{
    "code": 200,
    "message": "success",
    "data": {
        "year": 2024,
        "month": 1,
        "records": [
            {
                "id": 1,
                "date": "2024-01-15",
                "title": "Vue3组合式API学习",
                "version": 1,
                "itemCount": 3,
                "updateTime": "2024-01-15 18:30:00"
            },
            {
                "id": 2,
                "date": "2024-01-14",
                "title": "TypeScript泛型复习",
                "version": 2,
                "itemCount": 2,
                "updateTime": "2024-01-14 20:15:00"
            }
        ],
        "total": 2
    }
}
```

### 3.2 获取单条学习记录详情

**接口路径**: `GET /records/{recordId}`

**请求头**: `Authorization: Bearer {token}`

**路径参数**:
| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| recordId | long | 是 | 记录ID |

**响应示例**:
```json
{
    "code": 200,
    "message": "success",
    "data": {
        "id": 1,
        "date": "2024-01-15",
        "title": "Vue3组合式API学习",
        "version": 1,
        "createTime": "2024-01-15 10:00:00",
        "updateTime": "2024-01-15 18:30:00",
        "items": [
            {
                "id": 1,
                "type": "text",
                "content": "<p>今天学习了Vue3的组合式API</p>",
                "sort": 1,
                "metadata": null
            },
            {
                "id": 2,
                "type": "code",
                "content": "const count = ref(0)",
                "sort": 2,
                "language": "JS",
                "metadata": null
            },
            {
                "id": 3,
                "type": "image",
                "content": "https://oss.example.com/images/xxx.png",
                "sort": 3,
                "metadata": {
                    "width": 1080,
                    "height": 720
                }
            }
        ]
    }
}
```

### 3.3 创建学习记录

**接口路径**: `POST /records`

**请求头**: `Authorization: Bearer {token}`

**请求参数**:
```json
{
    "date": "2024-01-15",
    "title": "今日学习记录",
    "items": [
        {
            "type": "text",
            "content": "<p>学习内容描述</p>",
            "sort": 1
        },
        {
            "type": "code",
            "content": "console.log('hello')",
            "sort": 2,
            "language": "JS"
        },
        {
            "type": "image",
            "content": "https://oss.example.com/images/xxx.png",
            "sort": 3,
            "metadata": {
                "width": 1080,
                "height": 720
            }
        }
    ]
}
```

**响应示例**:
```json
{
    "code": 200,
    "message": "创建成功",
    "data": {
        "id": 3,
        "date": "2024-01-15",
        "title": "今日学习记录",
        "version": 1,
        "createTime": "2024-01-15 10:00:00"
    }
}
```

### 3.4 更新学习记录

**接口路径**: `PUT /records/{recordId}`

**请求头**: `Authorization: Bearer {token}`

**路径参数**:
| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| recordId | long | 是 | 记录ID |

**请求参数**:
```json
{
    "title": "更新后的标题",
    "version": 1,
    "items": [
        {
            "id": 1,
            "type": "text",
            "content": "<p>更新后的内容</p>",
            "sort": 1
        },
        {
            "type": "code",
            "content": "const updated = true",
            "sort": 2,
            "language": "JS"
        }
    ]
}
```

**响应示例（成功）**:
```json
{
    "code": 200,
    "message": "更新成功",
    "data": {
        "id": 1,
        "version": 2,
        "updateTime": "2024-01-15 20:00:00"
    }
}
```

**响应示例（版本冲突）**:
```json
{
    "code": 409,
    "message": "数据已更新，请刷新后重试",
    "data": {
        "currentVersion": 2,
        "yourVersion": 1
    }
}
```

### 3.5 删除学习记录

**接口路径**: `DELETE /records/{recordId}`

**请求头**: `Authorization: Bearer {token}`

**路径参数**:
| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| recordId | long | 是 | 记录ID |

**响应示例**:
```json
{
    "code": 200,
    "message": "删除成功",
    "data": null
}
```

---

## 四、内容项模块接口

### 4.1 添加内容项

**接口路径**: `POST /records/{recordId}/items`

**请求头**: `Authorization: Bearer {token}`

**路径参数**:
| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| recordId | long | 是 | 记录ID |

**请求参数**:
```json
{
    "type": "code",
    "content": "function hello() { return 'world'; }",
    "sort": 3,
    "language": "JS"
}
```

### 4.2 更新内容项

**接口路径**: `PUT /items/{itemId}`

**请求头**: `Authorization: Bearer {token}`

**请求参数**:
```json
{
    "content": "更新后的内容",
    "sort": 2
}
```

### 4.3 删除内容项

**接口路径**: `DELETE /items/{itemId}`

**请求头**: `Authorization: Bearer {token}`

### 4.4 批量更新内容项排序

**接口路径**: `PUT /records/{recordId}/items/sort`

**请求头**: `Authorization: Bearer {token}`

**请求参数**:
```json
{
    "items": [
        { "id": 1, "sort": 2 },
        { "id": 2, "sort": 1 },
        { "id": 3, "sort": 3 }
    ]
}
```

---

## 五、文件上传模块接口

### 5.1 上传图片

**接口路径**: `POST /upload/image`

**请求头**: 
- `Authorization: Bearer {token}`
- `Content-Type: multipart/form-data`

**请求参数**:
| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| file | file | 是 | 图片文件，支持JPG/PNG/GIF格式，最大5MB |

**响应示例**:
```json
{
    "code": 200,
    "message": "上传成功",
    "data": {
        "url": "https://oss.example.com/images/2024/01/15/xxx.png",
        "width": 1080,
        "height": 720,
        "size": 102400
    }
}
```

**错误响应（格式不支持）**:
```json
{
    "code": 400,
    "message": "不支持的图片格式，仅支持JPG/PNG/GIF",
    "data": null
}
```

**错误响应（文件过大）**:
```json
{
    "code": 400,
    "message": "图片大小超过限制，最大支持5MB",
    "data": null
}
```

---

## 六、AI标题生成模块接口

### 6.1 生成标题

**接口路径**: `POST /ai/generate-title`

**请求头**: `Authorization: Bearer {token}`

**请求参数**:
```json
{
    "imageUrl": "https://oss.example.com/images/xxx.png",
    "textContent": "今天学习了Vue3的组合式API"
}
```

**说明**: `imageUrl` 和 `textContent` 至少提供一个

**响应示例（成功）**:
```json
{
    "code": 200,
    "message": "生成成功",
    "data": {
        "title": "Vue3组合式API学习笔记"
    }
}
```

**响应示例（超时/失败）**:
```json
{
    "code": 200,
    "message": "使用默认标题",
    "data": {
        "title": "学习记录 2024-01-15"
    }
}
```

---

## 七、数据同步模块接口

### 7.1 获取同步状态

**接口路径**: `GET /sync/status`

**请求头**: `Authorization: Bearer {token}`

**响应示例**:
```json
{
    "code": 200,
    "message": "success",
    "data": {
        "lastSyncTime": "2024-01-15 18:30:00",
        "pendingCount": 2,
        "pendingOperations": [
            {
                "id": 101,
                "operationType": "create",
                "targetTable": "study_record",
                "operationTime": "2024-01-15 18:00:00"
            }
        ]
    }
}
```

### 7.2 批量同步操作

**接口路径**: `POST /sync/batch`

**请求头**: `Authorization: Bearer {token}`

**请求参数**:
```json
{
    "operations": [
        {
            "localId": "local_001",
            "operationType": "create",
            "targetTable": "study_record",
            "operationData": {
                "date": "2024-01-15",
                "title": "离线创建的记录"
            },
            "operationTime": "2024-01-15 10:00:00"
        },
        {
            "localId": "local_002",
            "operationType": "update",
            "targetTable": "study_record",
            "targetId": 1,
            "operationData": {
                "title": "更新后的标题"
            },
            "version": 1,
            "operationTime": "2024-01-15 11:00:00"
        }
    ]
}
```

**响应示例**:
```json
{
    "code": 200,
    "message": "同步完成",
    "data": {
        "successCount": 1,
        "failCount": 1,
        "results": [
            {
                "localId": "local_001",
                "success": true,
                "serverId": 5,
                "message": "创建成功"
            },
            {
                "localId": "local_002",
                "success": false,
                "message": "版本冲突，请刷新后重试",
                "currentVersion": 2
            }
        ]
    }
}
```

---

## 八、数据统计模块接口

### 8.1 获取用户学习统计

**接口路径**: `GET /stats/overview`

**请求头**: `Authorization: Bearer {token}`

**响应示例**:
```json
{
    "code": 200,
    "message": "success",
    "data": {
        "totalRecords": 30,
        "totalItems": 85,
        "itemTypeStats": {
            "text": 40,
            "code": 25,
            "image": 15,
            "video": 5
        },
        "firstRecordDate": "2023-06-01",
        "lastRecordDate": "2024-01-15",
        "continuousDays": 7,
        "monthlyStats": [
            { "month": "2024-01", "recordCount": 15, "itemCount": 40 },
            { "month": "2023-12", "recordCount": 12, "itemCount": 35 }
        ]
    }
}
```

### 8.2 获取学习热度图数据

**接口路径**: `GET /stats/heatmap`

**请求头**: `Authorization: Bearer {token}`

**请求参数**:
| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| year | int | 是 | 年份 |

**响应示例**:
```json
{
    "code": 200,
    "message": "success",
    "data": {
        "year": 2024,
        "heatmap": [
            { "date": "2024-01-01", "count": 2 },
            { "date": "2024-01-02", "count": 0 },
            { "date": "2024-01-03", "count": 1 },
            { "date": "2024-01-15", "count": 3 }
        ]
    }
}
```

---

## 九、数据导出模块接口

### 9.1 导出学习记录

**接口路径**: `GET /export/records`

**请求头**: `Authorization: Bearer {token}`

**请求参数**:
| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| format | string | 是 | 导出格式：excel/json |
| startDate | date | 否 | 开始日期 |
| endDate | date | 否 | 结束日期 |
| types | string | 否 | 内容类型，多个用逗号分隔 |

**响应**: 文件下载流

---

## 十、接口限流策略

| 接口类型 | 限流规则 |
|----------|----------|
| 登录接口 | 同一IP每分钟最多10次 |
| 普通查询 | 同一用户每秒最多10次 |
| 写入操作 | 同一用户每秒最多5次 |
| 图片上传 | 同一用户每分钟最多20次 |
| AI标题生成 | 同一用户每分钟最多10次 |

---

## 十一、接口版本管理

- **当前版本**: v1
- **版本策略**: 新版本上线后，旧版本至少保留3个月
- **版本切换**: 通过URL路径区分，如 `/api/v1/`, `/api/v2/`

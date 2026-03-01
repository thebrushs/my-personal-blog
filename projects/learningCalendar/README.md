# 个人学习记录应用

一款以微信小程序为核心展示端、Web页面为管理后台的轻量化个人学习记录工具。

## 项目结构

```
ThirdCode/
├── packages/
│   ├── server/          # 服务端 (Node.js + Express + TypeScript)
│   ├── web-admin/       # Web管理后台 (Vue3 + Element Plus)
│   └── miniprogram/     # 微信小程序
├── database/            # 数据库脚本
│   └── init.sql         # 数据库初始化脚本
├── docs/                # 文档
│   └── api-design.md    # 接口设计文档
└── package.json         # Monorepo配置
```

## 技术栈

### 服务端
- Node.js 18+
- Express + TypeScript
- MySQL 8.0+
- Redis
- JWT认证

### Web管理后台
- Vue 3 + TypeScript
- Element Plus
- ECharts
- Pinia

### 微信小程序
- 微信原生小程序框架
- Vant Weapp (可选)

## 快速开始

### 1. 安装依赖

```bash
npm install
```

### 2. 初始化数据库

```bash
mysql -u root -p < database/init.sql
```

### 3. 配置环境变量

复制 `packages/server/.env.example` 为 `packages/server/.env` 并填写配置：

```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
JWT_SECRET=your_secret
WECHAT_APPID=your_appid
WECHAT_SECRET=your_secret
```

### 4. 启动服务

```bash
# 启动服务端
npm run server

# 启动Web后台
npm run web
```

### 5. 微信小程序配置

1. 在微信开发者工具中导入 `packages/miniprogram` 目录
2. 修改 `project.config.json` 中的 `appid`
3. 修改 `app.js` 中的 `baseUrl` 为你的服务端地址

## 功能模块

### 微信小程序端
- 微信授权登录
- 日历视图展示
- 学习记录编辑（文字/代码/图片）
- AI标题生成
- 离线数据同步

### Web管理后台
- 账号密码登录
- 数据概览统计
- 记录管理（查询/编辑/删除）
- 数据可视化图表

## API文档

详细的接口文档请查看 [docs/api-design.md](docs/api-design.md)

## 开发计划

- [x] 数据库表设计
- [x] 服务端核心接口
- [x] Web管理后台
- [x] 微信小程序基础功能
- [ ] 图片上传OSS集成
- [ ] AI标题生成集成
- [ ] 离线同步完善
- [ ] 单元测试

## License

MIT

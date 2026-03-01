<template>
  <div class="layout">
    <!-- 侧边栏 -->
    <aside class="sidebar">
      <div class="sidebar-header">
        <h2>电商管理系统</h2>
      </div>
      <nav class="sidebar-nav">
        <ul>
          <li>
            <router-link to="/">
              <i class="icon">📊</i>
              <span>仪表盘</span>
            </router-link>
          </li>
          <li>
            <router-link to="/products">
              <i class="icon">📦</i>
              <span>商品管理</span>
            </router-link>
          </li>
          <li>
            <router-link to="/categories">
              <i class="icon">📁</i>
              <span>分类管理</span>
            </router-link>
          </li>
          <li>
            <router-link to="/orders">
              <i class="icon">📋</i>
              <span>订单管理</span>
            </router-link>
          </li>
          <li>
            <router-link to="/users">
              <i class="icon">👥</i>
              <span>用户管理</span>
            </router-link>
          </li>
        </ul>
      </nav>
    </aside>

    <!-- 主内容区 -->
    <main class="main-content">
      <!-- 顶部栏 -->
      <header class="top-bar">
        <div class="top-bar-left">
          <button class="menu-toggle" @click="toggleMenu">
            ☰
          </button>
        </div>
        <div class="top-bar-right">
          <div class="user-info">
            <span>管理员</span>
            <img src="https://via.placeholder.com/32" alt="用户头像" class="user-avatar">
          </div>
        </div>
      </header>

      <!-- 页面内容 -->
      <div class="page-content">
        <slot></slot>
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const isMenuOpen = ref(true)

const toggleMenu = () => {
  isMenuOpen.value = !isMenuOpen.value
}
</script>

<style scoped>
.layout {
  display: flex;
  height: 100vh;
  overflow: hidden;
}

.sidebar {
  width: 250px;
  background-color: #2c7a7b;
  color: white;
  transition: width 0.3s ease;
  overflow-y: auto;
}

.sidebar-header {
  padding: 20px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.sidebar-header h2 {
  margin: 0;
  font-size: 1.2rem;
}

.sidebar-nav {
  padding: 20px 0;
}

.sidebar-nav ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.sidebar-nav li {
  margin: 0;
}

.sidebar-nav a {
  display: flex;
  align-items: center;
  padding: 12px 20px;
  color: white;
  text-decoration: none;
  transition: background-color 0.3s ease;
}

.sidebar-nav a:hover {
  background-color: rgba(255, 255, 255, 0.1);
}

.sidebar-nav .icon {
  margin-right: 10px;
  font-size: 1.2rem;
}

.main-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  background-color: #f5f5f5;
}

.top-bar {
  background-color: white;
  padding: 0 20px;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.menu-toggle {
  background: none;
  border: none;
  font-size: 1.5rem;
  cursor: pointer;
  padding: 5px;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 10px;
}

.user-avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
}

.page-content {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .sidebar {
    position: fixed;
    left: 0;
    top: 0;
    height: 100vh;
    z-index: 1000;
    transform: translateX(-100%);
  }

  .sidebar.open {
    transform: translateX(0);
  }
}
</style>
<template>
  <div class="users">
    <h1>用户管理</h1>
    <table class="user-table">
      <thead>
        <tr>
          <th>ID</th>
          <th>用户名</th>
          <th>角色</th>
          <th>操作</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="user in users" :key="user.id">
          <td>{{ user.id }}</td>
          <td>{{ user.username }}</td>
          <td>{{ user.role }}</td>
          <td>
            <button>编辑权限</button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup lang="ts">
interface User {
  id: number;
  username: string;
  role: string;
}

const users: User[] = [
  {
    id: 1,
    username: 'admin',
    role: '管理员'
  },
  {
    id: 2,
    username: 'editor',
    role: '编辑'
  },
  {
    id: 3,
    username: 'viewer',
    role: '查看者'
  }
]
</script>

<style scoped>
.users {
  padding: 20px;
}

.user-table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 20px;
}

.user-table th,
.user-table td {
  padding: 10px;
  border: 1px solid #ddd;
  text-align: left;
}

.user-table th {
  background-color: #f5f5f5;
}

button {
  padding: 5px 10px;
  border: none;
  border-radius: 4px;
  background: #4fd1c5;
  color: white;
  cursor: pointer;
}
</style>
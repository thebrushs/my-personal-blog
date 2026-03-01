<template>
  <div class="categories">
    <div class="page-header">
      <h1>分类管理</h1>
      <button class="btn-primary" @click="showAddModal = true">添加分类</button>
    </div>

    <div class="categories-table">
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>分类名称</th>
            <th>描述</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="category in categories" :key="category.id">
            <td>{{ category.id }}</td>
            <td>{{ category.name }}</td>
            <td>{{ category.description }}</td>
            <td>
              <button class="btn-edit" @click="editCategory(category)">编辑</button>
              <button class="btn-delete" @click="deleteCategory(category.id)">删除</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- 添加/编辑分类模态框 -->
    <div v-if="showAddModal || showEditModal" class="modal-overlay">
      <div class="modal">
        <div class="modal-header">
          <h2>{{ showEditModal ? '编辑分类' : '添加分类' }}</h2>
          <button class="modal-close" @click="closeModal">&times;</button>
        </div>
        <div class="modal-body">
          <form @submit.prevent="saveCategory">
            <div class="form-group">
              <label for="category-name">分类名称</label>
              <input 
                type="text" 
                id="category-name" 
                v-model="formData.name" 
                required
              >
            </div>
            <div class="form-group">
              <label for="category-description">描述</label>
              <textarea 
                id="category-description" 
                v-model="formData.description"
                rows="3"
              ></textarea>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn-secondary" @click="closeModal">取消</button>
              <button type="submit" class="btn-primary">保存</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

interface Category {
  id: number;
  name: string;
  description: string;
}

const categories = ref<Category[]>([
  {
    id: 1,
    name: '电子产品',
    description: '各种电子设备和数码产品'
  },
  {
    id: 2,
    name: '服装鞋包',
    description: '时尚服装和配饰'
  },
  {
    id: 3,
    name: '家居用品',
    description: '家庭生活用品'
  }
])

const showAddModal = ref(false)
const showEditModal = ref(false)
const formData = ref<Category>({
  id: 0,
  name: '',
  description: ''
})

const editCategory = (category: Category) => {
  formData.value = { ...category }
  showEditModal.value = true
}

const deleteCategory = (id: number) => {
  if (confirm('确定要删除这个分类吗？')) {
    categories.value = categories.value.filter(cat => cat.id !== id)
  }
}

const saveCategory = () => {
  if (showEditModal.value) {
    // 编辑现有分类
    const index = categories.value.findIndex(cat => cat.id === formData.value.id)
    if (index !== -1) {
      categories.value[index] = { ...formData.value }
    }
  } else {
    // 添加新分类
    const newCategory: Category = {
      id: Math.max(...categories.value.map(cat => cat.id)) + 1,
      name: formData.value.name,
      description: formData.value.description
    }
    categories.value.push(newCategory)
  }
  closeModal()
}

const closeModal = () => {
  showAddModal.value = false
  showEditModal.value = false
  formData.value = {
    id: 0,
    name: '',
    description: ''
  }
}
</script>

<style scoped>
.categories {
  padding: 20px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.page-header h1 {
  color: #2c7a7b;
}

.btn-primary {
  background-color: #4fd1c5;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
}

.btn-primary:hover {
  background-color: #38b2ac;
}

.categories-table {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  overflow: hidden;
}

.categories-table table {
  width: 100%;
  border-collapse: collapse;
}

.categories-table th,
.categories-table td {
  padding: 12px 15px;
  text-align: left;
  border-bottom: 1px solid #e2e8f0;
}

.categories-table th {
  background-color: #f7fafc;
  font-weight: 600;
  color: #2d3748;
}

.categories-table tr:hover {
  background-color: #f7fafc;
}

.btn-edit {
  background-color: #4fd1c5;
  color: white;
  border: none;
  padding: 5px 10px;
  border-radius: 4px;
  cursor: pointer;
  margin-right: 5px;
}

.btn-delete {
  background-color: #e53e3e;
  color: white;
  border: none;
  padding: 5px 10px;
  border-radius: 4px;
  cursor: pointer;
}

/* 模态框样式 */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal {
  background-color: white;
  border-radius: 8px;
  width: 90%;
  max-width: 500px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid #e2e8f0;
}

.modal-header h2 {
  margin: 0;
  color: #2c7a7b;
}

.modal-close {
  background: none;
  border: none;
  font-size: 24px;
  cursor: pointer;
  color: #718096;
}

.modal-body {
  padding: 20px;
}

.form-group {
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
  font-weight: 500;
  color: #2d3748;
}

.form-group input,
.form-group textarea {
  width: 100%;
  padding: 10px;
  border: 1px solid #e2e8f0;
  border-radius: 4px;
  font-size: 14px;
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding: 20px;
  border-top: 1px solid #e2e8f0;
  margin-top: 10px;
}

.btn-secondary {
  background-color: #e2e8f0;
  color: #2d3748;
  border: none;
  padding: 10px 20px;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
}

.btn-secondary:hover {
  background-color: #cbd5e0;
}
</style>
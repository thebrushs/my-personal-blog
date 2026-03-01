<template>
  <div class="products">
    <div class="page-header">
      <h1>商品管理</h1>
      <button class="btn-primary" @click="showAddModal = true">添加商品</button>
    </div>

    <div class="product-list">
      <div class="product-item" v-for="product in products" :key="product.id">
        <img :src="product.image" alt="商品图片" class="product-image">
        <h3>{{ product.name }}</h3>
        <p>{{ product.description }}</p>
        <p class="product-price">价格: ¥{{ product.price }}</p>
        <p class="product-category">分类: {{ product.category }}</p>
        <div class="product-actions">
          <button class="btn-edit" @click="editProduct(product)">编辑</button>
          <button class="btn-delete" @click="deleteProduct(product.id)">删除</button>
        </div>
      </div>
    </div>

    <!-- 添加/编辑商品模态框 -->
    <div v-if="showAddModal || showEditModal" class="modal-overlay">
      <div class="modal">
        <div class="modal-header">
          <h2>{{ showEditModal ? '编辑商品' : '添加商品' }}</h2>
          <button class="modal-close" @click="closeModal">&times;</button>
        </div>
        <div class="modal-body">
          <form @submit.prevent="saveProduct">
            <div class="form-group">
              <label for="product-name">商品名称</label>
              <input 
                type="text" 
                id="product-name" 
                v-model="formData.name" 
                required
              >
            </div>
            <div class="form-group">
              <label for="product-description">描述</label>
              <textarea 
                id="product-description" 
                v-model="formData.description"
                rows="3"
              ></textarea>
            </div>
            <div class="form-group">
              <label for="product-price">价格</label>
              <input 
                type="number" 
                id="product-price" 
                v-model.number="formData.price" 
                required
                min="0"
                step="0.01"
              >
            </div>
            <div class="form-group">
              <label for="product-category">分类</label>
              <select 
                id="product-category" 
                v-model="formData.category"
                required
              >
                <option value="">请选择分类</option>
                <option value="电子产品">电子产品</option>
                <option value="服装鞋包">服装鞋包</option>
                <option value="家居用品">家居用品</option>
              </select>
            </div>
            <div class="form-group">
              <label for="product-image">图片URL</label>
              <input 
                type="text" 
                id="product-image" 
                v-model="formData.image"
                placeholder="https://via.placeholder.com/200"
              >
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

interface Product {
  id: number;
  name: string;
  description: string;
  price: number;
  category: string;
  image: string;
}

const products = ref<Product[]>([
  {
    id: 1,
    name: '智能手机',
    description: '最新款智能手机，搭载高性能处理器',
    price: 3999,
    category: '电子产品',
    image: 'https://via.placeholder.com/200'
  },
  {
    id: 2,
    name: '运动鞋',
    description: '舒适透气的运动鞋，适合日常穿着',
    price: 599,
    category: '服装鞋包',
    image: 'https://via.placeholder.com/200'
  },
  {
    id: 3,
    name: '智能台灯',
    description: '可调光智能台灯，支持语音控制',
    price: 299,
    category: '家居用品',
    image: 'https://via.placeholder.com/200'
  }
])

const showAddModal = ref(false)
const showEditModal = ref(false)
const formData = ref<Product>({
  id: 0,
  name: '',
  description: '',
  price: 0,
  category: '',
  image: 'https://via.placeholder.com/200'
})

const editProduct = (product: Product) => {
  formData.value = { ...product }
  showEditModal.value = true
}

const deleteProduct = (id: number) => {
  if (confirm('确定要删除这个商品吗？')) {
    products.value = products.value.filter(p => p.id !== id)
  }
}

const saveProduct = () => {
  if (showEditModal.value) {
    // 编辑现有商品
    const index = products.value.findIndex(p => p.id === formData.value.id)
    if (index !== -1) {
      products.value[index] = { ...formData.value }
    }
  } else {
    // 添加新商品
    const newProduct: Product = {
      id: Math.max(...products.value.map(p => p.id)) + 1,
      name: formData.value.name,
      description: formData.value.description,
      price: formData.value.price,
      category: formData.value.category,
      image: formData.value.image
    }
    products.value.push(newProduct)
  }
  closeModal()
}

const closeModal = () => {
  showAddModal.value = false
  showEditModal.value = false
  formData.value = {
    id: 0,
    name: '',
    description: '',
    price: 0,
    category: '',
    image: 'https://via.placeholder.com/200'
  }
}
</script>

<style scoped>
.products {
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

.product-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
  margin-top: 20px;
}

.product-item {
  background: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.product-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.product-image {
  width: 100%;
  height: 200px;
  object-fit: cover;
  border-radius: 4px;
  margin-bottom: 15px;
}

.product-item h3 {
  margin-bottom: 10px;
  color: #2d3748;
}

.product-item p {
  margin-bottom: 10px;
  color: #718096;
  font-size: 14px;
}

.product-price {
  font-weight: 600;
  color: #2c7a7b;
  font-size: 16px;
}

.product-category {
  font-size: 12px;
  background-color: #e6fffa;
  color: #2c7a7b;
  padding: 2px 8px;
  border-radius: 10px;
  display: inline-block;
  margin-bottom: 15px;
}

.product-actions {
  margin-top: 10px;
  display: flex;
  gap: 10px;
}

.btn-edit {
  background-color: #4fd1c5;
  color: white;
  border: none;
  padding: 8px 16px;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
}

.btn-delete {
  background-color: #e53e3e;
  color: white;
  border: none;
  padding: 8px 16px;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
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
.form-group textarea,
.form-group select {
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
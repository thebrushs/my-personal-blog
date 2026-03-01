<template>
  <div class="orders">
    <h1>订单管理</h1>
    <table class="order-table">
      <thead>
        <tr>
          <th>订单号</th>
          <th>客户</th>
          <th>金额</th>
          <th>状态</th>
          <th>操作</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="order in orders" :key="order.id">
          <td>{{ order.id }}</td>
          <td>{{ order.customer }}</td>
          <td>¥{{ order.amount }}</td>
          <td>{{ order.status }}</td>
          <td>
            <button>查看</button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup lang="ts">
interface Order {
  id: string;
  customer: string;
  amount: number;
  status: string;
}

const orders: Order[] = [
  {
    id: '20260301001',
    customer: '张三',
    amount: 199,
    status: '已完成'
  },
  {
    id: '20260301002',
    customer: '李四',
    amount: 299,
    status: '处理中'
  },
  {
    id: '20260301003',
    customer: '王五',
    amount: 399,
    status: '待付款'
  }
]
</script>

<style scoped>
.orders {
  padding: 20px;
}

.order-table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 20px;
}

.order-table th,
.order-table td {
  padding: 10px;
  border: 1px solid #ddd;
  text-align: left;
}

.order-table th {
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
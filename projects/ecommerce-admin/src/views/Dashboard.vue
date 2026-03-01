<template>
  <div class="dashboard">
    <h1>数据可视化大屏</h1>
    <div class="chart-container">
      <div class="chart-item">
        <h3>销售趋势</h3>
        <div ref="salesChart" class="chart"></div>
      </div>
      <div class="chart-item">
        <h3>订单分布</h3>
        <div ref="orderChart" class="chart"></div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import * as echarts from 'echarts'

const salesChart = ref<HTMLElement>()
const orderChart = ref<HTMLElement>()

onMounted(() => {
  // 初始化销售趋势图表
  if (salesChart.value) {
    const chart = echarts.init(salesChart.value)
    chart.setOption({
      title: {
        text: '销售趋势'
      },
      tooltip: {
        trigger: 'axis'
      },
      xAxis: {
        type: 'category',
        data: ['1月', '2月', '3月', '4月', '5月', '6月']
      },
      yAxis: {
        type: 'value'
      },
      series: [{
        data: [120, 190, 300, 500, 200, 300],
        type: 'line'
      }]
    })
  }

  // 初始化订单分布图表
  if (orderChart.value) {
    const chart = echarts.init(orderChart.value)
    chart.setOption({
      title: {
        text: '订单分布'
      },
      tooltip: {
        trigger: 'item'
      },
      series: [{
        name: '订单来源',
        type: 'pie',
        radius: '50%',
        data: [
          { value: 300, name: 'PC端' },
          { value: 500, name: '移动端' },
          { value: 200, name: '小程序' }
        ]
      }]
    })
  }
})
</script>

<style scoped>
.dashboard {
  padding: 20px;
}

.chart-container {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
  margin-top: 20px;
}

.chart-item {
  background: #f5f5f5;
  padding: 20px;
  border-radius: 8px;
}

.chart {
  width: 100%;
  height: 300px;
  margin-top: 10px;
}
</style>
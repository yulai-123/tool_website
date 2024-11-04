<template>
  <div class="layout">
    <div class="sidebar">
      <div 
        class="tool-item" 
        :class="{ active: currentTool === 'ping' }"
        @click="currentTool = 'ping'"
      >
        Ping Tool
      </div>
      <div 
        class="tool-item" 
        :class="{ active: currentTool === 'queryMethod' }"
        @click="currentTool = 'queryMethod'"
      >
        Query Method
      </div>
    </div>
    <div class="content">
      <PingTool v-if="currentTool === 'ping'" />
      <QueryMethodTool v-if="currentTool === 'queryMethod'" />
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import PingTool from './components/PingTool.vue'
import QueryMethodTool from './components/QueryMethodTool.vue'

const currentTool = ref('ping') // 设置默认值为 'ping'
</script>

<style scoped>
.layout {
  display: flex;
  height: 100vh;
  width: 100%; /* 设置宽度为100% */
}

.sidebar {
  width: 200px;
  min-width: 200px;
  border-right: 1px solid #eee;
  padding: 16px;
  background-color: #f8f9fa;
  overflow-y: auto;
}

.content {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
  min-width: 0;
  background-color: #ffffff;
}

.tool-item {
  padding: 12px;
  margin-bottom: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  transition: all 0.3s ease;
}

.tool-item:hover {
  background-color: #e9ecef;
  transform: translateX(2px);
}

/* 响应式设计 */
@media (max-width: 768px) {
  .layout {
    flex-direction: column;
  }
  
  .sidebar {
    width: 100%;
    height: auto;
    max-height: 200px;
    border-right: none;
    border-bottom: 1px solid #eee;
  }
  
  .content {
    height: calc(100vh - 200px);
    flex: 1;
  padding: 20px;
  overflow-x: hidden; /* 防止水平滚动 */
  min-width: 0;      /* 确保 flex 子项可以正确收缩 */
  }
}

/* 添加选中状态样式 */
.tool-item.active {
  background-color: #e9ecef;
  border-left: 3px solid #4CAF50;
}


</style>
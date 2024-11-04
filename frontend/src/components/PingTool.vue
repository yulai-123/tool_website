<template>
    <div class="ping-tool">
      <div class="button-container">
        <button @click="handlePing">Ping</button>
      </div>
      <div class="output-box">
        {{ output }}
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref } from 'vue'
  
  const output = ref('')
  
  const handlePing = async () => {
    try {
      const response = await fetch('http://localhost:8000/ping')
      const data = await response.json()
      output.value = data.message
    } catch (error) {
      output.value = 'Error: ' + error.message
    }
  }
  </script>
  
  <style scoped>
  .ping-tool {
  padding: 20px;
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}
  .button-container {
    margin-bottom: 16px;
  }
  
  button {
    padding: 8px 24px;
    background-color: #4CAF50;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 14px;
    transition: background-color 0.3s;
  }
  
  button:hover {
    background-color: #45a049;
  }
  
  .output-box {
  width: 100%;
  min-width: 400px;        /* 确保最小宽度能显示时间戳 */
  max-width: 800px;        /* 限制最大宽度 */
  min-height: 100px;
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  white-space: pre-wrap;
  word-wrap: break-word;
  background-color: #f5f5f5;
  font-family: monospace;
  font-size: 14px;
  line-height: 1.5;
}
  
  .output-box::-webkit-scrollbar {
    width: 8px;
  }
  
  .output-box::-webkit-scrollbar-track {
    background: #f1f1f1;
  }
  
  .output-box::-webkit-scrollbar-thumb {
    background: #888;
    border-radius: 4px;
  }
  
  .output-box::-webkit-scrollbar-thumb:hover {
    background: #555;
  }
  </style>
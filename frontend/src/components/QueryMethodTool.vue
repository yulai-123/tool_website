<template>
    <div class="query-method-tool">
      <!-- 左右布局容器 -->
      <div class="layout-container">
        <!-- 左侧ABI输入 -->
        <div class="left-panel">
          <div class="input-group">
            <label>ABI JSON:</label>
            <textarea 
              v-model="abiInput" 
              placeholder="请输入ABI JSON内容..."
              class="textarea-input"
            ></textarea>
          </div>
        </div>
  
        <!-- 右侧面板 -->
        <div class="right-panel">
          <!-- 上部分：输入和按钮 -->
          <div class="top-section">
  <div class="input-group encoded-data">
    <div class="input-row">
  <label>编码后的调用数据:</label>
  <textarea
    v-model="encodedData" 
    placeholder="0x开头的调用数据..."
    class="text-input multi-line"
  ></textarea>
</div>
  </div>
  <button @click="decodeMethod" class="decode-button">解析</button>
</div>
  
          <!-- 下部分：输出区域 -->
          <div class="bottom-section">
            <div class="output-group">
              <label>调用方法:</label>
              <div class="output-box">{{ methodName }}</div>
            </div>
            <div class="output-group">
              <label>实际参数:</label>
              <div class="output-box">{{ params }}</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </template>

<script setup>
import { ref } from 'vue'
import { Interface } from '@ethersproject/abi'

const abiInput = ref('')
const encodedData = ref('')
const methodName = ref('')
const params = ref('')

const decodeMethod = () => {
  try {
    // 检查输入
    if (!abiInput.value || !encodedData.value) {
      throw new Error('请输入ABI和调用数据')
    }

    // 解析ABI
    let abiJSON
    try {
      abiJSON = JSON.parse(abiInput.value)
    } catch (e) {
      throw new Error('ABI格式不正确')
    }

    // 创建接口实例
    const iface = new Interface(abiJSON)

    // 解析调用数据
    const decodedData = iface.parseTransaction({ data: encodedData.value })
    
    // 更新输出
    methodName.value = decodedData.name
    params.value = JSON.stringify(decodedData.args, null, 2)

  } catch (error) {
    methodName.value = 'Error'
    params.value = error.message
  }
}
</script>

  
  <style scoped>
  .query-method-tool {
    padding: 20px;
    width: 100%;
    height: 100%;
  }
  
  .layout-container {
    display: flex;
    gap: 20px;
    height: 100%;
    min-width: 0;
  }
  
  .left-panel {
    flex: 0 0 400px; /* 固定宽度 */
    height: 100%;
    min-width: 0;
  }
  
  .right-panel {
    flex: 1;
  display: flex;
  flex-direction: column;
  gap: 20px;
  min-width: 0;       /* 移除固定最小宽度，允许收缩 */
  /* width: 100%;        使用相对宽度 */
  width: 600px;
  }
  
  /* 顶部区域布局 */
.top-section {
  display: flex;
  gap: 16px;
  align-items: flex-start;
  width: 100%;
  flex-wrap: nowrap;    /* 防止换行 */
}
  
  .encoded-data {
    flex: 1;
    min-width: 200px; /* 设置最小宽度 */
  }
  
  .bottom-section {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 16px;
    min-width: 0;
    flex-direction: column;
  }
  
  .input-group, .output-group {
    display: flex;
    flex-direction: column;
    gap: 8px;
  }
  
  .textarea-input {
    width: 100%;
    height: calc(100vh - 150px);
    padding: 12px;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-family: monospace;
    resize: vertical;
  }
  
  .decode-button {
    padding: 8px 24px;
    height: 38px;
    background-color: #4CAF50;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 14px;
    white-space: nowrap;
    min-width: 80px;
    flex: 0 0 auto;
  }
  
  .decode-button:hover {
    background-color: #45a049;
  }
  
  .output-box {
    padding: 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  background-color: #f8f9fa;
  font-family: monospace;
  font-size: 14px;
  line-height: 1.5;
  white-space: pre-wrap;
  overflow: auto;
  }
  
  label {
    font-weight: bold;
    color: #333;
  }

  .input-row {
  display: flex;
  align-items: center;
  gap: 12px;
  width: 100%;
}

.input-row label {
  white-space: nowrap;
  min-width: fit-content;
  flex: 0 0 auto;
}

.text-input {
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-family: monospace;
  font-size: 14px;
  width: 100%;
  flex: 1;
  min-width: 0;
}

.top-section {
  display: flex;
  flex-direction: column;  /* 改为竖直方向 */
  gap: 16px;
  width: 100%;
}

.input-group.encoded-data {
  flex: 1;
  max-width: 100%;
}

/* 添加多行文本框样式 */
.text-input.multi-line {
  height: 80px;           /* 设置合适的高度 */
  resize: vertical;       /* 允许垂直调整大小 */
  min-height: 60px;      /* 最小高度 */
  max-height: 200px;     /* 最大高度 */
  line-height: 1.4;      /* 行高 */
  white-space: pre-wrap; /* 保留换行 */
  overflow-y: auto;      /* 内容过多时显示滚动条 */
}

/* 调用方法输出框样式 */
.output-group:first-child .output-box {
  height: 100px;
  min-height: 100px;
}

/* 实际参数输出框样式 */
.output-group:last-child .output-box {
  height: 400px;
  min-height: 200px;
  resize: vertical;     /* 允许垂直方向调整大小 */
  width: 100%;
}


  </style>
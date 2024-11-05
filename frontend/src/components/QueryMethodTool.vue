<template>
  <!-- 主容器：垂直布局 -->
  <div class="tool-container">
    <!-- 1. ABI输入区域 -->
    <div class="input-section">
      <label>ABI JSON:</label>
      <textarea 
        v-model="abiInput" 
        placeholder="请输入ABI JSON内容..."
        class="input-box abi-input"
      ></textarea>
    </div>

    <!-- 2. 调用数据输入区域 -->
    <div class="input-section">
      <label>编码后的调用数据:</label>
      <textarea
        v-model="encodedData" 
        placeholder="0x开头的调用数据..."
        class="input-box data-input"
      ></textarea>
    </div>

    <!-- 3. 解析按钮 -->
    <div class="button-section">
      <button @click="decodeMethod" class="decode-button">解析</button>
    </div>

    <!-- 4. 方法名称输出区域 -->
    <div class="output-section">
      <label>调用方法:</label>
      <div class="output-box method-output">{{ methodOutput }}</div>
    </div>

    <!-- 5. 参数表格展示区域 -->
    <div class="output-section">
      <label>实际参数:</label>
      <table class="params-table" v-if="parsedParams.length">
        <thead>
          <tr>
            <th>字段名称</th>
            <th>字段类型</th>
            <th>字段值</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(param, index) in parsedParams" :key="index">
            <td>{{ param.name }}</td>
            <td>{{ param.type }}</td>
            <td>{{ param.value }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { Interface } from '@ethersproject/abi'

// 定义响应式数据
const abiInput = ref('')
const encodedData = ref('')
const methodName = ref('')
const methodSignature = ref('') // 新增：存储方法签名
const decodedParams = ref(null)
const methodInputs = ref([]) // 新增：存储方法的输入参数定义

// 修改：方法输出展示
const methodOutput = computed(() => {
  if (!methodName.value) return ''
  return `${methodName.value}(${methodInputs.value.map(input => `${input.type} ${input.name}`).join(', ')})`
})

// 修改：解析参数为表格数据格式
const parsedParams = computed(() => {
  try {
    if (!decodedParams.value || !methodInputs.value) return []
    
    // 使用方法定义的输入参数来构建结果
    return methodInputs.value.map((input, index) => {
      const paramValue = decodedParams.value[index]
      return {
        name: input.name,
        type: input.type,
        // 使用 !== undefined 来检查值是否存在
        value: paramValue !== undefined ? 
          (typeof paramValue === 'boolean' ? paramValue.toString() : JSON.stringify(paramValue)) 
          : ''
      }
    })
  } catch (error) {
    console.error('参数解析错误:', error)
    return []
  }
})

// 修改：解析方法
const decodeMethod = async () => {
  try {
    if (!abiInput.value || !encodedData.value) {
      throw new Error('请输入完整的ABI和调用数据')
    }

    const abiJSON = JSON.parse(abiInput.value)
    const iface = new Interface(abiJSON)
    const decodedData = iface.parseTransaction({ data: encodedData.value })
    
    // 更新方法名和签名
    methodName.value = decodedData.name
    
    // 从ABI中找到对应方法的定义
    const methodDef = abiJSON.find(item => 
      item.name === decodedData.name && 
      item.type === 'function'
    )
    
    // 保存方法的输入参数定义
    methodInputs.value = methodDef ? methodDef.inputs : []
    
    // 保存解析后的参数值
    decodedParams.value = decodedData.args
    
  } catch (error) {
    methodName.value = 'Error'
    methodInputs.value = []
    decodedParams.value = null
    console.error('解析错误:', error)
  }
}
</script>

<style scoped>
/* 主容器样式 */
.tool-container {
  display: flex;
  flex-direction: column;
  gap: 20px;
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

/* 输入区域样式 */
.input-section {
  display: flex;
  flex-direction: column;
  gap: 8px;
  min-width: 600px;
}

/* 输入框通用样式 */
.input-box {
  width: 100%;
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-family: monospace;
  font-size: 14px;
  line-height: 1.5;
}

/* ABI输入框特殊样式 */
.abi-input {
  height: 200px;
  resize: vertical;
  min-height: 150px;
}

/* 调用数据输入框特殊样式 */
.data-input {
  height: 100px;
  resize: vertical;
  min-height: 60px;
}

/* 按钮区域样式 */
.button-section {
  display: flex;
  justify-content: flex-start;
}

/* 解析按钮样式 */
.decode-button {
  padding: 8px 24px;
  background-color: #4CAF50;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  transition: background-color 0.3s;
}

.decode-button:hover {
  background-color: #45a049;
}

/* 输出区域样式 */
.output-section {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

/* 方法输出框样式 */
.method-output {
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  background-color: #f8f9fa;
  min-height: 42px;
}

/* 参数表格样式 */
.params-table {
  width: 100%;
  border-collapse: collapse;
  background-color: #fff;
}

.params-table th,
.params-table td {
  padding: 12px;
  border: 1px solid #ddd;
  text-align: left;
}

.params-table th {
  background-color: #f8f9fa;
  font-weight: bold;
}

/* 标签样式 */
label {
  font-weight: bold;
  color: #333;
}
</style>
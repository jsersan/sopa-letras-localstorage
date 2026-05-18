<template>
  <div id="app">
    <SopaDeLetras />
  </div>
</template>

<script>
import SopaDeLetras from './components/SopaDeLetras.vue'

export default {
  name: 'App',
  components: {
    SopaDeLetras
  }
}
</script>

<style>
:root {
  --color-primary: #3f51b5;
  --color-primary-dark: #303f9f;
  --color-primary-light: #c5cae9;
  --color-accent: #536dfe;
  --color-background: #f5f5f5;
  --color-surface: #ffffff;
  --color-text: #212121;
  --color-text-secondary: #757575;
  --color-border: #e0e0e0;
  --color-success: #4caf50;
  --color-warning: #ff9800;
}

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  min-height: 100vh;
  color: var(--color-text);
}

.btn {
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 0.95rem;
  font-weight: 600;
  transition: all 0.3s ease;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
}

.btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}
</style>

<template>
  <div class="kronometroa-floating">
    <div class="kronometroa-content">
      <span class="icon">⏱️</span>
      <span class="denbora">{{denboraFormateada}}</span>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Kronometroa',
  props: {
    hasieraOrdua: { type: Number, default: 0 },
    amaieraOrdua: { type: Number, default: 0 },
    gehitutakoOrdua: { type: Number, default: 0 }
  },
  data() {
    return {
      oraingoDenbora: Date.now()
    }
  },
  mounted() {
    this.interval = setInterval(() => {
      this.oraingoDenbora = Date.now()
    }, 100)
  },
  beforeUnmount() {
    if (this.interval) clearInterval(this.interval)
  },
  computed: {
    denboraFormateada() {
      let d = this.oraingoDenbora - this.hasieraOrdua + this.gehitutakoOrdua
      d = Math.floor(d / 1000)
      const s = d % 60
      const m = Math.floor((d - s) / 60) % 60
      const h = Math.floor((d - (m * 60) - s) / 3600)
      return `${h.toString().padStart(2, '0')}:${m.toString().padStart(2, '0')}:${s.toString().padStart(2, '0')}`
    }
  }
}
</script>

<style scoped>
.kronometroa-floating {
  position: fixed;
  bottom: 2rem;
  right: 2rem;
  z-index: 100;
  animation: fadeIn 0.5s ease;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

.kronometroa-content {
  background: linear-gradient(135deg, var(--color-primary), var(--color-accent));
  color: white;
  padding: 1.5rem 2rem;
  border-radius: 16px;
  box-shadow: 0 8px 24px rgba(63, 81, 181, 0.4);
  display: flex;
  align-items: center;
  gap: 1rem;
  font-family: monospace;
  font-size: 1.5rem;
  font-weight: 700;
  border: 3px solid rgba(255, 255, 255, 0.3);
  transition: all 0.3s ease;
}

.kronometroa-content:hover {
  transform: scale(1.05);
  box-shadow: 0 12px 32px rgba(63, 81, 181, 0.5);
}

.icon {
  font-size: 2rem;
  animation: pulse 2s ease-in-out infinite;
}

@keyframes pulse {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.1); }
}

.denbora {
  letter-spacing: 2px;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
}

@media (max-width: 768px) {
  .kronometroa-floating {
    bottom: 1rem;
    right: 1rem;
  }
  
  .kronometroa-content {
    padding: 1rem 1.5rem;
    font-size: 1.2rem;
  }
  
  .icon {
    font-size: 1.5rem;
  }
}
</style>

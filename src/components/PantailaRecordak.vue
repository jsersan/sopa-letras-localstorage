<template>
  <div class="pantaila-recordak" v-if="erakutsi">
    <div class="recordak-content">
      <div class="recordak-header">
        <h1>🏆 Recordak</h1>
        <button class="btn-itxi" @click="$emit('itxi')">✕</button>
      </div>

      <div class="tamaina-aukerak">
        <button 
          v-for="t in tamainakDisponible" 
          :key="t"
          class="btn-tamaina"
          :class="{'aktibo': t === aukeratutakoTamaina}"
          @click="aukeratutakoTamaina = t"
        >
          {{t}}x{{t}}
        </button>
      </div>

      <div class="recordak-zerrenda">
        <h3>🏆 Top 10 - {{aukeratutakoTamaina}}x{{aukeratutakoTamaina}}</h3>
        
        <div v-if="recordakTamainaz.length === 0" class="ez-dago-recordik">
          <p>Ez dago recordik oraindik tamaina honetarako.</p>
          <p>Izan lehena!</p>
        </div>

        <div v-else class="taula-edukia">
          <div class="taula-burua">
            <span class="posizio-header">#</span>
            <span class="izena-header">Izena</span>
            <span class="denbora-header">Denbora</span>
            <span class="data-header">Data</span>
          </div>
          <div 
            v-for="(record, idx) in recordakTamainaz" 
            :key="idx" 
            class="record-ilara"
            :class="{
              'posizio-1': idx === 0,
              'posizio-2': idx === 1,
              'posizio-3': idx === 2
            }"
          >
            <span class="posizio">
              <span v-if="idx === 0">🥇</span>
              <span v-else-if="idx === 1">🥈</span>
              <span v-else-if="idx === 2">🥉</span>
              <span v-else>#{{idx + 1}}</span>
            </span>
            <span class="izena">{{record.izena}}</span>
            <span class="denbora">{{formatearDenbora(record.segundoak)}}</span>
            <span class="data">{{formatearData(record.data)}}</span>
          </div>
        </div>
      </div>

      <div class="botoiak">
        <button class="btn btn-itxi-nagusia" @click="$emit('itxi')">
          <span class="icon">👈</span>
          <span>Atzera</span>
        </button>
        <button class="btn btn-ezabatu" @click="ezabatuRecordak" v-if="recordakTamainaz.length > 0">
          <span class="icon">🗑️</span>
          <span>Ezabatu</span>
        </button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'PantailaRecordak',
  props: {
    erakutsi: { type: Boolean, default: false }
  },
  emits: ['itxi'],
  data() {
    return {
      tamainakDisponible: [8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20],
      aukeratutakoTamaina: 12
    }
  },
  computed: {
    recordakTamainaz() {
      const gakoa = `records_${this.aukeratutakoTamaina}`
      const recordakJSON = localStorage.getItem(gakoa)
      let recordak = recordakJSON ? JSON.parse(recordakJSON) : []
      return recordak.sort((a, b) => a.segundoak - b.segundoak).slice(0, 10)
    }
  },
  methods: {
    formatearDenbora(seg) {
      const s = seg % 60
      const m = Math.floor((seg - s) / 60) % 60
      const h = Math.floor((seg - (m * 60) - s) / 3600)
      return `${h.toString().padStart(2, '0')}:${m.toString().padStart(2, '0')}:${s.toString().padStart(2, '0')}`
    },
    formatearData(timestamp) {
      const data = new Date(timestamp)
      return `${data.getDate()}/${data.getMonth() + 1}/${data.getFullYear()}`
    },
    ezabatuRecordak() {
      if (confirm(`Ziur zaude ${this.aukeratutakoTamaina}x${this.aukeratutakoTamaina} tamainako record guztiak ezabatu nahi dituzula?`)) {
        const gakoa = `records_${this.aukeratutakoTamaina}`
        localStorage.removeItem(gakoa)
        this.$forceUpdate()
      }
    }
  }
}
</script>

<style scoped>
.pantaila-recordak {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.85);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 1rem;
  z-index: 2000;
  animation: fadeIn 0.3s;
}

.recordak-content {
  background: white;
  border-radius: 16px;
  max-width: 800px;
  width: 100%;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
  animation: slideUp 0.4s;
}

.recordak-header {
  background: linear-gradient(135deg, var(--color-primary), var(--color-accent));
  color: white;
  padding: 2rem;
  border-radius: 16px 16px 0 0;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.recordak-header h1 {
  margin: 0;
  font-size: 2rem;
}

.btn-itxi {
  background: rgba(255, 255, 255, 0.2);
  border: 2px solid white;
  color: white;
  font-size: 1.5rem;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  cursor: pointer;
  transition: all 0.3s;
  display: flex;
  align-items: center;
  justify-content: center;
}

.btn-itxi:hover {
  background: white;
  color: var(--color-primary);
  transform: rotate(90deg);
}

.tamaina-aukerak {
  padding: 1.5rem;
  border-bottom: 2px solid var(--color-border);
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  justify-content: center;
}

.btn-tamaina {
  padding: 0.5rem 1rem;
  border: 2px solid var(--color-primary);
  background: white;
  color: var(--color-primary);
  border-radius: 8px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
  font-size: 0.9rem;
}

.btn-tamaina:hover {
  background: var(--color-primary-light);
  transform: translateY(-2px);
}

.btn-tamaina.aktibo {
  background: var(--color-primary);
  color: white;
  box-shadow: 0 4px 8px rgba(63, 81, 181, 0.3);
}

.recordak-zerrenda {
  padding: 2rem;
}

.recordak-zerrenda h3 {
  margin: 0 0 1.5rem 0;
  text-align: center;
  color: var(--color-primary);
  font-size: 1.5rem;
}

.ez-dago-recordik {
  text-align: center;
  padding: 3rem 2rem;
  color: var(--color-text-secondary);
}

.ez-dago-recordik p:first-child {
  font-size: 1.2rem;
  margin-bottom: 0.5rem;
}

.ez-dago-recordik p:last-child {
  font-size: 1.5rem;
  font-weight: 700;
  color: var(--color-primary);
}

.taula-edukia {
  background: white;
  border-radius: 8px;
  overflow: hidden;
  border: 2px solid var(--color-border);
}

.taula-burua {
  display: grid;
  grid-template-columns: 60px 1fr 120px 100px;
  gap: 1rem;
  padding: 1rem;
  background: var(--color-primary);
  color: white;
  font-weight: 700;
  font-size: 0.9rem;
}

.record-ilara {
  display: grid;
  grid-template-columns: 60px 1fr 120px 100px;
  gap: 1rem;
  padding: 1rem;
  border-bottom: 1px solid var(--color-border);
  transition: background 0.3s;
  align-items: center;
}

.record-ilara:hover {
  background: var(--color-background);
}

.record-ilara:last-child {
  border-bottom: none;
}

.posizio-1 {
  background: linear-gradient(135deg, #fff9e6, #fffaed);
}

.posizio-2 {
  background: linear-gradient(135deg, #f5f5f5, #fafafa);
}

.posizio-3 {
  background: linear-gradient(135deg, #fff3e0, #fff8f0);
}

.posizio {
  font-weight: 700;
  color: var(--color-primary);
  font-size: 1.2rem;
  text-align: center;
}

.izena {
  color: var(--color-text);
  font-weight: 600;
}

.denbora {
  font-family: monospace;
  font-weight: 700;
  color: var(--color-accent);
  font-size: 1.1rem;
}

.data {
  font-size: 0.85rem;
  color: var(--color-text-secondary);
}

.botoiak {
  padding: 2rem;
  display: flex;
  gap: 1rem;
  border-top: 2px solid var(--color-border);
}

.btn-itxi-nagusia {
  flex: 1;
  background: var(--color-primary);
  color: white;
}

.btn-itxi-nagusia:hover {
  background: var(--color-primary-dark);
}

.btn-ezabatu {
  background: #f44336;
  color: white;
}

.btn-ezabatu:hover {
  background: #d32f2f;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes slideUp {
  from { transform: translateY(50px); opacity: 0; }
  to { transform: translateY(0); opacity: 1; }
}

@media (max-width: 768px) {
  .recordak-header h1 {
    font-size: 1.5rem;
  }
  
  .tamaina-aukerak {
    gap: 0.25rem;
  }
  
  .btn-tamaina {
    padding: 0.4rem 0.8rem;
    font-size: 0.8rem;
  }
  
  .taula-burua,
  .record-ilara {
    grid-template-columns: 50px 1fr 90px;
    gap: 0.5rem;
    font-size: 0.85rem;
  }
  
  .data,
  .data-header {
    display: none;
  }
  
  .botoiak {
    flex-direction: column;
  }
}
</style>

<template>
  <div class="pantaila-amaiera" v-if="erakutsi">
    <div class="amaiera-content">
      <div class="amaiera-header">
        <h1>🎉 Zorionak!</h1>
        <p>Hitz guztiak aurkitu dituzu!</p>
      </div>
      
      <div class="denbora-info">
        <div class="denbora-label">Zure denbora:</div>
        <div class="denbora-value">{{denboraFormateada}}</div>
        <div v-if="recordBerria" class="record-berria">
          ⭐ RECORD BERRIA! ⭐
        </div>
        <div v-else-if="posizio" class="posizio-info">
          Zure posizioa: #{{posizio}}
        </div>
      </div>

      <div class="izena-form">
        <label>Zure izena:</label>
        <input 
          v-model="jokalariIzena" 
          type="text" 
          placeholder="Idatzi zure izena..."
          maxlength="20"
          @keyup.enter="gordeRecord"
        />
      </div>

      <div class="botoiak">
        <button class="btn btn-gorde" @click="gordeRecord">
          <span class="icon">💾</span>
          <span>Recorda Gorde</span>
        </button>
        <button class="btn btn-joko-berria" @click="$emit('jokoaHasi')">
          <span class="icon">🔄</span>
          <span>Joko Berria</span>
        </button>
        <button class="btn btn-recordak" @click="erakutsiRecordak = !erakutsiRecordak">
          <span class="icon">🏆</span>
          <span>Recordak Ikusi</span>
        </button>
      </div>

      <div v-if="erakutsiRecordak" class="recordak-taula">
        <h3>🏆 Top 10 Recordak - {{tamaina}}x{{tamaina}}</h3>
        <div class="taula-edukia">
          <div v-for="(record, idx) in top10Records" :key="idx" 
               class="record-ilara"
               :class="{'record-propioa': record.berriki}">
            <span class="posizio">#{{idx + 1}}</span>
            <span class="izena">{{record.izena}}</span>
            <span class="denbora">{{formatearDenbora(record.segundoak)}}</span>
            <span class="data">{{formatearData(record.data)}}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'PantailaAmaiera',
  props: {
    erakutsi: { type: Boolean, default: false },
    denbora: { type: Number, default: 0 },
    tamaina: { type: Number, default: 12 }
  },
  emits: ['jokoaHasi'],
  data() {
    return {
      jokalariIzena: '',
      erakutsiRecordak: false,
      recordBerria: false,
      posizio: null
    }
  },
  computed: {
    denboraFormateada() {
      return this.formatearDenbora(this.segundoak)
    },
    segundoak() {
      return Math.floor(this.denbora / 1000)
    },
    top10Records() {
      const gakoa = `records_${this.tamaina}`
      const recordakJSON = localStorage.getItem(gakoa)
      let recordak = recordakJSON ? JSON.parse(recordakJSON) : []
      return recordak.sort((a, b) => a.segundoak - b.segundoak).slice(0, 10)
    }
  },
  watch: {
    erakutsi(berria) {
      if (berria) {
        this.egiaztaturRecord()
        this.jokalariIzena = localStorage.getItem('azkenIzena') || ''
      }
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
    egiaztaturRecord() {
      const recordak = this.top10Records
      if (recordak.length === 0) {
        this.recordBerria = true
        this.posizio = 1
        return
      }
      
      const hobea = recordak.findIndex(r => r.segundoak > this.segundoak)
      if (hobea === -1) {
        if (recordak.length < 10) {
          this.posizio = recordak.length + 1
        } else {
          this.posizio = null
        }
      } else {
        this.posizio = hobea + 1
        if (hobea === 0) {
          this.recordBerria = true
        }
      }
    },
    gordeRecord() {
      if (!this.jokalariIzena.trim()) {
        alert('Mesedez, idatzi zure izena!')
        return
      }

      const gakoa = `records_${this.tamaina}`
      const recordakJSON = localStorage.getItem(gakoa)
      let recordak = recordakJSON ? JSON.parse(recordakJSON) : []
      
      recordak.push({
        izena: this.jokalariIzena.trim(),
        segundoak: this.segundoak,
        data: Date.now(),
        berriki: true
      })
      
      recordak.sort((a, b) => a.segundoak - b.segundoak)
      recordak = recordak.slice(0, 50) // Mantenemos top 50
      
      localStorage.setItem(gakoa, JSON.stringify(recordak))
      localStorage.setItem('azkenIzena', this.jokalariIzena.trim())
      
      this.erakutsiRecordak = true
      
      // Limpiar marca "berriki" después de 3 segundos
      setTimeout(() => {
        recordak.forEach(r => r.berriki = false)
        localStorage.setItem(gakoa, JSON.stringify(recordak))
      }, 3000)
    }
  }
}
</script>

<style scoped>
.pantaila-amaiera{
  position:fixed;
  top:0;left:0;right:0;bottom:0;
  background:rgba(0,0,0,0.8);
  display:flex;
  align-items:center;
  justify-content:center;
  padding:2rem;
  z-index:2000;
  animation:fadeIn 0.3s;
}
.amaiera-content{
  background:white;
  border-radius:16px;
  max-width:600px;
  width:100%;
  max-height:90vh;
  overflow-y:auto;
  box-shadow:0 20px 60px rgba(0,0,0,0.5);
  animation:slideUp 0.4s;
}
.amaiera-header{
  background:linear-gradient(135deg,var(--color-primary),var(--color-accent));
  color:white;
  padding:2rem;
  text-align:center;
  border-radius:16px 16px 0 0;
}
.amaiera-header h1{
  margin:0 0 0.5rem 0;
  font-size:2.5rem;
}
.amaiera-header p{
  margin:0;
  font-size:1.1rem;
  opacity:0.9;
}
.denbora-info{
  padding:2rem;
  text-align:center;
  border-bottom:2px solid var(--color-border);
}
.denbora-label{
  font-size:1rem;
  color:var(--color-text-secondary);
  margin-bottom:0.5rem;
}
.denbora-value{
  font-size:3rem;
  font-weight:700;
  color:var(--color-primary);
  font-family:monospace;
}
.record-berria{
  margin-top:1rem;
  padding:0.75rem;
  background:linear-gradient(135deg,#ffd700,#ffed4e);
  color:#000;
  font-weight:700;
  border-radius:8px;
  font-size:1.2rem;
  animation:pulse 1s infinite;
}
@keyframes pulse{
  0%,100%{transform:scale(1)}
  50%{transform:scale(1.05)}
}
.posizio-info{
  margin-top:1rem;
  font-size:1.1rem;
  color:var(--color-accent);
  font-weight:600;
}
.izena-form{
  padding:2rem;
  border-bottom:2px solid var(--color-border);
}
.izena-form label{
  display:block;
  margin-bottom:0.5rem;
  font-weight:600;
  color:var(--color-text);
}
.izena-form input{
  width:100%;
  padding:0.75rem;
  border:2px solid var(--color-border);
  border-radius:8px;
  font-size:1rem;
  transition:border-color 0.3s;
}
.izena-form input:focus{
  outline:none;
  border-color:var(--color-primary);
}
.botoiak{
  padding:2rem;
  display:flex;
  gap:1rem;
  flex-wrap:wrap;
}
.botoiak .btn{
  flex:1;
  min-width:150px;
}
.btn-gorde{
  background:var(--color-success);
  color:white;
}
.btn-gorde:hover{
  background:#388e3c;
}
.btn-joko-berria{
  background:var(--color-accent);
  color:white;
}
.btn-recordak{
  background:var(--color-warning);
  color:white;
}
.recordak-taula{
  padding:2rem;
  background:var(--color-background);
}
.recordak-taula h3{
  margin:0 0 1rem 0;
  text-align:center;
  color:var(--color-primary);
}
.taula-edukia{
  background:white;
  border-radius:8px;
  overflow:hidden;
}
.record-ilara{
  display:grid;
  grid-template-columns:50px 1fr auto auto;
  gap:1rem;
  padding:0.75rem 1rem;
  border-bottom:1px solid var(--color-border);
  transition:background 0.3s;
}
.record-ilara:hover{
  background:var(--color-background);
}
.record-ilara:last-child{
  border-bottom:none;
}
.record-propioa{
  background:var(--color-primary-light);
  font-weight:700;
}
.posizio{
  font-weight:700;
  color:var(--color-primary);
}
.izena{
  color:var(--color-text);
}
.denbora{
  font-family:monospace;
  font-weight:600;
  color:var(--color-accent);
}
.data{
  font-size:0.85rem;
  color:var(--color-text-secondary);
}
@keyframes fadeIn{from{opacity:0}to{opacity:1}}
@keyframes slideUp{from{transform:translateY(50px);opacity:0}to{transform:translateY(0);opacity:1}}
@media (max-width:768px){
  .botoiak{flex-direction:column}
  .botoiak .btn{width:100%}
  .record-ilara{grid-template-columns:40px 1fr auto;font-size:0.9rem}
  .data{display:none}
}
</style>

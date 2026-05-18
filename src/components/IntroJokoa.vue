<template>
  <div class="intro-jokoa">
    <div class="intro-content">
      <div class="intro-grid">
        <div class="intro-col" :class="{'full-width': !gehitutakoOrdua}">
          <div class="instrukzioak">
            <div class="title"><h2>JARRAIBIDEAK</h2></div>
            <div class="content">
              <ul>
                <li>Hautatu hitz-zopa tamainu bat eta sakatu "Hasi".</li>
                <li>Bilatu hitz bat eta identifikatu muturretako gelaxkak.</li>
                <li>Amaitzean, denbora agertuko da.</li>
                <li>Joko berri bat kargatu dezakezu edozein unetan.</li>
              </ul>
            </div>
          </div>
          <div v-if="!gehitutakoOrdua" class="kontrolak">
            <select v-model="aukeratutakoTamaina" class="btn btn-tamaina">
              <option v-for="t in tamainak" :key="t" :value="t">TAMAINA {{t}} x {{t}}</option>
            </select>
            <button class="btn btn-hasi" @click="$emit('tamainaAldatu', aukeratutakoTamaina)">
              <span class="icon">🎮</span><span class="text">HASI</span>
            </button>
          </div>
        </div>
        <div v-if="gehitutakoOrdua && esaldia" class="intro-col">
          <div class="esaldia">
            <div class="testua">{{ esaldia.testua }}.</div>
            <div class="egilea">{{ esaldia.egilea }}</div>
          </div>
          <button class="btn btn-jarraitu" @click="$emit('jokoaHasi')">
            <span class="icon">▶</span><span class="text">JARRAITU</span>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'IntroJokoa',
  props: {
    tamaina: { type: Number, default: 12 },
    esaldia: { type: Object, default: null },
    gehitutakoOrdua: { type: Number, default: 0 }
  },
  emits: ['tamainaAldatu', 'jokoaHasi'],
  data() {
    return {
      tamainak: [8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20],
      aukeratutakoTamaina: 12
    }
  },
  mounted() {
    this.aukeratutakoTamaina = this.tamaina
  }
}
</script>

<style scoped>
.intro-jokoa{position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.5);display:flex;align-items:center;justify-content:center;padding:2rem;z-index:1000;animation:fadeIn 0.3s}
@keyframes fadeIn{from{opacity:0}to{opacity:1}}
.intro-content{background:white;border-radius:12px;max-width:900px;width:100%;max-height:90vh;overflow-y:auto;box-shadow:0 10px 40px rgba(0,0,0,0.3);animation:slideUp 0.4s}
@keyframes slideUp{from{transform:translateY(50px);opacity:0}to{transform:translateY(0);opacity:1}}
.intro-grid{display:grid;grid-template-columns:1fr;gap:2rem}
.intro-col{padding:2rem}
.intro-col.full-width{grid-column:1/-1}
.instrukzioak{margin-bottom:2rem}
.instrukzioak .title{background:var(--color-primary);color:white;padding:1rem;border-radius:8px 8px 0 0;text-align:center}
.instrukzioak .title h2{margin:0;font-size:1.5rem;letter-spacing:1px}
.instrukzioak .content{background:var(--color-background);padding:1.5rem;border-radius:0 0 8px 8px;border:2px solid var(--color-border);border-top:none}
.instrukzioak ul{list-style:none;padding:0}
.instrukzioak li{padding:0.75rem 0 0.75rem 2rem;position:relative;line-height:1.6;color:var(--color-text)}
.instrukzioak li::before{content:'▶';position:absolute;left:0.5rem;color:var(--color-primary);font-size:0.8rem}
.instrukzioak li:not(:last-child){border-bottom:1px solid var(--color-border)}
.kontrolak{display:flex;gap:1rem;flex-wrap:wrap}
.kontrolak .btn{flex:1;min-width:150px}
.btn-hasi{background:var(--color-accent);color:white}
.btn-hasi:hover{background:var(--color-primary-dark)}
.esaldia{background:linear-gradient(135deg,var(--color-primary) 0%,var(--color-accent) 100%);padding:2rem;border-radius:8px;color:white;margin-bottom:2rem;box-shadow:0 4px 12px rgba(0,0,0,0.2)}
.esaldia .testua{font-size:1.1rem;line-height:1.8;margin-bottom:1rem;font-style:italic}
.esaldia .egilea{text-align:right;font-weight:600;font-size:0.95rem;border-top:2px solid rgba(255,255,255,0.3);padding-top:1rem;margin-top:1rem}
.btn-jarraitu{background:var(--color-success);color:white;width:100%;font-size:1.1rem;padding:1rem}
.btn-jarraitu:hover{background:#388e3c}
@media (min-width:768px){.intro-grid{grid-template-columns:1fr 1fr}}
@media (max-width:768px){.intro-jokoa{padding:1rem}.intro-col{padding:1.5rem}.kontrolak{flex-direction:column}.kontrolak .btn{width:100%}}
</style>

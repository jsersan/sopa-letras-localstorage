<template>
  <div class="top-bar" :style="{minWidth: gutxienezkoZabalera}">
    <div class="top-bar-content">
      <div class="control-group">
        <select v-model="aukeratutakoTamaina" class="btn btn-tamaina">
          <option v-for="t in tamainak" :key="t" :value="t">TAMAINA {{t}} x {{t}}</option>
        </select>
      </div>
      <div class="control-group">
        <button class="btn btn-joko-berria" @click="$emit('tamainaAldatu', aukeratutakoTamaina)">
          <span class="icon">🎮</span><span class="text">JOKO BERRIA</span>
        </button>
      </div>
      <div class="control-group">
        <button class="btn btn-pausatu" @click="$emit('jokoaPausatu')">
          <span class="icon">⏸</span><span class="text">PAUSATU</span>
        </button>
      </div>
      <div class="control-group">
        <button class="btn btn-recordak" @click="$emit('recordakIkusi')">
          <span class="icon">🏆</span><span class="text">RECORDAK</span>
        </button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'TopBar',
  props: {
    tamaina: { type: Number, default: 12 }
  },
  emits: ['tamainaAldatu', 'jokoaPausatu', 'recordakIkusi'],
  data() {
    return {
      tamainak: [8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20],
      aukeratutakoTamaina: 12
    }
  },
  mounted() {
    this.aukeratutakoTamaina = this.tamaina
  },
  computed: {
    gutxienezkoZabalera() {
      return `${((20 + 20 - Math.floor(this.tamaina * 0.75)) * this.tamaina) + 32}px`
    }
  }
}
</script>

<style scoped>
.top-bar{background:white;border-bottom:3px solid var(--color-primary);padding:1rem;box-shadow:0 2px 4px rgba(0,0,0,0.1)}
.top-bar-content{display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:1rem}
.control-group{display:flex;align-items:center;justify-content:center}
.btn-tamaina{background:white;color:var(--color-warning);border:2px solid var(--color-warning);width:100%}
.btn-tamaina:hover{background:var(--color-warning);color:white}
.btn-joko-berria{background:var(--color-accent);color:white;width:100%}
.btn-joko-berria:hover{background:var(--color-primary-dark)}
.btn-pausatu{background:white;color:var(--color-text-secondary);border:2px solid var(--color-border);width:100%}
.btn-pausatu:hover{background:var(--color-background);border-color:var(--color-primary)}
.btn-recordak{background:var(--color-warning);color:white;width:100%;border:2px solid var(--color-warning)}
.btn-recordak:hover{background:#f57c00;transform:scale(1.02)}
.position-relative{position:relative}
@media (max-width:768px){.top-bar-content{grid-template-columns:1fr}}
</style>

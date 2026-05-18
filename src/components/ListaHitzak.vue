<template>
  <div class="lista-hitzak">
    <div class="list-pals">
      <div v-for="hitza in hitzak" :key="hitza.w" class="palabra"
           :class="{'encontrada': hitza.e}"
           :style="{backgroundColor: hitza.e ? hitza.h : ''}">
        {{hitza.w.toUpperCase()}}
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ListaHitzak',
  props: {
    hitzak: { type: Array, default: () => [] }
  }
}
</script>

<style scoped>
.lista-hitzak{padding:1.5rem}
.list-pals{background:white;padding:1.5rem;border-radius:8px;box-shadow:0 4px 12px rgba(0,0,0,0.15);display:grid;grid-template-columns:repeat(auto-fill,minmax(150px,1fr));gap:0.75rem;max-height:600px;overflow-y:auto}
.palabra{
  padding:0.75rem 1rem;
  text-align:center;
  font-weight:600;
  border-radius:6px;
  background:var(--color-background);
  color:var(--color-text);
  border:2px solid var(--color-border);
  transition:all 0.3s;
  font-size:0.95rem;
  letter-spacing:0.5px;
  word-wrap:break-word;
  overflow-wrap:break-word;
  hyphens:auto;
  min-height:3rem;
  display:flex;
  align-items:center;
  justify-content:center;
}
.palabra:not(.encontrada):hover{transform:translateY(-2px);box-shadow:0 4px 8px rgba(0,0,0,0.1);border-color:var(--color-primary)}
.palabra.encontrada{color:white;border-color:transparent;font-weight:700;position:relative;overflow:hidden}
.palabra.encontrada::after{content:'✓';position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);font-size:2rem;opacity:0.3}
@media (max-width:768px){
  .list-pals{grid-template-columns:repeat(auto-fill,minmax(120px,1fr));gap:0.5rem}
  .palabra{padding:0.5rem 0.75rem;font-size:0.85rem}
}
</style>

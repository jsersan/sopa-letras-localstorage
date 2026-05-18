<template>
  <div class="matrix-letras">
    <div class="content-lets">
      <div v-for="(errenkada, yi) in sopa" :key="yi" class="let-row" :style="{height: gelaxkaTamaina}">
        <div v-for="(gelaxka, xi) in errenkada" :key="xi" class="let-cell"
             :class="{
               'let-sel': gelaxka.c['let-sel'],
               'let-pos': gelaxka.c['let-pos'],
               'let-mar': gelaxka.c['let-mar']
             }"
             :style="{
               width: gelaxkaTamaina,
               height: gelaxkaTamaina,
               backgroundColor: gelaxka.s ? gelaxka.h : '',
               fontSize: fontTamaina
             }"
             @click="$emit('gelaxkaHautatua', gelaxka)">
          {{gelaxka.l}}
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'MatrixLetras',
  props: {
    sopa: { type: Array, default: () => [] },
    tamaina: { type: Number, default: 12 }
  },
  emits: ['gelaxkaHautatua'],
  computed: {
    fontTamaina() {
      return `${12 + 20 - Math.floor(this.tamaina * 0.75)}px`
    },
    gelaxkaTamaina() {
      return `${20 + 20 - Math.floor(this.tamaina * 0.75)}px`
    }
  }
}
</script>

<style scoped>
.matrix-letras{padding:1.5rem;display:flex;justify-content:center;align-items:center}
.content-lets{background:white;padding:1rem;border-radius:8px;box-shadow:0 4px 12px rgba(0,0,0,0.15);display:inline-block}
.let-row{display:flex;line-height:0}
.let-cell{display:inline-flex;align-items:center;justify-content:center;font-weight:700;cursor:pointer;user-select:none;transition:all 0.2s;color:var(--color-text);background:var(--color-background);border:1px solid var(--color-border);text-transform:uppercase}
.let-cell:hover{transform:scale(1.1);z-index:10;box-shadow:0 2px 8px rgba(0,0,0,0.2)}
.let-cell.let-sel{background:var(--color-primary-light)!important;border-color:var(--color-primary);color:var(--color-primary-dark);font-weight:900}
.let-cell.let-pos{background:rgba(63,81,181,0.1);border-color:var(--color-primary-light)}
.let-cell.let-mar{color:white;font-weight:900;border-color:transparent}
</style>

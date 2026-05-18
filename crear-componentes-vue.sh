#!/bin/bash

# TopBar.vue
cat > src/components/TopBar.vue << 'EOF'
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
      <div class="control-group position-relative">
        <button v-if="!amaieraOrdua" class="btn btn-pausatu" @click="$emit('jokoaPausatu')">
          <span class="icon">⏸</span><span class="text">PAUSATU</span>
        </button>
        <div v-if="amaieraOrdua" class="denbora-erakutsi">
          <span>DENBORA: {{denbora}}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'TopBar',
  props: {
    tamaina: { type: Number, default: 12 },
    hasieraOrdua: { type: Number, default: 0 },
    amaieraOrdua: { type: Number, default: 0 },
    gehitutakoOrdua: { type: Number, default: 0 }
  },
  emits: ['tamainaAldatu', 'jokoaPausatu'],
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
    denbora() {
      if (!this.amaieraOrdua) return 'Amaitu gabe'
      let d = this.amaieraOrdua - this.hasieraOrdua + this.gehitutakoOrdua
      d = Math.floor(d / 1000)
      const s = d % 60
      const m = Math.floor((d - s) / 60) % 60
      const h = Math.floor((d - (m * 60) - s) / 3600)
      return `${h.toString().padStart(2, '0')}:${m.toString().padStart(2, '0')}:${s.toString().padStart(2, '0')}`
    },
    gutxienezkoZabalera() {
      return `${((20 + 20 - Math.floor(this.tamaina * 0.75)) * this.tamaina) + 32}px`
    }
  }
}
</script>

<style scoped>
.top-bar{background:white;border-bottom:3px solid var(--color-primary);padding:1rem;box-shadow:0 2px 4px rgba(0,0,0,0.1)}
.top-bar-content{display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:1rem}
.control-group{display:flex;align-items:center;justify-content:center}
.btn-tamaina{background:white;color:var(--color-warning);border:2px solid var(--color-warning);width:100%}
.btn-tamaina:hover{background:var(--color-warning);color:white}
.btn-joko-berria{background:var(--color-accent);color:white;width:100%}
.btn-joko-berria:hover{background:var(--color-primary-dark)}
.btn-pausatu{background:white;color:var(--color-text-secondary);border:2px solid var(--color-border);width:100%}
.btn-pausatu:hover{background:var(--color-background);border-color:var(--color-primary)}
.denbora-erakutsi{background:var(--color-success);color:white;padding:0.75rem 1.5rem;border-radius:4px;font-weight:600;text-align:center;width:100%}
.position-relative{position:relative}
@media (max-width:768px){.top-bar-content{grid-template-columns:1fr}}
</style>
EOF

# MatrixLetras.vue
cat > src/components/MatrixLetras.vue << 'EOF'
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
EOF

# ListaHitzak.vue
cat > src/components/ListaHitzak.vue << 'EOF'
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
.palabra{padding:0.75rem 1rem;text-align:center;font-weight:600;border-radius:6px;background:var(--color-background);color:var(--color-text);border:2px solid var(--color-border);transition:all 0.3s;font-size:0.95rem;letter-spacing:0.5px}
.palabra:not(.encontrada):hover{transform:translateY(-2px);box-shadow:0 4px 8px rgba(0,0,0,0.1);border-color:var(--color-primary)}
.palabra.encontrada{color:white;border-color:transparent;font-weight:700;position:relative;overflow:hidden}
.palabra.encontrada::after{content:'✓';position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);font-size:2rem;opacity:0.3}
@media (max-width:768px){.list-pals{grid-template-columns:repeat(auto-fill,minmax(120px,1fr));gap:0.5rem}.palabra{padding:0.5rem 0.75rem;font-size:0.85rem}}
</style>
EOF

# IntroJokoa.vue
cat > src/components/IntroJokoa.vue << 'EOF'
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
EOF

# main.js
cat > src/main.js << 'EOF'
import { createApp } from 'vue'
import App from './App.vue'

createApp(App).mount('#app')
EOF

# index.html
cat > index.html << 'EOF'
<!doctype html>
<html lang="eu">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/vite.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Hitz-Zopa Euskeraz - Vue 3</title>
  </head>
  <body>
    <div id="app"></div>
    <script type="module" src="/src/main.js"></script>
  </body>
</html>
EOF

# package.json
cat > package.json << 'EOF'
{
  "name": "sopa-euskera-vue3",
  "private": true,
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "vue": "^3.4.0"
  },
  "devDependencies": {
    "@vitejs/plugin-vue": "^5.0.0",
    "vite": "^5.2.0"
  }
}
EOF

# vite.config.js
cat > vite.config.js << 'EOF'
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
})
EOF

# README
cat > README.md << 'EOF'
# 🎮 Hitz-Zopa Euskeraz - Vue 3

Sopa de letras en euskera con Vue 3 + Vite.

## 🚀 Instalación

```bash
npm install
```

## 💻 Ejecución

```bash
npm run dev
```

Abre http://localhost:5173

## 🎯 Características

- ✅ Tamaño variable (8x8 hasta 20x20)
- ✅ Más palabras en tableros grandes
- ✅ 120+ palabras euskera
- ✅ Frases escritores vascos
- ✅ Cronómetro
- ✅ Responsive
- ✅ Compatible con CUALQUIER macOS

## 🔧 Build

```bash
npm run build
```

¡Gozatu! 🎉
EOF

echo "✓ Vue 3 COMPLETO"

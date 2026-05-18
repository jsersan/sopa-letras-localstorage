#!/bin/bash

echo "🚀 Creando Vue 3 completo..."

# App.vue principal
cat > src/App.vue << 'EOF'
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
EOF

# SopaDeLetras.vue - Componente principal
cat > src/components/SopaDeLetras.vue << 'EOF'
<template>
  <div class="sopa-container">
    <IntroJokoa 
      v-if="!jokoaHasita"
      :tamaina="tamaina"
      :esaldia="esaldia"
      :gehitutakoOrdua="gehitutakoOrdua"
      @tamainaAldatu="aldatuTamaina"
      @jokoaHasi="jokoaHasi"
    />
    
    <div v-if="jokoaHasita" class="jokoa">
      <TopBar
        :tamaina="tamaina"
        :hasieraOrdua="hasieraOrdua"
        :amaieraOrdua="amaieraOrdua"
        :gehitutakoOrdua="gehitutakoOrdua"
        @tamainaAldatu="aldatuTamaina"
        @jokoaPausatu="jokoaPausatu"
      />
      
      <div class="joko-edukia">
        <MatrixLetras
          :sopa="sopa"
          :tamaina="tamaina"
          @gelaxkaHautatua="gelaxkaKlikatu"
        />
        
        <ListaHitzak :hitzak="hitzak" />
      </div>
    </div>
  </div>
</template>

<script>
import TopBar from './TopBar.vue'
import MatrixLetras from './MatrixLetras.vue'
import ListaHitzak from './ListaHitzak.vue'
import IntroJokoa from './IntroJokoa.vue'
import { hitzak, esaldiak } from '../assets/js/Recursos'

export default {
  name: 'SopaDeLetras',
  components: { TopBar, MatrixLetras, ListaHitzak, IntroJokoa },
  data() {
    return {
      alfab: 'ABCDEFGHIJKLMNÑOPQRSTUVWXYZ',
      jokoaHasita: false,
      sopa: [],
      hitzak: [],
      tamaina: 12,
      hasieraOrdua: 0,
      amaieraOrdua: 0,
      gehitutakoOrdua: 0,
      esaldia: null,
      hasieraGelaxka: null,
      hautatzen: false
    }
  },
  mounted() {
    this.sopaSortu()
  },
  computed: {
    jokoaOsatuta() {
      return this.hitzak.every(h => h.e)
    }
  },
  methods: {
    aldatuTamaina(tamainaBerria) {
      this.tamaina = tamainaBerria
      this.sopaSortu()
      this.jokoaHasi()
    },
    sopaSortu() {
      this.amaieraOrdua = 0
      this.hasieraGelaxka = null
      this.hautatzen = false
      
      const hitzZerrenda = this.hitzakLortu(this.tamaina)
      this.sopa = this.sopaHutsaSortu(this.tamaina)
      this.hitzak = hitzZerrenda.map(h => ({
        w: h,
        p: this.hitzaPrestatu(h),
        d: {},
        o: [],
        e: false,
        u: false,
        h: ''
      }))
      
      this.hitzak.sort((a, b) => b.p.length - a.p.length)
      this.hitzak.forEach((hitza, idx) => {
        this.aukerakKalkulatu(hitza)
        if (hitza.o.length > 0) {
          this.hitzaJarri(hitza, idx)
        }
      })
      
      this.hitzak = this.hitzak.filter(h => h.u)
      this.hutsunakBete()
    },
    hitzakLortu(tamaina) {
      const max = tamaina
      const min = Math.ceil(tamaina / 3 - 1)
      const kopurua = Math.ceil(tamaina * 1.5)
      
      const baliozkoak = hitzak.filter(h => h.length <= max && h.length > min)
      baliozkoak.sort((a, b) => b.length - a.length)
      
      const aukeratuak = []
      const erabilitakoak = new Set()
      
      for (let i = 0; i < kopurua && i < baliozkoak.length; i++) {
        const idx = Math.floor(Math.random() * baliozkoak.length)
        const hitza = baliozkoak[idx]
        if (!erabilitakoak.has(hitza)) {
          aukeratuak.push(hitza)
          erabilitakoak.add(hitza)
          baliozkoak.splice(idx, 1)
        }
      }
      return aukeratuak
    },
    sopaHutsaSortu(tam) {
      const sopa = []
      for (let y = 0; y < tam; y++) {
        const errenkada = []
        for (let x = 0; x < tam; x++) {
          errenkada.push({
            l: '', x, y, n: y * tam + x, s: false, h: '',
            c: { 'let-sel': false, 'let-pos': false, 'let-mar': false }
          })
        }
        sopa.push(errenkada)
      }
      return sopa
    },
    hitzaPrestatu(hitza) {
      return hitza.toUpperCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '')
    },
    aukerakKalkulatu(hitza) {
      let oid = 0
      for (let cy = 0; cy < this.tamaina; cy++) {
        for (let cx = 0; cx < this.tamaina; cx++) {
          for (let j = -1; j <= 1; j++) {
            for (let i = -1; i <= 1; i++) {
              if (i === 0 && j === 0) continue
              let ok = true, z = 0
              for (let l = 0; l < hitza.p.length; l++) {
                const ty = l * j + cy, tx = l * i + cx
                if (tx >= 0 && tx < this.tamaina && ty >= 0 && ty < this.tamaina) {
                  if (this.sopa[ty][tx].l !== '' && this.sopa[ty][tx].l !== hitza.p[l]) {
                    ok = false
                    break
                  } else if (this.sopa[ty][tx].l === hitza.p[l]) z++
                } else {
                  ok = false
                  break
                }
              }
              if (ok) {
                oid++
                hitza.o.push({
                  a: { x: cx, y: cy },
                  b: { x: cx + (hitza.p.length - 1) * i, y: cy + (hitza.p.length - 1) * j },
                  c: { x: i, y: j },
                  id: oid,
                  z
                })
              }
            }
          }
        }
      }
    },
    hitzaJarri(hitza, idx) {
      let aukeratua = hitza.o
      const t = 5
      
      if (idx % t === 1) {
        const horizontalak = hitza.o.filter(op => Math.abs(op.c.y) === 0)
        if (horizontalak.length) aukeratua = horizontalak
      } else if (idx % t === 2) {
        const bertikalak = hitza.o.filter(op => Math.abs(op.c.x) === 0)
        if (bertikalak.length) aukeratua = bertikalak
      } else if (idx % t === 3) {
        const diagonalak = hitza.o.filter(op => Math.abs(op.c.x) === Math.abs(op.c.y))
        if (diagonalak.length) aukeratua = diagonalak
      } else if (idx % t === 4) {
        const gainjartzeak = hitza.o.filter(op => op.z > 0)
        if (gainjartzeak.length) aukeratua = gainjartzeak
      }
      
      if (!aukeratua.length) return
      
      const r = Math.floor(Math.random() * aukeratua.length)
      const aukera = aukeratua[r]
      
      for (let l = 0; l < hitza.p.length; l++) {
        const ny = l * aukera.c.y + aukera.a.y
        const nx = l * aukera.c.x + aukera.a.x
        this.sopa[ny][nx].l = hitza.p[l]
      }
      
      hitza.d = aukera
      hitza.u = true
      hitza.h = `rgb(${Math.floor(Math.random()*96+96)},${Math.floor(Math.random()*96+96)},${Math.floor(Math.random()*96+96)})`
      hitza.o = []
    },
    hutsunakBete() {
      for (let y = 0; y < this.tamaina; y++) {
        for (let x = 0; x < this.tamaina; x++) {
          if (this.sopa[y][x].l === '') {
            this.sopa[y][x].l = this.alfab[Math.floor(Math.random() * this.alfab.length)]
          }
        }
      }
    },
    jokoaHasi() {
      this.jokoaHasita = true
      this.gehitutakoOrdua = 0
      this.hasieraOrdua = Date.now()
    },
    jokoaPausatu() {
      if (!this.jokoaOsatuta) {
        this.esaldia = esaldiak[Math.floor(Math.random() * esaldiak.length)]
        this.jokoaHasita = false
        const pausa = Date.now()
        this.gehitutakoOrdua += pausa - this.hasieraOrdua
        this.hasieraOrdua = pausa
      }
    },
    gelaxkaKlikatu(gelaxka) {
      if (this.jokoaOsatuta) return
      
      this.markatuGarbitu()
      
      if (!this.hautatzen) {
        this.posibleakMarkatu(gelaxka)
        this.hasieraGelaxka = gelaxka
        this.hautatzen = true
      } else {
        const hitza = this.hitzaBilatu(this.hasieraGelaxka, gelaxka)
        if (hitza) {
          this.hitzaMarkatu(hitza)
        }
        this.hautatzen = false
        this.hasieraGelaxka = null
        if (this.jokoaOsatuta) {
          this.amaieraOrdua = Date.now()
        }
      }
    },
    markatuGarbitu() {
      for (let y = 0; y < this.tamaina; y++) {
        for (let x = 0; x < this.tamaina; x++) {
          this.sopa[y][x].c['let-sel'] = false
          this.sopa[y][x].c['let-pos'] = false
        }
      }
    },
    posibleakMarkatu(gelaxka) {
      for (let p = 1; p < this.tamaina * 2; p++) {
        for (let i = -1; i <= 1; i++) {
          for (let j = -1; j <= 1; j++) {
            const x = gelaxka.x + p * i
            const y = gelaxka.y + p * j
            if (x >= 0 && x < this.tamaina && y >= 0 && y < this.tamaina) {
              this.sopa[y][x].c['let-pos'] = true
            }
          }
        }
      }
      gelaxka.c['let-sel'] = true
      gelaxka.c['let-pos'] = false
    },
    hitzaBilatu(hasiera, amaiera) {
      return this.hitzak.find(h => 
        (h.d.a.x === hasiera.x && h.d.a.y === hasiera.y && h.d.b.x === amaiera.x && h.d.b.y === amaiera.y) ||
        (h.d.b.x === hasiera.x && h.d.b.y === hasiera.y && h.d.a.x === amaiera.x && h.d.a.y === amaiera.y)
      )
    },
    hitzaMarkatu(hitza) {
      for (let l = 0; l < hitza.p.length; l++) {
        const ny = l * hitza.d.c.y + hitza.d.a.y
        const nx = l * hitza.d.c.x + hitza.d.a.x
        this.sopa[ny][nx].c['let-mar'] = true
        this.sopa[ny][nx].s = true
        this.sopa[ny][nx].h = hitza.h
      }
      hitza.e = true
    }
  }
}
</script>

<style scoped>
.sopa-container {
  min-height: 100vh;
}

.jokoa {
  display: flex;
  flex-direction: column;
  animation: fadeIn 0.5s ease;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

.joko-edukia {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1rem;
  padding: 1rem;
}

@media (min-width: 1024px) {
  .joko-edukia {
    grid-template-columns: auto 1fr;
  }
}
</style>
EOF

echo "✓ SopaDeLetras.vue creado"


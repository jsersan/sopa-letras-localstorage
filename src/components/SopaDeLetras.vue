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
        @tamainaAldatu="aldatuTamaina"
        @jokoaPausatu="jokoaPausatu"
        @recordakIkusi="erakutsiPantailaRecordak = true"
      />
      
      <div class="joko-edukia">
        <MatrixLetras
          :sopa="sopa"
          :tamaina="tamaina"
          @gelaxkaHautatua="gelaxkaKlikatu"
        />
        
        <ListaHitzak :hitzak="hitzak" />
      </div>

      <Kronometroa
        v-if="!amaieraOrdua"
        :hasieraOrdua="hasieraOrdua"
        :amaieraOrdua="amaieraOrdua"
        :gehitutakoOrdua="gehitutakoOrdua"
      />
    </div>

    <PantailaAmaiera
      :erakutsi="erakutsiPantailaAmaiera"
      :denbora="denboraOsoa"
      :tamaina="tamaina"
      @jokoaHasi="hasieraBerriaEgin"
    />

    <PantailaRecordak
      :erakutsi="erakutsiPantailaRecordak"
      @itxi="erakutsiPantailaRecordak = false"
    />
  </div>
</template>

<script>
import TopBar from './TopBar.vue'
import MatrixLetras from './MatrixLetras.vue'
import ListaHitzak from './ListaHitzak.vue'
import IntroJokoa from './IntroJokoa.vue'
import PantailaAmaiera from './PantailaAmaiera.vue'
import PantailaRecordak from './PantailaRecordak.vue'
import Kronometroa from './Kronometroa.vue'
import { hitzak, esaldiak } from '../assets/js/Recursos'

export default {
  name: 'SopaDeLetras',
  components: { TopBar, MatrixLetras, ListaHitzak, IntroJokoa, PantailaAmaiera, PantailaRecordak, Kronometroa },
  data() {
    return {
      alfab: 'ABDEFGHIJKLMNÑOPQRSTUXYZ',
      jokoaHasita: false,
      sopa: [],
      hitzak: [],
      tamaina: 12,
      hasieraOrdua: 0,
      amaieraOrdua: 0,
      gehitutakoOrdua: 0,
      esaldia: null,
      hasieraGelaxka: null,
      hautatzen: false,
      erakutsiPantailaAmaiera: false,
      erakutsiPantailaRecordak: false
    }
  },
  mounted() {
    this.sopaSortu()
  },
  computed: {
    jokoaOsatuta() {
      return this.hitzak.every(h => h.e)
    },
    denboraOsoa() {
      return this.amaieraOrdua - this.hasieraOrdua + this.gehitutakoOrdua
    }
  },
  watch: {
    jokoaOsatuta(berria) {
      if (berria && this.jokoaHasita) {
        this.amaieraOrdua = Date.now()
        setTimeout(() => {
          this.erakutsiPantailaAmaiera = true
        }, 500)
      }
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
      this.erakutsiPantailaAmaiera = false
      
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
          const colocada = this.hitzaJarriKonDistantzia(hitza, idx)
          if (!colocada) {
            hitza.u = false
          }
        }
      })
      
      this.hitzak = this.hitzak.filter(h => h.u)
      this.hutsunakBete()
    },
    hitzakLortu(tamaina) {
      const max = tamaina
      const min = Math.ceil(tamaina / 3 - 1)
      const kopurua = Math.ceil(tamaina * 1.0)
      
      const baliozkoak = hitzak.filter(h => {
        const hPrep = this.hitzaPrestatu(h)
        return h.length <= max && 
               h.length > min && 
               !hPrep.includes('C') && 
               !hPrep.includes('V')
      })
      
      baliozkoak.sort((a, b) => b.length - a.length)
      
      const aukeratuak = []
      const erabilitakoak = new Set()
      
      for (let i = 0; i < kopurua && baliozkoak.length > 0; i++) {
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
            l: '', 
            x, 
            y, 
            n: y * tam + x, 
            s: false, 
            h: '',
            ocupada: false,
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
    hitzaJarriKonDistantzia(hitza, idx) {
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
      
      if (!aukeratua.length) return false
      
      const maxIntentos = aukeratua.length
      for (let intento = 0; intento < maxIntentos; intento++) {
        const r = Math.floor(Math.random() * aukeratua.length)
        const aukera = aukeratua[r]
        
        if (this.bideaLibrea(hitza, aukera)) {
          for (let l = 0; l < hitza.p.length; l++) {
            const ny = l * aukera.c.y + aukera.a.y
            const nx = l * aukera.c.x + aukera.a.x
            this.sopa[ny][nx].l = hitza.p[l]
          }
          
          this.markatuProximitatea(hitza, aukera)
          
          hitza.d = aukera
          hitza.u = true
          hitza.h = `rgb(${Math.floor(Math.random()*96+96)},${Math.floor(Math.random()*96+96)},${Math.floor(Math.random()*96+96)})`
          hitza.o = []
          return true
        }
        
        aukeratua.splice(r, 1)
        if (aukeratua.length === 0) break
      }
      
      return false
    },
    bideaLibrea(hitza, aukera) {
      for (let l = 0; l < hitza.p.length; l++) {
        const ny = l * aukera.c.y + aukera.a.y
        const nx = l * aukera.c.x + aukera.a.x
        
        const celdaActual = this.sopa[ny][nx]
        
        if (celdaActual.ocupada && celdaActual.l !== '' && celdaActual.l !== hitza.p[l]) {
          return false
        }
        
        for (let dy = -1; dy <= 1; dy++) {
          for (let dx = -1; dx <= 1; dx++) {
            if (dx === 0 && dy === 0) continue
            
            const checkY = ny + dy
            const checkX = nx + dx
            
            if (checkX >= 0 && checkX < this.tamaina && checkY >= 0 && checkY < this.tamaina) {
              const celdaVecina = this.sopa[checkY][checkX]
              
              const esDireccionPalabra = (dx === aukera.c.x && dy === aukera.c.y) || 
                                         (dx === -aukera.c.x && dy === -aukera.c.y)
              
              if (!esDireccionPalabra && celdaVecina.ocupada && celdaVecina.l !== '') {
                return false
              }
            }
          }
        }
      }
      
      return true
    },
    markatuProximitatea(hitza, aukera) {
      for (let l = 0; l < hitza.p.length; l++) {
        const ny = l * aukera.c.y + aukera.a.y
        const nx = l * aukera.c.x + aukera.a.x
        this.sopa[ny][nx].ocupada = true
        
        for (let dy = -1; dy <= 1; dy++) {
          for (let dx = -1; dx <= 1; dx++) {
            const checkY = ny + dy
            const checkX = nx + dx
            
            if (checkX >= 0 && checkX < this.tamaina && checkY >= 0 && checkY < this.tamaina) {
              const esDireccionPalabra = (dx === aukera.c.x && dy === aukera.c.y) || 
                                         (dx === -aukera.c.x && dy === -aukera.c.y) ||
                                         (dx === 0 && dy === 0)
              
              if (!esDireccionPalabra) {
                this.sopa[checkY][checkX].ocupada = true
              }
            }
          }
        }
      }
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
      if (this.gehitutakoOrdua === 0) {
        this.hasieraOrdua = Date.now()
      } else {
        this.hasieraOrdua = Date.now()
      }
    },
    jokoaPausatu() {
      if (!this.jokoaOsatuta) {
        this.esaldia = esaldiak[Math.floor(Math.random() * esaldiak.length)]
        
        const orain = Date.now()
        this.gehitutakoOrdua += orain - this.hasieraOrdua
        
        this.jokoaHasita = false
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
    },
    hasieraBerriaEgin() {
      this.erakutsiPantailaAmaiera = false
      this.gehitutakoOrdua = 0
      this.sopaSortu()
      this.jokoaHasi()
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
  padding-bottom: 6rem;
}

@media (min-width: 1024px) {
  .joko-edukia {
    grid-template-columns: auto 1fr;
  }
}
</style>

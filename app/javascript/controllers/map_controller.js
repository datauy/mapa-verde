import { Controller } from "@hotwired/stimulus"
import "leaflet"
//access variable in Wkt.default
import * as Wkt from "wicket"

export default class extends Controller { 
  static values = { orgId: Number }
  static total = 0
  static allLayers
  static currentLayer

  connect() {
    if ( typeof(window.mapa) === 'undefined' ) {
      window.Mapa = this;
      window.currentLayer = new L.FeatureGroup();
      window.allLayers = new L.FeatureGroup();
      window.active_filters = {
        'otypes': [],
        'zones': [],
        'subjects': [],
        'actions': [],
        'text': "",
        };
      window.mapa = L.map('map', {scrollWheelZoom: false}).setView([-34.897013, -56.171186], 13);
      L.tileLayer('https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png', {
        maxZoom: 19,
        subdomains: 'abcd',
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors &copy; <a href="https://carto.com/attributions">CARTO</a>'
      }).addTo(window.mapa);
      window.mapa.zoomControl.setPosition('topright');
    }
  }
  clearFilters() {
    window.active_filters = {
      'otypes': [],
      'zones': [],
      'subjects': [],
      'actions': [],
      'text': "",
    };
    this.search(null)
    document.querySelectorAll('#filters li.active').forEach(element => {
      element.classList.toggle('active')
    });
  }
  renderZones(org, initial = false) {
    this.total = data.length;
    let orgs = data;
    var wkt = new Wkt.default.Wkt();
    if ( !initial ) {
      window.mapa.removeLayer(window.currentLayer);
      currentLayer.eachLayer(function (layer) {
        currentLayer.removeLayer(layer);
      });
    }
    if ( org !== undefined ) {
      orgs = [data[org]];
    }
    orgs.forEach((org, idx) => {
      var zonesData = [];
      org.zones.forEach(zone_id => {
        if ( zones[zone_id].geometry !== null ) {
          wkt.read(zones[zone_id].geometry);
          zonesData.push({ 
            "type": "Feature",
            'properties': {
              zoneId: zone_id
            }, "geometry": wkt.toJson() 
          });
        }
      });
      L.geoJSON(zonesData, {
        fillColor: subjects[org.subject_id].color,
        color: subjects[org.subject_id].color,
        onEachFeature: (feature, layer) => {
          layer.on({
            click: (e) => {
              let zoneId = e.target.feature.properties.zoneId
              document.querySelector('li[data-value="'+zoneId+'"]').click()
            }            
          })
        }
      }).addTo(window.currentLayer);
      if ( initial ) {
        L.geoJSON(zonesData).addTo(window.allLayers);
      }
    });
    var bounds = window.currentLayer.getBounds();
    if ( Object.keys(bounds).length ) {
      window.mapa.flyToBounds(window.currentLayer.getBounds());
    }
    window.currentLayer.addTo(window.mapa);
  }
  toggleDesc(orgId) {
    var srv = document.getElementById('org-'+orgId);
    if ( !srv.classList.contains('active') ) {
      document.querySelectorAll('.org').forEach(i => i.classList.remove('active'))
      srv.classList.add("active");
      var position = srv.offsetTop - document.getElementById('org-0').offsetTop;
      document.getElementById('list').scrollTo(0, position);
      //document.getElementById('srv-'+id).scrollIntoView({behavior: 'smooth'});
    }
    else {
      document.querySelectorAll('.org').forEach(i => i.classList.remove('active'))
      orgId = undefined;
    }
    this.renderZones(orgId);
  }
  change(event) {
    //const frame = document.getElementById("map_filters");
    //console.log("CHANGE MAP");
    //frame.src = "/search.turbo_stream";
    //frame.reload(); // there is no need to reload
  }
  search(event) {
    if ( event !== null ) {
      //Handle filters
      let cat = event.target.dataset.category;
      let value = event.target.dataset.value;
      if ( cat == 'text' ) {
        window.active_filters[cat] = document.getElementById('search-text').value
        if (window.active_filters[cat].length < 3 )
          return
      }
      else {
        if ( event.target.classList.contains('active') ) {
          window.active_filters[cat].splice(window.active_filters[cat].indexOf(value), 1);
        }
        else {
          window.active_filters[cat].push(value);
        }
        event.target.classList.toggle('active');
      }
    }
    // Create URL
    let url = new URL(window.location.protocol+"//"+window.location.hostname+(window.location.port.length !== 0 ? ":"+window.location.port : '')+"/search");
    Object.keys(window.active_filters).forEach( cat => {
      if ( window.active_filters[cat].length ) {
        if ( cat == 'text' ) {
          url.searchParams.append(cat, window.active_filters[cat]);
        }
        else {
          url.searchParams.append(cat, window.active_filters[cat].join(','));
        }
      }
    });
    fetch(url.href, {
      method: "GET",
      headers: {
        Accept: "text/vnd.turbo-stream.html"
      }
    })
    .then(r => r.text())
    .then(html => {
      Turbo.renderStreamMessage(html)
      if (event !== null ) {
        event.target.parentNode.classList.remove('active')
      }
    })
  }
}

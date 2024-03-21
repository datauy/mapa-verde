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
    if (typeof(data) !== 'undefined' && data.length &&  typeof(window.Mapa) === 'undefined' ) {
      window.active_filters = {
        'otypes': [],
        'zones': [],
        'subjects': [],
        'actions': [],
        };
      window.Mapa = this;
      this.renderMap();
    }
  }
  clearFilters() {
    window.active_filters = {
      'otypes': [],
      'zones': [],
      'subjects': [],
      'actions': [],
      };
      this.search(null)
      $('#filters li.active').toggleClass('active')
  }
  renderMap() {
    //Obtain data from the json file
    window.currentLayer = new L.FeatureGroup();
    window.allLayers = new L.FeatureGroup();
    //window.elements = data;
    this.total = data.length;
    //MAP
    window.map = L.map('map', {scrollWheelZoom: false}).setView([-34.897013, -56.171186], 13);
    L.tileLayer('https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png', {
      maxZoom: 19,
      subdomains: 'abcd',
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors &copy; <a href="https://carto.com/attributions">CARTO</a>'
    }).addTo(map);
    map.zoomControl.setPosition('topright');
    // FILL DATA
    this.renderZones(undefined, true);
  }
  renderZones(org, initial = false) {
    let orgs = data;
    var wkt = new Wkt.default.Wkt();
    if ( !initial ) {
      map.removeLayer(window.currentLayer);
      currentLayer.eachLayer(function (layer) {
        currentLayer.removeLayer(layer);
      });
    }
    if ( org !== undefined ) {
      orgs = [data[org]];
    }
    orgs.forEach(org => {
      var zonesData = [];
      org.zones.forEach(zone_id => {
        wkt.read(zones[zone_id].geometry);
        zonesData.push({ 
          "type": "Feature",
          'properties': {
            "name": "Coors Field",
            "popupContent": "This is where the Rockies play!"
          }, "geometry": wkt.toJson() 
        }); 
      });
      L.geoJSON(zonesData).addTo(window.currentLayer);
      if ( initial ) {
        L.geoJSON(zonesData).addTo(window.allLayers);
      }
      document.getElementById("results").innerHTML = "Mostrando "+data.length+"/"+this.total+" puntos";
    });
    var bounds = window.currentLayer.getBounds();
    if ( Object.keys(bounds).length ) {
      map.flyToBounds(window.currentLayer.getBounds());
    }
    window.currentLayer.addTo(map);
  }
  toggleDesc(orgId) {
    var srv = jQuery('#org-'+orgId);
    if ( !srv.hasClass('active') ) {
      var position = jQuery('#org-'+orgId).offset().top - jQuery('#org-0').offset().top;
      jQuery("#list").animate({
        scrollTop: position
      }, 1000, 'linear' );
      //document.getElementById('srv-'+id).scrollIntoView({behavior: 'smooth'});
      jQuery('.org').removeClass('active');
      srv.addClass("active");
      //map.flyTo( [currentList[id].lat, currentList[id].lng], 18);

    }
    else {
      jQuery('.org').removeClass('active');
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
      if ( event.target.classList.contains('active') ) {
        window.active_filters[cat].splice(window.active_filters[cat].indexOf(value), 1);
      }
      else {
        window.active_filters[cat].push(value);
      }
      event.target.classList.toggle('active');
    }
    // Create URL
    let url = new URL("http://localhost:3000/search");
    Object.keys(window.active_filters).forEach( cat => {
      if ( window.active_filters[cat].length ) {
        url.searchParams.append(cat, window.active_filters[cat].join(','));
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

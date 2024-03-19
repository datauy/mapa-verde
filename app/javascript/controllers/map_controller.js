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
    window.Map = this;
    this.renderMap();
  }
  renderMap() {
    //Obtain data from the json file
    console.log(data);
    window.currentLayer = new L.FeatureGroup();
    window.allLayers = new L.FeatureGroup();
    //window.elements = data;
    this.total = data.length;
    const mapBounds = [];
    const otype_options = [];
    const obj_options = [];
    var currentList = [];
    var min_max_age = [];
    var active_filters = {
    'otype': [],
    'obj': [],
    'age': -1,
    'summ': false,
    'ext': false,
    'search_res': ''
    };
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
    console.log("BOUNDS: ", bounds);
    if ( Object.keys(bounds).length ) {
      map.flyToBounds(window.currentLayer.getBounds());
    }
    window.currentLayer.addTo(map);
  }
}

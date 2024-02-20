import { Controller } from "@hotwired/stimulus"
import "leaflet"
//access variable in Wkt.default
import * as Wkt from "wicket"

export default class extends Controller { 
  connect() {
    //Obtain data from the json file
console.log(data);
//window.elements = data;
const total = data.length;
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
var markers = L.layerGroup();
var map = L.map('map', {scrollWheelZoom: false}).setView([-34.897013, -56.171186], 13);
L.tileLayer('https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png', {
   maxZoom: 19,
   subdomains: 'abcd',
   attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors &copy; <a href="https://carto.com/attributions">CARTO</a>'
}).addTo(map);
map.zoomControl.setPosition('topright');
//LIST
// FILL DATA
clearFilters(true);
//Add filters
var otype_options_dom = document.getElementById('otype');
for (var i = 0; i < otype_options.length; i++){
 otype_options_dom.innerHTML += '<li class="option otype-option" id="otype-option-'+i+'" onclick="toggleOption(\'otype\', '+i+', this)">'+otype_options[i]+'</li>';
}
var obj_options_dom = document.getElementById('objetivo');
for (var i = 0; i < obj_options.length; i++){
  const style = get_style(obj_options[i]);
  obj_options_dom.innerHTML += '<li class="option obj-option" id="obj-option-'+i+'" onclick="toggleOption(\'obj\', '+i+', this)"><i style="color: '+style.color+'" class="fas fa-'+style.icon+'"></i>'+obj_options[i]+'</li>';
}

//Add listeners
jQuery('#extendido').change(() => {
 if(jQuery('#extendido').is(':checked')) {
   active_filters.ext = true;
 }
 else {
   active_filters.ext = false;
 }
 reloadFilters();
});
jQuery('#verano').change(() => {
 if( jQuery('#verano').is(':checked') ) {
   active_filters.summ = true;
 }
 else {
   active_filters.summ = false;
 }
 reloadFilters();
});
jQuery('#edad').change(() => {
 active_filters.age = jQuery('#edad').val();
 reloadFilters();
});
jQuery('#search-res').change(() => {
 active_filters.search_res = jQuery('#search-res').val();
 reloadFilters();
});
jQuery('.backdrop').click(() => {
 jQuery('#objetivo').hide();
 jQuery('#otype').hide();
 jQuery('.backdrop').hide();
 reloadFilters();
});
//FUNCTIONS
//Display options
function toggleOptions(id) {
 var options = jQuery("#"+id);
 if ( options.is(":hidden") ) {
   options.show();
   jQuery('.backdrop').show();
 }
 else {
   reloadFilters();
   options.hide();
 }
}
//Filter by option
function toggleOption(cont, id) {
 var index = active_filters[cont].indexOf(id);
 if ( index !== -1 ) {
   active_filters[cont].splice(index, 1);
   jQuery('#'+cont+'-option-'+id).removeClass("active");
 }
 else {
   active_filters[cont].push(id);
   jQuery('#'+cont+'-option-'+id).addClass("active");
 }
}
// show description
function toggleDesc(id) {
 var srv = jQuery('#srv-'+id);
 if ( srv.hasClass('active') ) {
   jQuery('.srv').removeClass('active');
 }
 else {
   jQuery('.srv').removeClass('active');
   var position = jQuery('#srv-'+id).offset().top - jQuery('#srv-0').offset().top;
   jQuery("#list").animate({
     scrollTop: position
   }, 1000, 'linear' );
   //document.getElementById('srv-'+id).scrollIntoView({behavior: 'smooth'});
   srv.addClass("active");
   map.flyTo( [currentList[id].lat, currentList[id].lng], 18);
 }
}

// Click PIN
function clickPin(pin) {
 let pos = pin.target.options.list_pos;
 toggleDesc(pos);
}
//Clear filters
function clearFilters(initial = false) {
 document.getElementById("edad").value = '';
 document.getElementById("extendido").checked = false;
 document.getElementById("verano").checked = false;
 document.getElementById("search-res").value = '';

 renderElements(data, initial);
}
//FILTER
function reloadFilters() {
 // If fiter is set
 if ( active_filters['obj'].length > 0 || active_filters['otype'].length > 0  || active_filters['age'] >= 0 || active_filters['summ'] ||  active_filters['ext'] || active_filters['search_res'] != '') {
   result = [];
   active_obj = active_filters['obj'].map( x => obj_options[x]);
   active_otype = active_filters['otype'].map( x => otype_options[x]);
   data.forEach((element, i) => {
     var include = false;
     if ( active_filters['obj'].length > 0 ) {
       var match = false;
       active_obj.forEach((item) => {
         if ( element[item] == "TRUE") {
           match = true;
           return;
         }
       });
       if ( match ) {
         include = true;
       }
       else {
         include = false;
         return;
       }
     }
     if ( active_filters['otype'].length > 0 ) {
       if ( active_otype.includes(element.tipo_centro) ) {
         include = true;
       }
       else {
         include = false;
         return;
       }
     }
     if ( active_filters['age'] >= 0 ) {
       if ( element['edad_mínima'] <= active_filters['age'] && active_filters['age'] <= element['edad_máxima'] ) {
         include = true;
       }
       else {
         include = false;
         return;
       }
     }
     if ( active_filters['ext'] ) {
       if ( element.extendido == "TRUE" ) {
         include = true;
       }
       else {
         include = false;
         return;
       }
     }
     if ( active_filters['summ'] ) {
       if ( element.verano == "TRUE" ) {
         include = true;
       }
       else {
         include = false;
         return;
       }
     }
     if ( active_filters['search_res'] != '' ) {
       if ( Object.values(element).join(" ").toLowerCase().search(active_filters['search_res'].toLowerCase()) !== -1 ) {
         include = true;
       }
       else {
         include = false;
         return;
       }
     }
     if (include) {
       result.push(element);
     }
   });
 }
 else {
   result = data;
 }
 renderElements(result);
}
//Single element html
function elementListHtml(element, i) {
  const style = get_style(element.poblacion);
  return '<li onclick="toggleDesc('+ i +')" class="srv" id="srv-'+ i +'">\
     <div class="srv-header"><h2>'+element.name+'</h2><i style="color: '+style.color+'" class="fas fa-'+style.icon+'"></i></div>\
     <div class="srv-body">\
       <div class="row"><h3>'+element.otype+' - '+element.tipo_centro+'</h3></div>\
       <div class="row"><i class="fas fa-location-dot"></i><span>'+element.region+', '+element.address+'</span></div>\
       <div class="row"><i class="fas fa-phone"></i><span>'+element.phone+'</span></div>\
       <div class="row"><i class="fas fa-link"></i><span>'+element.website+'</span></div>\
       <div class="row"><i class="fas fa-envelope"></i><span>'+element.email+'</span></div>\
       <div class="row"><i class="fas fa-users"></i><span>'+element.subject_id+'</span></div>\
       <div class="row"><p>'+element.description+'</p></div>\
  </li>';
 }
 function get_style(element) {
   var res = {color: '#15BE5A', icon: 'person'};
   switch (element) {
     case 'Niños y niñas':
        res = {color: '#15BE5A', icon: 'child'};
        break;
      case 'Personas adultas mayores':
        res = {color: '#3E189B', icon: 'person-cane'};
        break;
      case 'Personas en situación de discapacidad intelectual':
        res = {color: '#FF702C', icon: 'brain'};
        break;
      case 'Personas con discapacidad':
      case 'Personas en situación de discapacidad':
        res = {color: '#FF702C', icon: 'wheelchair'};
        break;
      case 'Personas en situación de discapacidad visual':
        res = {color: '#FF702C', icon: 'person-walking-with-cane'};
        break;
      case 'Personas con dificultades en el aprendizaje':
        res = {color: '#FF702C', icon: 'book-open'};
        break;
    }
    return res;
 }
 function renderElements(elements, initial = false) {
   //Generate markers for all data rows |element = data[0]
   if ( elements.length > 0 ) {
    var wkt = new Wkt.default.Wkt();
     markers.clearLayers();
     jQuery('#no-results').hide();
     currentList = elements;
     var list = '<ul>';
     elements.forEach((element, i) => {
       list += elementListHtml(element, i);
        //Map
        var zonesData = [];
      element.zones.forEach(zone => {
        wkt.read(zone.geometry);
        console.log(wkt.toJson());
        zonesData.push({ 
          "type": "Feature",
          'properties': {
            "name": "Coors Field",
            "popupContent": "This is where the Rockies play!"
          }, "geometry": wkt.toJson() 
        }); 
      });
      L.geoJSON(zonesData).addTo(map);
       /*var iconUrl = '/wp-content/uploads/sites/5/2022/10/icon-green.png';
       switch (element.poblacion) {
         case 'Personas adultas mayores':
         iconUrl = '/wp-content/uploads/sites/5/2022/10/icon-blue.png';
         break;
         case 'Personas con discapacidad':
         case 'Personas en situación de discapacidad':
         case 'Personas en situación de discapacidad visual':
         case 'Personas en situación de discapacidad intelectual':
         case 'Personas con dificultades en el aprendizaje':
         iconUrl = '/wp-content/uploads/sites/5/2022/10/icon-orange.png';
         break;
       }
       var iconDefault = L.icon({
         className: "marker",
         iconUrl: iconUrl,
         iconSize: [29, 37],
         iconAnchor: [12, 37],
         popupAnchor: [1, -34],
         tooltipAnchor: [16, -28],
         shadowSize: [41, 41]
       });
       var mark = L.marker([element['lat'],element['lng']], {icon: iconDefault, list_pos: i}).on('click', clickPin).addTo(markers);
       mapBounds.push([element.lat, element.lng]);
       */
       //Load filters if initial load
       if ( initial ) {
         if ( !otype_options.includes(element.tipo_centro) ) {
           otype_options.push(element.tipo_centro);
         }
         if ( !obj_options.includes(element.poblacion) ) {
           obj_options.push(element.poblacion);
         }
       }
     });
     list += '</ul>';
     //map.addLayer(markers);
     document.getElementById("list").innerHTML = list;
     document.getElementById("results").innerHTML = "Mostrando "+elements.length+"/"+total+" puntos";
     //map.flyToBounds(mapBounds);
   }
   else {
     jQuery('#no-results').show();
   }
 }
  }
}

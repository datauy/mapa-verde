import { Controller } from "@hotwired/stimulus"
// Connects to data-controller="list"
export default class extends Controller {
  static values = { orgId: Number }
  connect() {
  }
  // show description
  toggleDesc() {
    var srv = jQuery('#org-'+this.orgIdValue);
    var orgId = this.orgIdValue;
    if ( !srv.hasClass('active') ) {
      var position = jQuery('#org-'+this.orgIdValue).offset().top - jQuery('#org-0').offset().top;
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
    window.Map.renderZones(orgId);
  }
  getActivities() {
    fetch('/', { responseKind: "js"});
  }
}

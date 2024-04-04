import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"
import SlimSelect from "slim-select"
// Connects to data-controller="form"
export default class extends Controller {
  static targets = ["stateId"]
  connect() {
    console.log("ELEM", this.element);
    if ( this.element.id == 'new-activity') {
      flatpickr(".starts", {
        enableTime: true,
        dateFormat: 'Y/m/d h:i',
        time_24hr: true
      })
      flatpickr(".ends", {
        enableTime: true,
        dateFormat: 'Y/m/d h:i',
        time_24hr: true
      })
      new SlimSelect({
        select: "#activity_zone_ids",   // this.element is the <select> tag
        showSearch: true,       // show search field
        settings: {
          allowDeselect: true   // allow deselecting (x) option
        }
      })
      new SlimSelect({
        select: "#activity_organization_ids",   // this.element is the <select> tag
        showSearch: true,       // show search field
        settings: {
          allowDeselect: true   // allow deselecting (x) option
        }
      })
    }
    else if ( this.element.id == 'organization-form') {
      new SlimSelect({
        select: "#organization_zone_ids",   // this.element is the <select> tag
        showSearch: true,       // show search field
        settings: {
          allowDeselect: true   // allow deselecting (x) option
        }
      })
      
    }
  }
  select_state(e) {
    console.log("LOcation selected", this.stateIdTarget.value);
    fetch('/state_locations?state_id='+this.stateIdTarget.value, {
      method: "GET",
      headers: {
        Accept: "text/vnd.turbo-stream.html"
      }
    })
    .then(r => r.text())
    .then(html => {
      Turbo.renderStreamMessage(html)
      console.log("RENDER");
      this.delay(200).
      then(() => {
        console.log("delayed has items check")
        new SlimSelect({
          select: "#location_id",   // this.element is the <select> tag
          showSearch: true,       // show search field
          settings: {
            allowDeselect: true   // allow deselecting (x) option
          }
        })
      })
    })
  }
  delay(milliseconds){
    return new Promise(resolve => {
        setTimeout(resolve, milliseconds);
    })
  }
}

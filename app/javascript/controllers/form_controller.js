import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"
import SlimSelect from "slim-select"
// Connects to data-controller="form"
export default class extends Controller {
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
  }
  location_selected() {
    console.log("LOcation selected");
  }
}

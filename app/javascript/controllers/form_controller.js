import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"
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
    }
  }
  location_selected() {
    console.log("LOcation selected");
  }
}

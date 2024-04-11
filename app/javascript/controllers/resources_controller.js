import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="resources"
export default class extends Controller {
  connect() {
  }
  search(event) {
    if ( event !== null ) {
      //Handle filters
      let value = event.currentTarget.dataset.value;
      if ( window.active_filters.includes(value) ) {
        window.active_filters.splice(window.active_filters.indexOf(value), 1);
        event.currentTarget.classList.remove('active');
      }
      else {
        window.active_filters.push(value);
        event.currentTarget.classList.add('active');
      }
    }
    console.log("ACTIVE FILTERS", window.active_filters);
    // Create URL
    let url = new URL(window.location.protocol+"//"+window.location.hostname+(window.location.port.length !== 0 ? ":"+window.location.port : '')+"/recursos");
    Object.keys(window.active_filters).forEach( cat => {
        url.searchParams.append('subjects', window.active_filters.join(','));
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
    })
  }
}

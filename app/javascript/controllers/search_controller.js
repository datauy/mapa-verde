import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-org"
export default class extends Controller {
  static values = {
    'otype': [],
    'subjects': [],
    'actions': [],
    'zones': [],
  };
  connect() {
  }
}

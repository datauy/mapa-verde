import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"
import SlimSelect from "slim-select"
// Connects to data-controller="form"
export default class extends Controller {
  static targets = ["stateId", "image", "contactType", "errorContainer"]
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
        select: "#activity_subject_id",   // this.element is the <select> tag
        showSearch: true,       // show search field
        settings: {
          placeholderText: 'Temática principal',
          searchPlaceholder: 'Buscar',
          allowDeselect: true   // allow deselecting (x) option
        }
      })
      new SlimSelect({
        select: "#activity_zone_ids",   // this.element is the <select> tag
        showSearch: true,       // show search field
        settings: {
          placeholderText: 'Localidades de la actividad',
          searchPlaceholder: 'Buscar',
          allowDeselect: true   // allow deselecting (x) option
        }
      })
      new SlimSelect({
        select: "#activity_organization_ids",   // this.element is the <select> tag
        showSearch: true,       // show search field
        settings: {
          placeholderText: 'Organizaciones involucradas',
          searchPlaceholder: 'Buscar',
          allowDeselect: true   // allow deselecting (x) option
        }
      })
    }
    else if ( this.element.id == 'organization-form') {
      new SlimSelect({
        select: "#organization_organization_type_id",   // this.element is the <select> tag
        showSearch: true,       // show search field
        settings: {
          placeholderText: 'Tipo de organización',
          searchPlaceholder: 'Buscar',
          allowDeselect: true   // allow deselecting (x) option
        }
      })
      new SlimSelect({
        select: "#organization_region",   // this.element is the <select> tag
        showSearch: true,       // show search field
        settings: {
          placeholderText: 'Región',
          searchPlaceholder: 'Buscar',
          allowDeselect: true   // allow deselecting (x) option
        }
      })
      new SlimSelect({
        select: "#state_id",   // this.element is the <select> tag
        showSearch: true,       // show search field
        settings: {
          placeholderText: 'Departamento',
          searchPlaceholder: 'Buscar',
          allowDeselect: true   // allow deselecting (x) option
        }
      })
      new SlimSelect({
        select: "#organization_zone_ids",   // this.element is the <select> tag
        showSearch: true,       // show search field
        settings: {
          placeholderText: 'Zonas de trabajo',
          searchPlaceholder: 'Buscar',
          allowDeselect: true   // allow deselecting (x) option
        }
      })
      new SlimSelect({
        select: "#organization_subject_id",   // this.element is the <select> tag
        showSearch: true,       // show search field
        settings: {
          placeholderText: 'Temática principal',
          searchPlaceholder: 'Buscar',
          allowDeselect: true   // allow deselecting (x) option
        }
      })
    }
    else if ( this.element.id == 'contact-form') {
      new SlimSelect({
        select: "#static_pages_contact_type",   // this.element is the <select> tag
        showSearch: true,       // show search field
        settings: {
          placeholderText: 'Tipo de contacto',
          searchPlaceholder: 'Buscar',
          allowDeselect: true   // allow deselecting (x) option
        }
      })
      new SlimSelect({
        select: "#static_pages_organization",   // this.element is the <select> tag
        showSearch: true,       // show search field
        settings: {
          placeholderText: 'Organización involucrada',
          searchPlaceholder: 'Buscar',
          allowDeselect: true   // allow deselecting (x) option
        }
      })
      new SlimSelect({
        select: "#static_pages_activity",   // this.element is the <select> tag
        showSearch: true,       // show search field
        settings: {
          placeholderText: 'Actividad involucrada',
          searchPlaceholder: 'Buscar',
          allowDeselect: true   // allow deselecting (x) option
        }
      })
      new SlimSelect({
        select: "#state_id",   // this.element is the <select> tag
        showSearch: true,       // show search field
        settings: {
          placeholderText: 'Departamento',
          searchPlaceholder: 'Buscar',
          allowDeselect: true   // allow deselecting (x) option
        }
      })
    }
  }
  select_state(e) {
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
            searchPlaceholder: 'Buscar',
            allowDeselect: true   // allow deselecting (x) option
          }
        })
      })
    })
  }
  //
  select_image() {
    let image_holder = 'organization_logo'
    if ( this.element.id == 'new-activity') {
      image_holder = 'activity_image'
    }
    document.getElementById('image-name').innerHTML = document.getElementById(image_holder).value.split('\\').pop()
  }
  //
  contact_type() {
    console.log("CONTACT TYPE", this.stateIdTarget.value);
    if ( this.stateIdTarget.value == 1 ) {
      document.getElementById('oid').style.display = 'block'
    }
    else if ( this.stateIdTarget.value == 2 ) {
      document.getElementById('actid').style.display = 'block'
    }
  }
  //
  remove_error(event) {
    console.log(event);
    event.target.classList.remove('error')
    event.target.parentNode.querySelector('.error-text').innerHTML = ''
  }
  //
  async validate(event) {
    const formData = await event.detail.formSubmission
    const { success, fetchResponse } = formData.result
    if (success) {
      window.scrollTo(0, document.querySelector('h2').offsetTop)
      return
    }

    const res = await fetchResponse.responseText
    const errors = JSON.parse(res)

    this.errorContainerTargets.forEach((errorContainer) => {
      if ( errors[errorContainer.dataset.errorType] != undefined ) {
        errorContainer.innerHTML = '<i class="fa fa-circle-exclamation"></i>'+errors[errorContainer.dataset.errorType][0]
        if ( errorContainer.parentNode.querySelector('input') != null ) {
          errorContainer.parentNode.querySelector('input').classList.add('error')
        }
        else if ( errorContainer.parentNode.querySelector('.ss-main') != null ) {
          errorContainer.parentNode.querySelector('.ss-main').classList.add('error')
        }
        else if ( errorContainer.parentNode.querySelector('.flatpickr-input') != null ) {
          errorContainer.parentNode.querySelector('.flatpickr-input').classList.add('error')
        }
      }
    })
    window.scrollTo(0, document.querySelector('.error').offsetTop)

  }
  //
  delay(milliseconds){
    return new Promise(resolve => {
        setTimeout(resolve, milliseconds)
    })
  }
}

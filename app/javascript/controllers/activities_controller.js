import { Controller } from "@hotwired/stimulus"
import Calendar from '@toast-ui/calendar';


// Connects to data-controller="activities"
export default class extends Controller {
  static calendar
  static targets = ["title"]
  static months
  connect() {
    this.months = [
      "Enero",
      "Febrero",
      "Marzo",
      "Abril",
      "Mayo",
      "Junio",
      "Julio",
      "Agosto",
      "Setiembre",
      "Octubre",
      "Noviembre",
      "Diciembre"
    ]
    var calendars = [];
    window.subjects.forEach(element => {
      calendars.push({
        id: element.id,
        name: element.name,
        backgroundColor: element.color != undefined ? element.color : '#03bd9e',
      })
    });

    this.calendar = new Calendar('#calendar', {
      defaultView: 'month',
      //todo: calendars con colores por categoría
      calendars: calendars,
      useDetailPopup: true
    });
    var events = []; 
    window.data.forEach(element => {
      events.push({
        id: element.id,
        calendarId: element.subject_id,
        title: element.title,
        body: '<p>'+element.description+'</p>',
        //category: 'time',
        //dueDateClass: '',
        start: element.starts,
        end: element.ends,
        location: element.address,
        state: '<a href="/actividad/'+element.id+'">Ver actividad</a>',
        attendees: window.act_orgs[element.id]
      })
    })
    window.calendarEvents = events 
    this.calendar.createEvents(events)
    let date = calendar.getDate()
    console.log(date);
    this.titleTarget.innerHTML = this.months[date.getMonth()]+' '+date.getFullYear()
  }
  nextMonth() {
    this.calendar.next();
    let date = calendar.getDate()
    this.titleTarget.innerHTML = this.months[date.getMonth()]+' '+date.getFullYear()
  }
  prevMonth() {
    this.calendar.prev();
    let date = calendar.getDate()
    this.titleTarget.innerHTML = this.months[date.getMonth()]+' '+date.getFullYear()
  }
}

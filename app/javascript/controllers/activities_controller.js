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

    calendar = new Calendar('#calendar', {
      defaultView: 'month',
      template: {
        time(event) {
          return `<span style="color: white;">${event.title}</span>`;
        },
        allday(event) {
          return `<span style="color: gray;">${event.title}</span>`;
        },
      },
      //todo: calendars con colores por categoría
      calendars: calendars,
    });
    var events = []; 
    window.data.forEach(element => {
      events.push({
        id: element.id,
        calendarId: element.subject_id,
        title: element.title,
        body: element.state_id+location.id+'<p>'+element.description+'</p>',
        //category: 'time',
        //dueDateClass: '',
        start: element.starts,
        end: element.ends,
      })
    })
    window.calendarEvents = events 
    calendar.createEvents(events)
    this.titleTarget.innerHTML = this.months[calendar.getDate().getMonth()]
  }
  nextMonth() {
    calendar.next();
    this.titleTarget.innerHTML = this.months[calendar.getDate().getMonth()]
    calendar.createEvents(window.events)
  }
  prevMonth() {
    calendar.prev();
    this.titleTarget.innerHTML = this.months[calendar.getDate().getMonth()]
    calendar.createEvents(window.events)
  }
}

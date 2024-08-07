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
    var calendars = [{ id: 0, name: 'Actividades pasadas', backgroundColor: '#b0b0b0' }];
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
      useDetailPopup: true,
      isReadOnly: true,
      template: {
        monthGridHeaderExceed: function(hiddenEvents) {
          return `<span>${hiddenEvents} más</span>`;
        },
        popupDetailDate: function(event) {
          console.log('popupDetailDate', event);
          let starts = event.start.toDate()
          let ends = event.end.toDate()
          let start = starts.toLocaleDateString('es');
          let end = ends.toLocaleDateString('es');
          const formatter = new Intl.DateTimeFormat('es-UY', { day: '2-digit', month: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit' });
          const formatter_time = new Intl.DateTimeFormat('es-UY', {hour: '2-digit', minute: '2-digit' });
          let dates = '';
          if ( start == end ) {
            dates = formatter.format(starts)+' - '+formatter_time.format(ends)+' hs.';
          }
          else {
            dates = formatter.format(starts)+' hs. - '+ formatter.format(ends)+' hs.';
          }
          return dates;
        }
      },
      month: {
        dayNames: ['Dom', 'Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sáb'], // Translate the required language.
      }
    });
    var events = [];
    let today = new Date().getTime()
    window.data.forEach(element => {
      let subject = element.subject_id
      if ( new Date(element.ends).getTime() <= today ) {
        subject = 0
      }
      events.push({
        id: element.id,
        calendarId: subject,
        title: element.title,
        body: '<p>'+element.description+'</p>',
        //category: 'time',
        //dueDateClass: '',
        start: element.starts,
        end: element.ends,
        location: element.address.startsWith('http') ? '<a target="_blank" href="'+element.address+'">Online</a>' : element.address,
        state: '<a href="/actividad/'+element.slug+'">Ver actividad</a>',
        attendees: window.act_orgs[element.id]
      })
    })
    window.calendarEvents = events 
    this.calendar.createEvents(events)
    let date = this.calendar.getDate()
    this.titleTarget.innerHTML = this.months[date.getMonth()]+' '+date.getFullYear()
  }
  nextMonth() {
    this.calendar.next();
    let date = this.calendar.getDate()
    console.log('NEXT', date);
    this.titleTarget.innerHTML = this.months[date.getMonth()]+' '+date.getFullYear()
    this.getCalendarMonthActivities()
  }
  prevMonth() {
    this.calendar.prev();
    let date = this.calendar.getDate()
    this.titleTarget.innerHTML = this.months[date.getMonth()]+' '+date.getFullYear()
    this.getCalendarMonthActivities()
  }
  getCalendarMonthActivities() {
    let url = new URL(window.location.protocol+"//"+window.location.hostname+(window.location.port.length !== 0 ? ":"+window.location.port : '')+"/activities-list")
    let current_month = this.calendar.getDate().getMonth() + 1
    let current_year = this.calendar.getDate().getFullYear()
    if ( current_month == 12 ) {
      current_month = 0
      current_year = current_year + 1
    }
    var starts = current_year+'-'+current_month+'-1'
    url.searchParams.append('starts', starts)
    let ends_obj = new Date(current_year, current_month)
    ends_obj.setHours(-1);
    url.searchParams.append('ends', current_year+'-' + (ends_obj.getMonth() + 1) + '-' + ends_obj.getDate() )
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

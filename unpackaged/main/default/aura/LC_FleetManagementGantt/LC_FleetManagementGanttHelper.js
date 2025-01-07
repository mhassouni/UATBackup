({
  eventToSObject: function (event) {
    var data_out = new Date(event.start._d);
    data_out.setDate(data_out.getDate() + 1);
    var sObject = {};
    sObject.sobjectType = "Reservation__c";
    sObject.Name = event.title;
    sObject.Id = event.Id;
    sObject.IsAllDayEvent__c = false;
    sObject.Date_de_debut__c = event.start;
    if (!event.end) {
      sObject.Date_de_fin__c = event.start;
    } else {
      let endDate = new Date(event.end);
      endDate.setDate(endDate.getDate() - 1);
      sObject.Date_de_fin__c = endDate;
    }
    sObject.Id = event.sfid;
    return sObject;
  },
  sObjectToEvent: function (sObject, helper) {
    var event = {};
    event.title = helper.setTitle(sObject);
    event.allDay = true;
    event.start = sObject.Date_de_debut__c;
    let endDate = new Date(sObject.Date_de_fin__c);
    endDate.setDate(endDate.getDate() + 1);
    event.end = endDate;
    event.url = "/" + sObject.Id;
    event.sfid = sObject.Id;
    event.description = sObject.Description_Gantt__c;
    event.status = sObject.Status__c;
    event.recordType = sObject.RecordType.DeveloperName;
    if (sObject.Status__c === "Planifiée") {
      event.color = helper.getColorByRecordType(
        sObject.RecordType.DeveloperName,
        ["#e09e68", "#7fc9a5", "#77aabd"]
      );
    } else {
      event.color = helper.getColorByRecordType(
        sObject.RecordType.DeveloperName,
        ["#ef7e33", "#0170c1", "#01af50"]
      );
    }
    return event;
  },
  getColorByRecordType: function (recordType, arrayOfColors) {
    let color;
    const [atelierColor, locationColor, transportColor] = arrayOfColors;
    switch (recordType) {
      case "Atelier":
        color = atelierColor;
        break;
      case "Location":
        color = locationColor;
        break;
      case "Transport":
        color = transportColor;
        break;
    }
    return color;
  },
  setTitle: function (reservation) {
    return (
      reservation.Name +
      (reservation.Client__c != null ? " - " + reservation.Client__r.Name : "")
    );
  },
  getEvents: function (component, helper) {
    var action = component.get("c.getReservationSObjects");
    var assetId = component.get("v.assetId");
    action.setParams({ assetId: assetId ? assetId : null });
    action.setCallback(this, function (response) {
      var state = response.getState();
      if (component.isValid() && state === "SUCCESS") {
        component.set("v.events", response.getReturnValue());
        helper.removeHolidayLabels();
        helper.disableHolidays(component, helper);
      }
    });
    $A.enqueueAction(action);
  },
  updateEvents: function (cmp, records) {
    var assetId = cmp.get("v.assetId");
    window.setTimeout(
      $A.getCallback(function () {
        var action = cmp.get("c.updateReservationSObjects");
        var eventCalendar = {};
        eventCalendar.eventId = records[0].Id;
        eventCalendar.Date_de_debut = records[0].Date_de_debut__c;
        eventCalendar.Date_de_fin = records[0].Date_de_fin__c;
        action.setParams({ eventCalendar: eventCalendar, assetId: assetId });
        action.setCallback(this, function (response) {
          var state = response.getState();
          if (cmp.isValid() && state === "SUCCESS") {
          } else if (state === "ERROR") {
            response.getError().forEach(function (err) {});
          }
        });
        $A.enqueueAction(action);
      }),
      0
    );
  },
  removeHolidayLabels: function () {
    const holidayLabelsElements = document.querySelectorAll(".holiday");
    if (holidayLabelsElements) {
      holidayLabelsElements.forEach((holidayLabelsElement) =>
        holidayLabelsElement.remove()
      );
    }
  },
  setCalendarDate: function (cmp) {
    var view = cmp.get("v.view").toLowerCase();
    var moment = $("#calendar").fullCalendar("getDate");
    var headerDate;
    if (view.includes("month")) {
      headerDate = moment.format("MMMM YYYY");
    } else if (view.includes("day")) {
      headerDate = moment.format("MMMM DD, YYYY");
    } else if (view.includes("week")) {
      var startDay = moment.startOf("week").format("DD");
      var endDay = moment.endOf("week").format("DD");
      headerDate =
        moment.format("MMM ") +
        startDay +
        " – " +
        endDay +
        moment.format(", YYYY");
    }
    cmp.set("v.headerDate", headerDate);
  },
  getHolidays: function (component, event) {
    try {
      const getHolidaysAction = component.get("c.getHolidayRecords");
      getHolidaysAction.setCallback(this, function (response) {
        if (response.getState() === "SUCCESS") {
          component.set("v.holidays", response.getReturnValue());
        }
      });
      $A.enqueueAction(getHolidaysAction);
    } catch (error) {
      console.error(error);
    }
  },
  disableHolidays: function (component, helper) {
    const calendarDaysElements = document.querySelectorAll(".fc-day");
    const holidays = component.get("v.holidays");
    calendarDaysElements.forEach((calendarDayElement) => {
      const holiday = holidays.find(
        ({ ActivityDate }) => ActivityDate === calendarDayElement.dataset.date
      );
      if (helper.isWeekend(calendarDayElement.dataset.date)) {
        calendarDayElement.style =
          "background-color: rgb(233 231 231); pointer-events: none;";
      }
      if (holiday) {
        const spanEl = document.createElement("span");
        spanEl.classList.add("holiday");
        spanEl.innerHTML = holiday.Name;
        calendarDayElement.appendChild(spanEl);
        calendarDayElement.style =
          "background-color: #c4c1c1; pointer-events: none;";
      }
    });
  },
  isWeekend: function (date) {
    const dayDate = new Date(date).getDay();
    return [0, 6].includes(dayDate);
  },

  hasEvent: function(startDate, endDate, reservationId, cmp, evt, hlp){
    let allEvents = cmp.get("v.events");
    let reservations = allEvents.find((obj) => obj.Id != reservationId &&
            ((obj.Date_de_debut__c <= startDate && obj.Date_de_fin__c >= startDate) || 
             (obj.Date_de_debut__c <= endDate && obj.Date_de_fin__c >= endDate) ||
            (obj.Date_de_debut__c >= startDate && obj.Date_de_fin__c <= endDate)));
    if(reservations){
      hlp.showToast("warning", "ATTENTION !", "Le conteneur n’est pas totalement disponible sur les créneaux séléctionnés.");
      return true;
    }
    return false;
  },

  showToast: function (type, title, message) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      type: type,
      title: title,
      message: message
    });
    toastEvent.fire();
  }
});
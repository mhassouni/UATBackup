({
  doInit: function (component, event, helper) {
    helper.getHolidays(component, event);
  },
  prev: function (cmp, evt, hlp) {
    $("#calendar").fullCalendar("prev");
    hlp.disableHolidays(cmp, hlp);
    hlp.setCalendarDate(cmp);
  },
  next: function (cmp, evt, hlp) {
    $("#calendar").fullCalendar("next");
    hlp.disableHolidays(cmp, hlp);
    hlp.setCalendarDate(cmp);
  },
  today: function (cmp, evt, hlp) {
    $("#calendar").fullCalendar("today");
    hlp.disableHolidays(cmp, hlp);
    hlp.setCalendarDate(cmp);
  },
  loadEvents: function (cmp, evt, hlp) {
    var events = cmp.get("v.events");
    $("#calendar").fullCalendar("addEventSource", events);
  },
  jsLoaded: function (cmp, evt, hlp) {
    $(document).ready(function () {
      $("#calendar").fullCalendar({
        header: false,
        locale: "fr",
        navLinks: true, // can click day/week names to navigate views
        editable: true,
        droppable: true, // allows things to be dropped onto the calendar
        selectable: true,
        selectHelper: true,
        height: 770,
        eventColor: '#808080',
        events: [],
        drop: function (date) {
          try {
            let originalEventObject = $(this).data("event");
            let diffDays = originalEventObject.diffDays;
            let copiedEventObject = $.extend({}, originalEventObject);
            let tempDate = new Date(date);
        
            let startDate = moment(new Date(tempDate.setDate(tempDate.getDate()))).format("YYYY-MM-DD");
            let endDate = moment(new Date(tempDate.setDate(tempDate.getDate() + diffDays))).format("YYYY-MM-DD");
            
            if(hlp.hasEvent(startDate, endDate, originalEventObject.id, cmp, evt, hlp)) {
              $("#calendar").fullCalendar('removeEvents',  originalEventObject.id);
              return;
            }

            copiedEventObject.start = date;
            copiedEventObject.end = endDate;
            copiedEventObject.Status__c = "Planifiée";
            $("#calendar").fullCalendar("removeEvents", originalEventObject.id);
            $("#calendar").fullCalendar("renderEvent", copiedEventObject, true);
            
            var sObject = hlp.eventToSObject(copiedEventObject, hlp);
            sObject.Id = sObject.Id;
            hlp.updateEvents(cmp, [sObject]);
            $(this).remove();

          } catch (error) {
            console.error(error);
          }
        },
        eventRender: function ({ description, recordType, status }, element) {
          console.log(element);
          element.on("mouseover", function () {
            element
              .closest(".fc-row.fc-week.fc-widget-content")
              .css("z-index", 9999);
          });
          element.on("mouseleave", function () {
            element
              .closest(".fc-row.fc-week.fc-widget-content")
              .css("z-index", 1);
          });
          let color = "";
          if (status === "Planifiée") {
            color = hlp.getColorByRecordType(recordType, [
              "#dc9256",
              "#5394ac",
              "#5dbb8e"
            ]);
            element.css(
              "background",
              `repeating-linear-gradient(
              -45deg,
              ${color},
              ${color} 6px,
              #ffffff86 10px
            )`
            );

            element.css("border-color", `${color}`);
          } else {
            color = hlp.getColorByRecordType(recordType, [
              "#EF7E33",
              "#0170C1",
              "#01AF50"
            ]);
            element.css("background-color", `${color}`);
            element.css("border-color", `${color}`);
          }

          element.append(
            `<span class="description">${description || ""}</span>`
          );
        },
        eventClick: function (event) {
          if (event.url) {
            window.open(event.url, "_blank");
            return false;
          }
        },
        eventDataTransform: function (event) {
          var evt;
          // Salesforce Event
          if (event.Id) {
            evt = hlp.sObjectToEvent(event, hlp);
          }
          // Regular Event
          else {
            evt = event;
          }
          return evt;
        },
        eventDrop: function (event, delta, revertFunc) {
          if (!confirm("Are you sure about this change?")) {
            revertFunc();
          } else {
            var sObject = hlp.eventToSObject(event);
            let startDate = moment(new Date(sObject.Date_de_debut__c)).format("YYYY-MM-DD");
            let endDate = moment(new Date(sObject.Date_de_fin__c)).format("YYYY-MM-DD");
            if(hlp.hasEvent(startDate, endDate, sObject.Id, cmp, evt, hlp)){
              revertFunc();
            }
            else{
              hlp.updateEvents(cmp, [sObject]);
            }
          }
        },
        eventResize: function (event, delta, revertFunc) {
          if (!confirm("is this okay?")) {
            revertFunc();
          } else {
            var sObject = hlp.eventToSObject(event);
            let startDate = moment(new Date(sObject.Date_de_debut__c)).format("YYYY-MM-DD");
            let endDate = moment(new Date(sObject.Date_de_fin__c)).format("YYYY-MM-DD");
            if(hlp.hasEvent(startDate, endDate, sObject.Id, cmp, evt, hlp)){
              revertFunc();
            }
            else{
              hlp.updateEvents(cmp, [sObject]);
            }
          }
        }
      });
      $("#calendar").fullCalendar("addEventSource", cmp.get("v.events"));
      hlp.setCalendarDate(cmp);
      hlp.getEvents(cmp, hlp);
    });
  },
  doReloadEvents: function (component, event, helper) {
    $("#calendar").fullCalendar("removeEvents", () => true);
    helper.getEvents(component, helper);
  }
});
import { LightningElement, api, wire } from "lwc";
import fullCalendar from "@salesforce/resourceUrl/fullCalendarV4";
import { loadScript, loadStyle } from "lightning/platformResourceLoader";
import getReservations from "@salesforce/apex/AssetCalendarController.getReservations";
import getHolidays from "@salesforce/apex/AssetCalendarController.getHolidays";
import { NavigationMixin } from "lightning/navigation";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import ASSET_NAME from "@salesforce/schema/Asset.Name";

const DISABLED_DAY_STYLE = "background-color: #c4c1c1;";
const WEEKEND_DAY_STYLE = "background-color: rgb(233 231 231);";

export default class ContainerCalendar extends NavigationMixin(
  LightningElement
) {
  isLoading = true;
  reservations = [];
  fullCalendarJsInitialized = false;

  holidays;

  @api
  recordId;

  @wire(getRecord, { recordId: "$recordId", fields: [ASSET_NAME] })
  asset;

  get assetName() {
    return getFieldValue(this.asset.data, ASSET_NAME);
  }

  //Css Files
  coreCss = `${fullCalendar}/packages/core/main.css`;
  dayGridCss = `${fullCalendar}/packages/daygrid/main.css`;
  timeGridCss = `${fullCalendar}/packages/timegrid/main.css`;
  // JS Files
  localeAllJs = `${fullCalendar}/packages/locales/locales-all.js`;
  momentJs = `${fullCalendar}/packages/moment/moment.min.js`;
  coreJs = `${fullCalendar}/packages/core/main.js`;
  dayGridJs = `${fullCalendar}/packages/daygrid/main.js`;
  interactionJs = `${fullCalendar}/packages/interaction/main.js`;
  timeGridJs = `${fullCalendar}/packages/timegrid/main.js`;

  renderedCallback() {
    if (this.fullCalendarJsInitialized) {
      return;
    }
    this.fullCalendarJsInitialized = true;
    this.loadFiles();
  }

  disconnectedCallback() {
    this.template.querySelectorAll(".fc-button").forEach((fcButton) =>
      fcButton.removeEventListener("click", () => {
        this.disableHolidayDays();
      })
    );
  }

  loadFiles() {
    Promise.all([loadScript(this, this.coreJs), loadStyle(this, this.coreCss)])
      .then(() => {
        //got to load core first, then plugins
        Promise.all([
          loadScript(this, this.momentJs),
          loadScript(this, this.localeAllJs),
          loadScript(this, this.dayGridJs),
          loadStyle(this, this.dayGridCss),
          loadScript(this, this.timeGridJs),
          loadStyle(this, this.timeGridCss),
          loadScript(this, this.interactionJs)
        ]).then(async () => {
          try {
            const [reservationsData, holidaysData] = await Promise.all([
              getReservations({
                assetId: this.recordId
              }),
              getHolidays()
            ]);
            this.reservations = [...reservationsData];
            this.holidays = [...holidaysData];
            this.initializeFullCalendarJs();
            this.isLoading = false;
          } catch (error) {
            console.error(error);
          }
        });
      })
      .catch((error) => {
        console.error(error);
      });
  }

  initializeFullCalendarJs() {
    try {
      const calendarEl = this.template.querySelector(".calendar");
      let calendar = new FullCalendar.Calendar(calendarEl, {
        locale: "fr",
        plugins: ["interaction", "dayGrid", "timeGrid"],
        defaultView: "dayGridMonth",
        defaultDate: moment().format(),
        header: {
          left: "prev,next today",
          center: "title",
          right: ""
        },
        height: "auto",
        editable: false,
        navLinks: true,
        events: [...this.prepareEvents(this.reservations)],
        eventClick: function ({ url }) {
          if (url) {
            window.open(url, "_blank");
            return false;
          }
        },
        eventRender: (info) => {
          info.el.addEventListener("mouseover", () => {
            info.el.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.style[
              "z-index"
            ] = 9999;
          });

          info.el.addEventListener("mouseleave", () => {
            info.el.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.style[
              "z-index"
            ] = 1;
          });
          const { status, recordType, description } = info.event.extendedProps;
          // ******** Background Color ********
          let color =
            status === "Planifiée"
              ? this.setBackgroundColor(recordType, [
                  "#DC9256",
                  "#5394AC",
                  "#5DBB8E"
                ])
              : this.setBackgroundColor(recordType, [
                  "#EF7E33",
                  "#0170C1",
                  "#01AF50"
                ]);
          if (status === "Planifiée") {
            info.el.style = `background: repeating-linear-gradient(
              -45deg,
              ${color},
              ${color} 6px,
              #ffffff86 10px
            ); border-color:${color}`;
          } else {
            info.el.style = `background-color: ${color}; border-color: ${color}`;
          }
          // ******** /Background Color ********
          const spanEl = document.createElement("span");
          spanEl.classList.add("description");
          spanEl.innerHTML = description || "";
          info.el.appendChild(spanEl);
        }
      });

      calendar.render();
      this.disableHolidayDays();
      // Override standard event clicks in order to display holiday days
      this.template.querySelectorAll(".fc-button").forEach((fcButton) =>
        fcButton.addEventListener("click", () => {
          this.disableHolidayDays();
        })
      );
    } catch (error) {
      console.error(error);
    }
  }

  disableHolidayDays() {
    const dayElements = this.template.querySelectorAll(".fc-day");
    dayElements.forEach((dayElement) => {
      const spanEl = document.createElement("span");
      const holiday = this.holidays.find(
        ({ ActivityDate }) => ActivityDate === dayElement.dataset.date
      );
      if (this.isWeekend(dayElement.dataset.date)) {
        dayElement.style = WEEKEND_DAY_STYLE;
      }
      if (holiday) {
        spanEl.classList.add("holiday");
        spanEl.innerHTML = holiday.Name;
        dayElement.appendChild(spanEl);
        dayElement.style = DISABLED_DAY_STYLE;
      }
    });
  }

  isWeekend(date) {
    const dayDate = new Date(date).getDay();
    return [0, 6].includes(dayDate);
  }

  handlePlanifyClick() {
    this[NavigationMixin.GenerateUrl]({
      type: "standard__navItemPage",
      attributes: {
        apiName: "Fleet_Management_Gantt"
      },
      state: {
        c__assetId: this.recordId,
        c__assetName: this.assetName
      }
    }).then((url) => window.open(url, "_blank"));
  }

  prepareEvents(data) {
    return data.map((reservation) => ({
      id: reservation.Id,
      start: reservation.Date_de_debut__c,
      end: moment(this.addDays(reservation.Date_de_fin__c, 1)).format(
        "YYYY-MM-DD"
      ),
      title: this.setTitle(reservation),
      description: reservation.Description_Gantt__c,
      status: reservation.Status__c,
      recordType: reservation.RecordType.DeveloperName,
      url: "/" + reservation.Id
    }));
  }

  addDays(date, days) {
    let endDate = new Date(date);
    endDate.setDate(endDate.getDate() + days);
    return endDate;
  }

  setTitle(reservation) {
    return (
      reservation.Name +
      (reservation.Client__c != null ? " - " + reservation.Client__r.Name : "")
    );
  }

  setBackgroundColor(recordType, arrayColors) {
    const [atelierColor, locationColor, transportColor] = arrayColors;
    switch (recordType) {
      case "Atelier":
        return atelierColor;
      case "Location":
        return locationColor;
      case "Transport":
        return transportColor;
    }
  }
}
({
  getSearchResults: function (cmp, evt, hlp) {
    hlp.makeSearchResultsDraggable(cmp, hlp);
  },
  makeSearchResultsDraggable: function (cmp, hlp) {
    var uniqueId = cmp.getGlobalId() + "external-events";
    $(document).ready(function () {
      setTimeout(function () {
        var events = $(".fc-event");
        var results = $(document.getElementById(uniqueId)).find(events);
        if (results) {
          results.each(function () {
            const auraIdStartDate = "Date_de_debut" + $(this).data("sfid");
            const auraIdEndDate = "Date_de_fin" + $(this).data("sfid");

            const startDateEl = document.getElementById(auraIdStartDate);
            const endDateEl = document.getElementById(auraIdEndDate);

            const startDate = startDateEl && startDateEl.innerText;
            const endDate = endDateEl && endDateEl.innerText;

            const recordTypeElementId = "color" + $(this).data("sfid");
            const statusElementId = "status" + $(this).data("sfid");

            const recordTypeElement =
              document.getElementById(recordTypeElementId);
            const recordType = recordTypeElement && recordTypeElement.innerText;

            const statusElement = document.getElementById(statusElementId);
            const status = statusElement && statusElement.innerText;

            let eventColor;
            if (status === "Planifiée") {
              eventColor = hlp.getColorByRecordType(recordType, [
                "#e09e68",
                "#7fc9a5",
                "#77aabd"
              ]);
            } else {
              eventColor = hlp.getColorByRecordType(recordType, [
                "#ef7e33",
                "#01af50",
                "#0170c1"
              ]);
            }

            const descriptionId = "description" + $(this).data("sfid");
            const descriptionElement = document.getElementById(descriptionId);
            const description =
              descriptionElement && descriptionElement.innerText;

            const reservationNameElement = document.getElementById(
              `${$(this).data("sfid")}-name`
            );
            const reservationName =
              reservationNameElement && reservationNameElement.innerText;

            const containerNameElement = document.getElementById(
              `${$(this).data("sfid")}-name`
            );

            const containerName =
              containerNameElement &&
              containerNameElement?.parentNode?.parentNode?.querySelector("p")
                ?.innerText;

            const completeName = `${reservationName} - ${containerName}`;

            $(this)?.data("event", {
              id: $(this).data("sfid"),
              title: completeName ? completeName : "",
              stick: true,
              sfid: $(this).data("sfid"),
              color: eventColor,
              description: description,
              url: "/" + $(this).data("sfid"),
              diffDays: hlp.getDiffDays(startDate, endDate)
                ? hlp.getDiffDays(startDate, endDate)
                : 1
            });
            if ($(this)) {
              try {
                $(this).draggable({
                  zIndex: 999,
                  revert: true,
                  revertDuration: 0
                });
              } catch (error) {}
            }
          });
        }
      }, 1000);
    });
  },
  getColorByRecordType: function (recordType, arrayOfColors) {
    let color;
    const [atelierColor, transportColor, locationColor] = arrayOfColors;
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
  getDiffDays: function (date1, date2) {
    if (!date1 || !date2) {
      return;
    }
    let dateParts1 = date1.split("/");
    let dateParts2 = date2.split("/");
    let dateParts1Str =
      dateParts1[1] + "/" + dateParts1[0] + "/" + dateParts1[2];
    let dateParts2Str =
      dateParts2[1] + "/" + dateParts2[0] + "/" + dateParts2[2];

    const diffTime = Math.abs(
      new Date(dateParts2Str) - new Date(dateParts1Str)
    );
    return Math.ceil(diffTime / (1000 * 60 * 60 * 24)) + 1;
  },
  checkSelectedReservations: function (component) {
    const checkBoxesElements = component.find("reservation_checkbox");
    const selectedReservations = component.get("v.selectedReservations");
    checkBoxesElements && checkBoxesElements.length &&
      checkBoxesElements.forEach((checkBoxElement) => {
        const checkBoxDomElement = checkBoxElement.getElement();
        if (
          checkBoxDomElement &&
          selectedReservations.includes(checkBoxDomElement.value)
        ) {
          checkBoxDomElement.checked = true;
        }
      });
  },
  deselectAllReservations: function (component) {
    component.set("v.selectedReservations", []);
    const checkBoxesElements = component.find("reservation_checkbox");
    checkBoxesElements && checkBoxesElements.length &&
      checkBoxesElements.forEach((checkBoxElement) => {
        const checkBoxDomElement = checkBoxElement.getElement();
        checkBoxDomElement.checked = false;
      });
  },

  getAssetReservations: function (reservations, selectedReservations, component, event, helper) {
    var action = component.get("c.getReservationSObjects");
    var assetId = component.get("v.assetId");
    action.setParams({assetId: assetId ? assetId : null });
    action.setCallback(this, function (response) {
      var state = response.getState();
      if(component.isValid() && state === "SUCCESS") {
        component.set("v.assetReservations", response.getReturnValue());

        let reservation;
        let startDate;
        let endDate;
        for(var index in reservations){
          reservation = reservations[index];
          startDate = moment(new Date(reservation.Date_de_debut__c)).format("YYYY-MM-DD");
          endDate = moment(new Date(reservation.Date_de_fin__c)).format("YYYY-MM-DD");
          if(helper.hasEvent(reservations, startDate, endDate, reservation.Id, "Vous avez sélectionné des réservations sur la même période : " + reservation.Name, component, event, helper)){
            component.set("v.spinner", false);
            return;
          }
          if(response.getReturnValue()){
            if(helper.hasEvent(response.getReturnValue(), startDate, endDate, reservation.Id, "Le conteneur n’est pas totalement disponible sur les créneaux séléctionnés : " + reservation.Name, component, event, helper)){
              component.set("v.spinner", false);
              return;
            }
          }
        }

        helper.scheduleSelectedReservations(
          selectedReservations,
          component,
          event,
          helper
        );
      }
    });
    $A.enqueueAction(action);
  },

  scheduleSelectedReservations: function (
    selectedReservations,
    component,
    event,
    helper
  ) {
    var action = component.get("c.scheduleReservations");
    action.setParams({
      assetId: component.get("v.assetId"),
      reservationsId: selectedReservations
    });
    action.setCallback(this, function (a) {
      var state = a.getState();
      if (state === "SUCCESS") {
        // Notify Parent to make the other child component : FleetManagementGantt reload new events
        const notifyGanttParentEvent = component.getEvent("notifyGanttParent");
        notifyGanttParentEvent.fire();
        // *****************************************************************************************

        // Remove the submitted reservations from reservationsValuesMap

        // let reservationsValuesMap = component.get("v.reservationsValuesMap");
        // reservationsValuesMap = reservationsValuesMap.filter(({id}) => !selectedReservations.includes(id));
        // component.set("v.reservationsValuesMap",reservationsValuesMap)

        // ************************************************************

        component.set("v.selectedReservations", []);
        component.set("v.spinner", false);
      } 
      else {
        var errors = a.getError();
        var message = "Erreur inconnue";
        if (errors && Array.isArray(errors) && errors.length > 0) {
          message = errors[0].message;
        }
        helper.showToast(
          "error",
          "ERREUR !",
          message,
          component,
          event,
          helper
        );
        component.set("v.spinner", false);
      }
    });
    $A.enqueueAction(action);
  },

  hasEvent: function(allEvents, startDate, endDate, reservationId, message, component, event, helper){
    let reservations = allEvents.find((obj) => obj.Id != reservationId &&
            ((obj.Date_de_debut__c <= startDate && obj.Date_de_fin__c >= startDate) || 
             (obj.Date_de_debut__c <= endDate && obj.Date_de_fin__c >= endDate) ||
            (obj.Date_de_debut__c >= startDate && obj.Date_de_fin__c <= endDate)));
    if(reservations){
      helper.showToast("warning", "ATTENTION !", message);
      return true;
    }
    return false;
  },

  showToast: function (type, title, message, component, event, helper) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      type: type,
      title: title,
      message: message
    });
    toastEvent.fire();
  }
});
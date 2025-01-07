({
  getSearchFields_Reservation: function (component, event, helper) {
    var action = component.get("c.getFieldSet");
    action.setParams({
      objectName: "Reservation__c",
      fieldSetName: "Gantt_Search_Fields"
    });
    action.setCallback(this, function (a) {
      var state = a.getState();
      if (state === "SUCCESS") {
        var response = a.getReturnValue();
        component.set("v.searchFields_reservation", response);
        helper.getResultFields_Reservation(component, event, helper);
      } else {
        var errors = a.getError();
        var message = "Erreur inconnue";
        if (errors && Array.isArray(errors) && errors.length > 0) {
          message = errors[0].message;
        }
        component.set("v.spinner", false);
      }
    });
    $A.enqueueAction(action);
  },

  getResultFields_Reservation: function (component, event, helper) {
    var action = component.get("c.getFieldSet");
    action.setParams({
      objectName: "Reservation__c",
      fieldSetName: "Fleet_Management_Result_Fields"
    });
    action.setCallback(this, function (a) {
      var state = a.getState();
      if (state === "SUCCESS") {
        var response = a.getReturnValue();
        component.set("v.resultFields_reservation", response);
        helper.setFilter(component);
        helper.getReservations(component, event, helper);
      } else {
        var errors = a.getError();
        var message = "Erreur inconnue";
        if (errors && Array.isArray(errors) && errors.length > 0) {
          message = errors[0].message;
        }
        component.set("v.spinner", false);
      }
    });
    $A.enqueueAction(action);
  },

  getReservations: function (component, event, helper) {
    try {
      var searchFields = component.get("v.searchFields_reservation");
      var resultFields = component.get("v.resultFields_reservation");
      var orderId = component.get("v.refRecordId");
      var reservation_filter = component.get("v.reservation_filter");
      if (!reservation_filter.RecordTypeId)
        reservation_filter.RecordTypeId = null;
      if (reservation_filter.Status__c == null)
        reservation_filter.Asset_assigne__c = null;

      var action = component.get("c.getReservations");
      action.setParams({
        searchFields: searchFields,
        resultFields: resultFields,
        orderId: orderId,
        filter: reservation_filter
      });
      action.setCallback(this, function (a) {
        var state = a.getState();
        if (state === "SUCCESS") {
          try {
            var response = a.getReturnValue();
            component.set("v.reservations", response);
            // var reservationsById = [];
            // var values;
            // for (var reservationIndex in response) {
            //   values = [];
            //   for (var fieldIndex in resultFields) {
            //     values.push({
            //       field: resultFields[fieldIndex],
            //       value:
            //         response[reservationIndex][resultFields[fieldIndex].apiName]
            //     });
            //   }
            //   reservationsById.push({
            //     id: response[reservationIndex].Id,
            //     record: values
            //   });
            // }
            let reservationsById = response.map(reservation => {
              let reservationById = {
                id: reservation.Id,
                record : []
              }
              resultFields.forEach(resultField => {
                reservationById.record.push({
                  field : Object.assign({}, resultField),
                  value : reservation[resultField.apiName]
                })
              })
              return reservationById;
            })
            component.set("v.reservations_valuesMap", reservationsById);
            component.find("fleet-management-gantt-search").reload();
            component.set("v.spinner", false);
          } catch (error) {
            console.error(error);
          }
        } else {
          var errors = a.getError();
          var message = "Erreur inconnue";
          if (errors && Array.isArray(errors) && errors.length > 0) {
            message = errors[0].message;
          }
          component.set("v.spinner", false);
        }
      });
      $A.enqueueAction(action);
    } catch (error) {
      console.error(error);
    }
  },
  getAssetInfoFromURL: function (cmp) {
    try {
      let sPageURL = decodeURIComponent(window.location.search.substring(1));
      if (!sPageURL) {
        cmp.set("v.isFilterTransfered", false);
        return;
      }
      let splittedSPageUrl = sPageURL.split("&");
      let assetId;
      let assetName;
      let reservationFilter;
      if (splittedSPageUrl) {
        assetId =
          splittedSPageUrl.length > 0
            ? splittedSPageUrl[0].split("=")[1]
            : null;
        assetName =
          splittedSPageUrl.length > 1
            ? splittedSPageUrl[1].split("=")[1]
            : null;
        reservationFilter =
          splittedSPageUrl.length > 2
            ? splittedSPageUrl[2].split("=")[1]
            : null;
      }
      if (assetId) {
        cmp.set("v.assetId", assetId);
      }
      if (assetName) {
        cmp.set("v.assetName", assetName);
      }
      let reservation = {};
      if (reservationFilter) {
        reservationFilter.split(",").forEach((filter) => {
          let splittedFilter = filter.split(":");
          reservation[splittedFilter[0]] = splittedFilter[1];
        });
      } else {
        cmp.set("v.isFilterTransfered", false);
      }
      if (Object.keys(reservation).length > 0) {
        cmp.set("v.reservation_filter", reservation);
      }
    } catch (error) {
      console.error(error);
    }
  },

  setFilter: function (cmp) {
    let reservation_inputField = cmp.find("reservation_inputField");
    let reservation = cmp.get("v.reservation_filter");
    if (reservation_inputField && reservation_inputField.length > 0) {
      reservation_inputField.forEach((inputField) => {
        if (inputField.get("v.selectedOptions_labels") == "") {
          if (reservation && reservation[inputField.get("v.apiName")]) {
            let labels = reservation[inputField.get("v.apiName")].split(";");
            let options = inputField.get("v.options");
            options.forEach((option) => {
              if (labels.includes(option.value)) {
                option.isChecked = true;
              }
            });
            inputField.set("v.options", options);
            inputField.set(
              "v.selectedOptions_values",
              reservation[inputField.get("v.apiName")]
            );

            let inputLabel = "Une valeur selectionnée";

            if (
              reservation[inputField.get("v.apiName")] &&
              reservation[inputField.get("v.apiName")].slice(0, -1).split(";")
                .length > 1
            ) {
              inputLabel = `${
                reservation[inputField.get("v.apiName")].split(";").length - 1
              } valeurs sélectionnées`;
            }

            inputField.set("v.selectedOptions_labels", inputLabel);
          }
        } else {
          inputField.set("v.value", reservation[inputField.get("v.fieldName")]);
        }
      });
    }
  },

  setWorkspace: function (component, event, helper) {
    var workspaceAPI = component.find("workspace");
    workspaceAPI.getFocusedTabInfo().then(function (response) {
      var focusedTabId = response.tabId;
      workspaceAPI.setTabLabel({
        tabId: focusedTabId,
        label: "Fleet Management Gantt"
      });
      workspaceAPI.setTabIcon({
        tabId: focusedTabId,
        icon: "utility:date_input",
        iconAlt: "Fleet Management Gantt"
      });
    });
  }
});
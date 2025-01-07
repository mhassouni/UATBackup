({
  setWorkspace: function (component, event, helper) {
    var workspaceAPI = component.find("workspace");
    workspaceAPI.getFocusedTabInfo().then(function (response) {
      var focusedTabId = response.tabId;
      workspaceAPI.setTabLabel({
        tabId: focusedTabId,
        label: "Fleet Management Vue FSL"
      });
      workspaceAPI.setTabIcon({
        tabId: focusedTabId,
        icon: "utility:date_input",
        iconAlt: "Fleet Management Vue FSL"
      });
    });
  },

  getOptions: function (component, event, helper) {
    var action = component.get("c.getOptionProducts");
    action.setCallback(this, function (a) {
      var state = a.getState();
      if (state === "SUCCESS") {
          var response = a.getReturnValue();
          var options = [];
          var itemValues = [];
          for(var index in response) {
              if(!itemValues.includes(response[index].Name.toLowerCase())){
                  var item = {
                      "label": response[index].Name,
                      "value": response[index].Name
                  };
                  options.push(item);
                  itemValues.push(response[index].Name.toLowerCase());
              }
          }
          component.set("v.options", options);
      } else {
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

  getSearchFields_Container: function (component, event, helper) {
    helper.getOptions(component, event, helper);

    var action = component.get("c.getFieldSet");
    action.setParams({
      objectName: "Asset",
      fieldSetName: "Fleet_Management_Search_Fields"
    });
    action.setCallback(this, function (a) {
      var state = a.getState();
      if (state === "SUCCESS") {
        var response = a.getReturnValue();
        component.set("v.searchFields_container", response);
        helper.getResultFields_Container(component, event, helper);
      } else {
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

  getResultFields_Container: function (component, event, helper) {
    var action = component.get("c.getFieldSet");
    action.setParams({
      objectName: "Asset",
      fieldSetName: "Fleet_Management_Result_Fields"
    });
    action.setCallback(this, function (a) {
      var state = a.getState();
      if (state === "SUCCESS") {
        var response = a.getReturnValue();
        component.set("v.resultFields_container", response);
        helper.setFilter(component);
        helper.getContainers(component, event, helper);
      } else {
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

  getInfoFromURL: function (component, event, helper) {
    try {
      let sPageURL = decodeURIComponent(window.location.search.substring(1));
      if (!sPageURL) {
        component.set("v.isFilterTransfered", false);
      } else {
        let AssetFilter = sPageURL.split("=")[1];
        let asset = {};
        if (AssetFilter) {
          AssetFilter.split(",").forEach((filter) => {
            let splittedFilter = filter.split(":");
            asset[splittedFilter[0]] = splittedFilter[1];
          });
        } else {
          component.set("v.isFilterTransfered", false);
        }
        if (Object.keys(asset).length > 0) {
          component.set("v.container_filter", asset);
        }
      }
    } catch (error) {
      console.error(error);
    }
  },

  setFilter: function (component) {
    let asset_inputField = component.find("asset_inputField");
    let asset = component.get("v.container_filter");
    if (asset_inputField && asset_inputField.length > 0) {
      asset_inputField.forEach((inputField) => {
        if (inputField.get("v.selectedOptions_labels") == "") {
          if (asset && asset[inputField.get("v.apiName")]) {
            let labels = asset[inputField.get("v.apiName")].split(";");
            let options = inputField.get("v.options");
            options.forEach((option) => {
              if (labels.includes(option.value)) {
                option.isChecked = true;
              }
            });
            inputField.set("v.options", options);
            inputField.set(
              "v.selectedOptions_values",
              asset[inputField.get("v.apiName")]
            );

            let inputLabel = "Une valeur selectionnée";

            if (
              asset[inputField.get("v.apiName")].slice(0, -1).split(";")
                .length > 1
            ) {
              inputLabel = `${
                asset[inputField.get("v.apiName")].split(";").length - 1
              } valeurs sélectionnées`;
            }

            inputField.set("v.selectedOptions_labels", inputLabel);
          }
        } else {
          inputField.set("v.value", asset[inputField.get("v.fieldName")]);
        }
      });
    }
  },

  getContainers: function (component, event, helper) {
    var searchFields = component.get("v.searchFields_container");
    var resultFields = component.get("v.resultFields_container");
    var orderId = component.get("v.refRecordId");
    var container_filter = component.get("v.container_filter");

    var action = component.get("c.getAssetsFSL");
    action.setParams({
      searchFields: searchFields,
      resultFields: resultFields,
      orderId: orderId,
      filter: container_filter
    });

    action.setCallback(this, function (a) {
      var state = a.getState();
      if (state === "SUCCESS") {
        var response = a.getReturnValue();
        component.set("v.containers", response);
        let container_Ids = "";
        let containersById = response.map((container) => {
          container_Ids = container_Ids + container.Id + ";";
          const containerById = {
            id: container.Id,
            record: []
          };
          resultFields.forEach((resultField) => {
            if (container[resultField.apiName]) {
              if (resultField.apiName === "Options__c") {
                containerById.record.push({
                  field: Object.assign({}, resultField),
                  value: container[resultField.apiName].replaceAll(";", " - ")
                });
              } else {
                containerById.record.push({
                  field: resultField,
                  value: container[resultField.apiName]
                });
              }
            }
          });
          return containerById;
        });

        component.set("v.containers_valuesMap", containersById);

        container_Ids = container_Ids.slice(0, container_Ids.lastIndexOf(";"));

        component.set("v.container_Ids", container_Ids);
        helper.getReservations(component, event, helper);

        component.set("v.spinner", false);
      } else {
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

  getReservations: function (component, event, helper) {
    var assetIds = component.get("v.container_Ids");
    let resources = [];
    var action = component.get("c.getReservationsFSL");
    action.setParams({
      assetIds: assetIds
    });
    action.setCallback(this, function (a) {
      var state = a.getState();
      if (state === "SUCCESS") {
        var response = a.getReturnValue();
        let reservations = response.map((reservation) => {
          const description = helper.setDescription(reservation);
          // let color = "";
          // if (reservation.Status__c === "Planifiée") {
          //   color = helper.getColorByRecordType(
          //     reservation.Record_Type_Name__c,
          //     ["#E09E68", "#7FC9A5", "#77AABD"]
          //   );
          // } else {
          //   color = helper.getColorByRecordType(
          //     reservation.Record_Type_Name__c,
          //     ["#EF7E33", "#01AF50", "#0170C1"]
          //   );
          // }
          if (reservation.Asset_assigne__c) {
            resources.push({
              id: reservation.Asset_assigne__c,
              container : reservation.Asset_assigne__r.Name,
              client : reservation.Asset_assigne__r.Account && reservation.Asset_assigne__r.Account.Name,
              agence : reservation.Asset_assigne__r.Agence_Localisation__r && reservation.Asset_assigne__r.Agence_Localisation__r.Name,
            });
          }
          return {
            id: reservation.Id,
            resourceId: reservation.Asset_assigne__c,
            start: reservation.Date_de_debut__c,
            end: reservation.Date_de_fin__c,
            title: reservation.Name,
            // color,
            description,
            recordType: reservation.Record_Type_Name__c,
            status: reservation.Status__c
          };
        });

        $("#calendar").fullCalendar("destroy");
        $("#calendar").fullCalendar({
          eventClick: function (calEvent, jsEvent, view) {
            var url = "/" + calEvent.id;
            window.open(url, "_blank");
          },
          now: new Date(),
          editable: false,
          droppable: false,
          aspectRatio: 1.8,
          scrollTime: "00:00",
          header: {
            left: "today prev,next",
            center: "title",
            right: ""
          },
          height: "auto",
          locale: "fr",
          defaultView: "timelineThreeDays",
          views: {
            timelineThreeDays: {
              type: "timeline",
              duration: { days: 30 }
            }
          },
          resourceColumns: [
            {
              labelText: 'CONTAINER',
              field: 'container',
              width: "33%"
            },
            {
              labelText: 'CLIENT',
              field: 'client',
              width: "33%"
            },
            {
              labelText: 'AGENCE',
              field: 'agence',
              width: "33%"
            }
          ],
          resourceAreaWidth : "40%",
          // resourceAreaColumns: [
          //     {
          //         field: 'title',
          //         headerContent: 'Conteneur'
          //     },
          //     {
          //         field: 'compte',
          //         headerContent: 'Compte'
          //     }
          // ],
          events: [...reservations],
          resourceLabelText:[...new Set([...resources.map(({id}) => id)])].length + " Conteneur(s)",
          resources: resources.length > 0 ? [...resources] : null,
          eventRender: function ({ description, recordType, status }, element) {
            let color = "";
            if (status === "Planifiée") {
              color = helper.getColorByRecordType(recordType, [
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
              color = helper.getColorByRecordType(recordType, [
                "#EF7E33",
                "#01AF50",
                "#0170C1"
              ]);
              element.css("background-color", `${color}`);
              element.css("border-color", `${color}`);
            }
            element.append(
              '<div class="description">' + description + "</div>"
            );
          }
        });
        if (resources.length === 0) {
          $("#calendar").fullCalendar("option", "height", 400);
        }
        helper.disableHolidays(component, helper);
        helper.overrideStandardCalendarEvents(component, helper);
        component.set("v.spinner", false);
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

  setDescription: function (reservation) {
    let description = "<p>" + (reservation.Status__c || "") + "</p>";

    /*if (reservation.Record_Type_Name__c == "Atelier")
      description += "<p>" + (reservation.Type_Atelier__c || "") + "</p>";
    else if (reservation.Record_Type_Name__c == "Transport")
      description += "<p>" + (reservation.Type_de_transport__c || "") + "</p>";
    else if (reservation.Record_Type_Name__c == "Location")
      description += "<p>" + (reservation.Type_de_Location__c || "") + "</p>";*/

    description += "<p>" + (reservation.Type__c || "");
    if (reservation.Type_de_conteneur__c != null)
      description += " - " + (reservation.Type_de_conteneur__r.Name || "");
    description += "</p>";
    description += "<p>" + (reservation.Shipping_City__c || "") + "</p>";

    return description;
  },

  showToast: function (type, title, message, component, event, helper) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      type: type,
      title: title,
      message: message
    });
    toastEvent.fire();
  },

  getHolidays: function (component) {
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
    const calendarDaysElements = document.querySelectorAll(".fc-widget-header");
    const holidays = component.get("v.holidays");
    calendarDaysElements &&
      calendarDaysElements.forEach((calendarDayElement) => {
        const holiday = holidays.find(
          ({ ActivityDate }) => ActivityDate === calendarDayElement.dataset.date
        );
        if (helper.isWeekend(calendarDayElement.dataset.date)) {
          calendarDayElement.style = "background-color: rgb(233 231 231); ";
        }
        if (holiday) {
          const spanEl = document.createElement("span");
          spanEl.classList.add("holiday");
          spanEl.innerHTML = holiday.Name;
          calendarDayElement.appendChild(spanEl);
          calendarDayElement.style =
            "background-color: #c4c1c1;position:relative;cursor:pointer;";
        }
      });
  },
  overrideStandardCalendarEvents: function (component, helper) {
    const calendarBtns = document.querySelectorAll(".fc-button");
    calendarBtns.forEach((calendarBtn) =>
      calendarBtn.addEventListener("click", () =>
        helper.disableHolidays(component, helper)
      )
    );
  },
  isWeekend: function (date) {
    const dayDate = new Date(date).getDay();
    return [0, 6].includes(dayDate);
  }
});
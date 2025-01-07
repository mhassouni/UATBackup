({
  /************************************** ON INIT  **************************************/

  doInit: function (component, event, helper) {
    component.set("v.spinner", true);

    var pageReference = component.get("v.pageReference");
    component.set("v.refRecordId", pageReference.state.c__refRecordId);

    helper.setWorkspace(component, event, helper);

    if (component.get("v.refRecordId")) {
      helper.getOrderDetails(component, event, helper);
    } 
    else {
      //helper.getReservationRecordTypes(component, event, helper);
      helper.getSearchFields_Reservation(component, event, helper);
      helper.getSearchFields_Container(component, event, helper);
    }
  },

  /************************************** ON CHANGE  **************************************/

  handleOptionChange: function (component, event, helper) {
    var selectedOptions = event.getParam("value");

    var container = component.get("v.container_filter");
    if (container != null) {
      container["Options__c"] = selectedOptions.join(";");
    } 
    else {
      container = {};
      container["Options__c"] = selectedOptions.join(";");
    }
    component.set("v.container_filter", container);
  },

  /************************************** ON SUBMIT  **************************************/

  /**************** RESERVATIONS ****************/

  search_reservations: function (component, event, helper) {
    component.set("v.spinner", true);

    try {
      if (event && JSON.stringify(event) != "{}") {
        event.preventDefault();
        var eventFields = event.getParam("fields");
        var reservation = component.get("v.reservation_filter");
        var fields = Object.keys(eventFields);
        for (var indexField in fields) {
          if (eventFields[fields[indexField]] != null) {
            if (reservation != null) {
              reservation[fields[indexField]] = eventFields[fields[indexField]];
            } 
            else {
              reservation = {};
              reservation[fields[indexField]] = eventFields[fields[indexField]];
            }
          }
          else {
            reservation[fields[indexField]] = null;
          }
        }
        component.set("v.reservation_filter", reservation);
      }
      component.set("v.initReservationInputField", false);

      helper.getReservations(component, event, helper);
    } 
    catch (error) {
      console.error(error);
      helper.showToast("error", "ERREUR !", "", component, event, helper);
      component.set("v.spinner", false);
    }
  },

  reset_reservation_filter: function (component, event, helper) {
    component.set("v.spinner", true);

    var searchFields = component.get("v.searchFields_reservation");
    var reservation_filter = component.get("v.reservation_filter");

    try {
      //Reset OrderId
      var order = component.get("v.order");
      order.Id = null;
      component.set("v.order", order);

      //Reset Other fields
      var reservation_RecordType = component.find("reservation_RecordType");
      var reservation_inputField = component.find("reservation_inputField");
      var reservation_DateDebut = component.find("reservation_DateDebut");
      var reservation_DateFin = component.find("reservation_DateFin");
      var filter;
      for (var indexField in searchFields) {
        /*if(searchFields[indexField].apiName == 'RecordTypeId'){
					reservation_RecordType.set('v.value', null); 
				}
				else*/
        searchFields[indexField].value = null;
        if (searchFields[indexField].apiName == "Date_de_debut__c") {
          reservation_DateDebut.set("v.value", null);
        } 
        else if (searchFields[indexField].apiName == "Date_de_fin__c") {
          reservation_DateFin.set("v.value", null);
        }
        else {
          filter = reservation_inputField.filter(
            (x) => x.get("v.fieldName") === searchFields[indexField].apiName
          )[0];
          if (filter) filter.set("v.value", null);
        }
      }
    } 
    catch (error) {
      console.error(error);
      helper.showToast("error", "ERREUR !", "", component, event, helper);
    }
    component.set("v.searchFields_reservation", searchFields);
    component.set("v.spinner", false);
  },

  edit_reservation: function (component, event, helper) {
    var currentTarget = event.currentTarget;
    var reservationId = currentTarget.dataset.value;

    var editRecordEvent = $A.get("e.force:editRecord");
    editRecordEvent.setParams({
      recordId: reservationId
    });
    editRecordEvent.fire();
  },

  /**************** CONTAINERS ****************/
//Pagination
handlePrevPage: function(component, event, helper) {
    var currentOffset = component.get("v.OFFSET");
    component.set("v.OFFSET", currentOffset - 20);
},

handleNextPage: function(component, event, helper) {
    var currentOffset = component.get("v.OFFSET");
    component.set("v.OFFSET", currentOffset + 20);
},
///
  search_containers: function (component, event, helper) {
    component.set("v.spinner", true);

    try {
      event.preventDefault();
      var eventFields = event.getParam("fields");
      var container = component.get("v.container_filter");
      var fields = Object.keys(eventFields);
      for (var indexField in fields) {
        if (eventFields[fields[indexField]] != null) {
          if (container != null) {
            container[fields[indexField]] = eventFields[fields[indexField]];
          }
          else {
            container = {};
            container[fields[indexField]] = eventFields[fields[indexField]];
          }
        } 
        else {
          container[fields[indexField]] = null;
        }
      }
      component.set("v.container_filter", container);
      
    } 
    catch (error) {
      console.error(error);
      helper.showToast("error", "ERREUR !", "", component, event, helper);
      component.set("v.spinner", false);
    }

    helper.getContainers(component, event, helper);
  },

  reset_container_filter: function (component, event, helper) {
    component.set("v.spinner", true);

    var searchFields = component.get("v.searchFields_container");
    var container_filter = component.get("v.container_filter");

    try {
      //Reset fields
      var assetName = component.find("assetName");
      var container_inputFields = component.find("container_inputFields");
      var container_DateDebut = component.find("container_DateDebut");
      var container_DateFin = component.find("container_DateFin");
      var container_Options = component.find("container_Options");
      var filter;
      for (var indexField in searchFields) {
        searchFields[indexField].value = null;
        if (searchFields[indexField].apiName == "Name") {
          assetName.set("v.value", null);
        } 
        else if (
          searchFields[indexField].apiName == "Date_de_debut_asset__c"
        ) {
          container_DateDebut.set("v.value", null);
        } 
        else if (searchFields[indexField].apiName == "Date_de_fin_asset__c") {
          container_DateFin.set("v.value", null);
        } 
        else {
          /*else if (searchFields[indexField].apiName == "Options__c") {
          container_Options.set("v.value", null);
          component.set("v.selectedOptions", null);
        } */
          filter = container_inputFields.filter(
            (x) => x.get("v.fieldName") === searchFields[indexField].apiName
          )[0];
          if (filter) filter.set("v.value", null);
        }
      }
    } 
    catch (error) {
      console.error(error);
      helper.showToast("error", "ERREUR !", "", component, event, helper);
    }
    component.set("v.searchFields_container", searchFields);
    component.set("v.spinner", false);
  },

  viewCalendar: function (component, event, helper) {
    let currentTarget = event.currentTarget;
    let containerId = currentTarget.dataset.value;
    let containerName = currentTarget.dataset.containerName;
    
    /* Filter */
    let reservationFilter = component.get("v.reservation_filter");
    let filters = [];
    for (let field in reservationFilter) {
      if(reservationFilter[field]) filters.push(`${field}:${reservationFilter[field]}`);
    }
    let filterString = filters.join(",");

    window.open(
      `/lightning/n/Fleet_Management_Gantt?c__assetId=${containerId}&c__containerName=${containerName}&c__filters=${filterString}`,
      "_blank"
    );

    // urlEvent.fire();
  },
        
  viewFSL: function (component, event, helper) {
      /* Filter */
      let reservationFilter = component.get("v.container_filter");
      let filters = [];
      for (let field in reservationFilter) {
        if(reservationFilter[field]) filters.push(`${field}:${reservationFilter[field]}`);
      }
      let filterString = filters.join(",");

      ///window.open("/lightning/n/Fleet_Management_Vue_FSL");
      window.open(`/lightning/n/Fleet_Management_Vue_FSL?c__filters=${filterString}`,"_blank");
  }

});
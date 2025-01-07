({
  updateSearchResults: function (cmp, evt, hlp) {
    hlp.getSearchResults(cmp, evt, hlp);
  },
  next: function (cmp, evt, hlp) {
    $("#calendar").fullCalendar("next");
  },
  jsLoaded: function (cmp, evt, hlp) {
    hlp.makeSearchResultsDraggable(cmp, hlp);
  },
  reload: function (cmp, evt, hlp) {
    hlp.getSearchResults(cmp, evt, hlp);
  },
  pageUp: function (cmp, evt, hlp) {
    var paginationMax = cmp.get("v.paginationMax");
    var currentPageMax = cmp.get("v.currentPageMax");
    var currentPageMin = cmp.get("v.currentPageMin");
    currentPageMax = currentPageMax + paginationMax;
    currentPageMin = currentPageMin + paginationMax;
    cmp.set("v.currentPageMax", currentPageMax);
    cmp.set("v.currentPageMin", currentPageMin);
    // The setTimeout is necessary in order to run the function checkSelectedReservations after DOM update
    setTimeout(() => hlp.checkSelectedReservations(cmp), 0);
    hlp.makeSearchResultsDraggable(cmp, hlp);
  },

  pageDown: function (cmp, evt, hlp) {
    var paginationMax = cmp.get("v.paginationMax");
    var currentPageMax = cmp.get("v.currentPageMax");
    var currentPageMin = cmp.get("v.currentPageMin");
    currentPageMax = currentPageMax - paginationMax;
    currentPageMin = currentPageMin - paginationMax;
    cmp.set("v.currentPageMax", currentPageMax);
    cmp.set("v.currentPageMin", currentPageMin);
    // The setTimeout is necessary in order to run the function checkSelectedReservations after DOM update
    setTimeout(() => hlp.checkSelectedReservations(cmp), 0);
    hlp.makeSearchResultsDraggable(cmp, hlp);
  },

  onCheckReservation: function (component, event, helper) {
    var reservationId = event.target.value;
    var selectedReservations = component.get("v.selectedReservations");
    const reservationsValuesMap = component.get("v.reservationsValuesMap");

    if (selectedReservations.includes(reservationId)) {
      selectedReservations = selectedReservations.filter(
        (id) => id !== reservationId
      );
    } 
    else {
      selectedReservations.push(reservationId);
    }
    component.set("v.selectedReservations", selectedReservations);

    if (
      selectedReservations.length === reservationsValuesMap.length &&
      selectedReservations.length > 0
    ) {
      document.getElementById("check-all").checked = true;
    } 
    else if (selectedReservations.length !== reservationsValuesMap.length) {
      document.getElementById("check-all").checked = false;
    }
  },

  onCheckAllReservations: function (component, event, helper) {
    try {
      let selectedReservations = component.get("v.selectedReservations");
      if (event.target.checked) {
        let reservationsValuesMap = component.get("v.reservationsValuesMap");
        reservationsValuesMap = reservationsValuesMap.filter(
          (reservationValueMap) =>
            reservationValueMap.record[9].value ===
            "En attente de planification"
        );
        selectedReservations = reservationsValuesMap.map(({ id }) => id);
        component.set("v.selectedReservations", selectedReservations);
        helper.checkSelectedReservations(component);
      } 
      else {
        helper.deselectAllReservations(component);
      }
    } catch (error) {
      console.error(error);
    }
  },

  handleConfirm: function (component, event, helper) {
    let selectedReservations = component.get("v.selectedReservations");
    if (selectedReservations && selectedReservations.length > 0) {
      component.set("v.spinner", true);      
      
      let allReservations = component.get("v.searchResults");
      let reservations = allReservations.filter((obj) => selectedReservations.includes(obj.Id));      
      let reservation;
      if(reservations){
        for(var index in reservations){
          reservation = reservations[index];
          if(reservation.Date_de_debut__c == null || reservation.Date_de_fin__c == null){
            helper.showToast("warning", "ATTENTION !", "Merci de renseigner la date de début et la date de fin de la réservation : " + reservation.Name + ".");
            component.set("v.spinner", false);
            return;
          }
        }
        helper.getAssetReservations(reservations, selectedReservations, component, event, helper);
      }
      else{
        component.set("v.spinner", false);      
      }
    }
  },
  
  doRefresh: function (component, event, helper) {
    document.getElementById("check-all").checked = false;
    component.set("v.currentPageMin", 0);
    component.set("v.currentPageMax", 5);
    component.set("v.selectedReservations", []);
    helper.deselectAllReservations(component);
  }
});
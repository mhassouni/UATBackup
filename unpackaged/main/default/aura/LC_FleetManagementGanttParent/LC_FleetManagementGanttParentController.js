({
  doInit: function (cmp, evt, hlp) {
    hlp.getAssetInfoFromURL(cmp);
    hlp.getSearchFields_Reservation(cmp, evt, hlp);
    hlp.setWorkspace(cmp);
  },
  search_reservations: function (component, event, helper) {
    try {
      event.preventDefault();

      component.set("v.spinner", true);
      component.find("fleet-management-gantt-search").refresh();

      var eventFields = event.getParam("fields");
      var reservation = component.get("v.reservation_filter");

      for(let key in eventFields){
        reservation[key] = eventFields[key];
      }
      component.set("v.reservation_filter", reservation);
      helper.getReservations(component, event, helper);
    } catch (exception) {
      console.error(exception);
      component.set("v.spinner", false);
    }
  },
  handleNotifyGanttParent: function (component, event, helper) {
    component.find("FleetManagementGantt").reloadEvents();
    helper.getSearchFields_Reservation(component, event, helper);
  }
});
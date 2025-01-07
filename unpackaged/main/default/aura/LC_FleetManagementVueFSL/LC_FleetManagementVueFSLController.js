({
  doInit: function (component, event, helper) {
    helper.getHolidays(component);
  },

  jsLoaded: function (component, event, helper) {
    $(document).ready(function () {
      $(window).focus();
      helper.setWorkspace(component, event, helper);
      helper.getInfoFromURL(component, event, helper);
      helper.getSearchFields_Container(component, event, helper); //Filter
    });
  },
  search_containers: function (component, event, helper) {
    try {
      event.preventDefault();
      component.set("v.spinner", true);
      let eventFields = event.getParam("fields");
      let container = component.get("v.container_filter");
      for(let key in eventFields){
        container[key] = eventFields[key];
      }
      component.set("v.container_filter", container);
    } catch (error) {
      console.error(error);
      helper.showToast("error", "ERREUR !", "", component, event, helper);
      component.set("v.spinner", false);
    }

    helper.getContainers(component, event, helper);
  }
});
/**
 * @description       :
 * @author            : Michaël Cabaraux
 * @group             : 2Pace
 * @last modified on  : 06-07-2023
 * @last modified by  : Michaël Cabaraux
**/
@SuppressWarnings('PMD.VariableNamingConventions, PMD.ExcessivePublicCount,PMD.TooManyFields')
public with sharing class Intf_Framework_Triggers {

    private static Set<String> bypassedHandlers;

    static {
        bypassedHandlers = new Set<String>();
    }

    //----------------------------------------------------------------
    //	Enum representing each of before/after CRUD events on Sobjects
    //----------------------------------------------------------------
    public enum Evt {
        afterdelete,
        afterinsert,
        afterundelete,
        afterupdate,
        beforedelete,
        beforeinsert,
        beforeupdate
    }

    //----------------------------------------------------------------
    //	Simplistic handler to implement on any of the event. It doesn't requires or enforces any patter except the
    //	method name to be "handle()", a developer is free to use any Trigger context variable or reuse any other
    //	apex class here.
    //----------------------------------------------------------------
    public interface Handler {
        void handle();
    }

    // Internal mapping of handlers
    private Map<String, List<Handler>> eventHandlerMapping = new Map<String, List<Handler>>();

    //----------------------------------------------------------------
    //	Core API to bind handlers with events
    //----------------------------------------------------------------
    public Intf_Framework_Triggers bind(Evt event, Handler eh) {

        List<Handler> handlers = eventHandlerMapping.get(event.name());
         if (handlers == null) {
            handlers = new List<Handler>();
            eventHandlerMapping.put(event.name(), handlers);
        }
        handlers.add(eh);
        return this;
    }

    //----------------------------------------------------------------
    //	Invokes correct handlers as per the context of trigger and available registered handlers
    //----------------------------------------------------------------
    public void manage() {
        Evt ev = null;

        if(Trigger.isInsert && Trigger.isBefore){
            ev = Evt.beforeinsert;
        } else if(Trigger.isInsert && Trigger.isAfter){
            ev = Evt.afterinsert;
        } else if(Trigger.isUpdate && Trigger.isBefore){
            ev = Evt.beforeupdate;
        } else if(Trigger.isUpdate && Trigger.isAfter){
            ev = Evt.afterupdate;
        }  else if(Trigger.isDelete && Trigger.isBefore){
            ev = Evt.beforedelete;
        } else if(Trigger.isDelete && Trigger.isAfter){
            ev = Evt.afterdelete;
        } else if(Trigger.isundelete){
            ev = Evt.afterundelete;
        }

        List<Handler> handlers = eventHandlerMapping.get(ev.name());

        if (handlers != null && !handlers.isEmpty()) {
            for (Handler h : handlers) {
                String handlerName = String.valueOf(h).substring(0,String.valueOf(h).indexOf(':'));
                System.debug(' --------------------------  Handler Name :' + handlerName);
				
                if (validateRun(handlerName)) { h.handle(); }
            }
        }
    }

    @TestVisible
    private Boolean validateRun(String handlerName) {

        if(Intf_Framework_Triggers.bypassedHandlers.contains(handlerName)) {
            return false;
        }
        return true;
    }

    public static void handlerBypass(String handlerName) {
        Intf_Framework_Triggers.bypassedHandlers.add(handlerName);
    }

    public static void clearHandlerBypass(String handlerName) {
        Intf_Framework_Triggers.bypassedHandlers.remove(handlerName);
    }

    public static Boolean isHandlerBypassed(String handlerName) {
        return Intf_Framework_Triggers.bypassedHandlers.contains(handlerName);
    }

    public static void clearAllHandlerBypasses() {
        Intf_Framework_Triggers.bypassedHandlers.clear();
    }
}
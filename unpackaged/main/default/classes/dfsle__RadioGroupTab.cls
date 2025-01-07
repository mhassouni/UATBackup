/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class RadioGroupTab extends dfsle.Tab {
    global dfsle.Tab.Collaboration collaboration {
        get;
    }
    global List<dfsle.RadioGroupTab.Radio> radios {
        get;
    }
    global RadioGroupTab() {

    }
    global dfsle.RadioGroupTab withCollaboration(dfsle.Tab.Collaboration collaboration) {
        return null;
    }
    global dfsle.RadioGroupTab withRadios(List<dfsle.RadioGroupTab.Radio> radios) {
        return null;
    }
global class Position {
    global Integer pageNumber {
        get;
    }
    global Integer x {
        get;
    }
    global Integer y {
        get;
    }
    global Position(Integer pageNumber, Integer x, Integer y) {

    }
}
global class Radio {
    global dfsle.Tab.Anchor anchor {
        get;
    }
    global dfsle.Tab.Formatting formatting {
        get;
    }
    global Integer order {
        get;
    }
    global dfsle.RadioGroupTab.Position position {
        get;
    }
    global Boolean readOnly {
        get;
    }
    global Boolean required {
        get;
    }
    global Boolean selected {
        get;
    }
    global Object value {
        get;
    }
    global Radio(Integer order, dfsle.RadioGroupTab.Position position, dfsle.Tab.Formatting formatting, dfsle.Tab.Anchor anchor, Object value, Boolean selected, Boolean readOnly, Boolean required) {

    }
}
}

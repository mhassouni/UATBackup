@istest
global with sharing class CatalogueAPIMock_201 implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"body": {"produit": {"code_pf": "","charge_utile": "","standard_pf": "","marque": "","ptac": "","modele": "","amenagement_chassis": "","longueur_interieur": "","largeur_interieur": "","hauteur_interieur": "","hauteur_maxi_hors_tout": "","largeur": "","longueur": "","hauteur_seuil": "","empattement": "","porte_a_faux_arr": "","volume_palettes": "","amenagement_caisse": "","amenagement_groupe": "","amenagement_hayon": ""}}}');
        response.setStatusCode(200);
        return response;
    }
    

}
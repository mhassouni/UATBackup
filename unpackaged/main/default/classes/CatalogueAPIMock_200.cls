@istest
global with sharing class CatalogueAPIMock_200 implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"body": {"produit": {"code_pf": "RE M CF Maxicargo","charge_utile": "1","standard_pf": "H01","marque": "MAXICARGO","ptac": "3500","modele": "REM CF","amenagement_chassis": ",Pneumatiques : 225/75 R 17,5,Suspension mécanique,Freinage à inertie,Châssis galvanisé,1 essieu monte simple (type poids lourd),Béquilles manuelles,Pneus 4 saisons,Barre anti-encastrement avec grille protection feux arrière,Faux chassis Maxicargo de 100 mm,Escalier arrière central pivotant  largeur 700 mm - Tout aluminium - 4 marches - Seuil bas,MAXIGRIP - Pour passages difficiles,","longueur_interieur": "4130","largeur_interieur": "2054","hauteur_interieur": "2050","hauteur_maxi_hors_tout": "3230","largeur": "2200","longueur": "10","hauteur_seuil": "1070","empattement": "3000","porte_a_faux_arr": "10","volume_palettes": "17 / 8 palettes 800 x 1200 mm","amenagement_caisse": "Isolation renforcée,2 portes arrière ouverture totale (porte droite prioritaire),Plancher : Antidérapant sans passages de roues avec 2 siphons d\'évacuation,1 plafonniers à LED avec temporisation,Protection bas de parois sur 245 mm de haut,Coffre pour rallonge à l\'AR gauche (sans clé),Prise Fenwick de racordement au tracteur,Caméra de recul avec écran dans la cabine du tracteur + câble spiralé,","amenagement_groupe": "CARRIER,PULSOR 500,ou équivalent,Fonctionnement Route et Secteur,(220 V Monophasé),Hauteur sous évaporateur : 1850 mm,1 rallonge de 10 ml,Datacold 600T + imprimante,Boitier de Sécurité de raccordement GROUPE PULSOR entre Tracteur et Remorque,1 Commande du groupe sur remorque,","amenagement_hayon": "x"}}}');
        response.setStatusCode(200);
        return response;
    }
    

}
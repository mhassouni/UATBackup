/*
* Lorsque l'utilisateur clique sur le bouton Nouveau pour créer une nouvelle piste, 
* les champs « Compte (Raison Sociale) » et « Nom » sont remplis automatiquement par la valeur « SIGHTING » 
* (ceci pour aider l'utilisateur au cas où il ne possède pas ces informations, ces champs étant obligatoires pour la création d'une piste). 
* Ces 2 champs restent modifiables, et un text d'aide indique à l'utilisateur le message suivant: 
* « Si le nom du compte et/ou le nom de la piste sont inconnus, veuillez saisir le terme « SIGHTING ». »
* @Author Ali Naji
* @TestClass for RedirectPisteInt
*/
@isTest
private class VFE04_PisteNouvelle_TEST {

    static testMethod void myUnitTest() {

        ApexPages.StandardController controller;
        VFE04_PisteNouvelle r = new VFE04_PisteNouvelle(controller);
        r.Redirects();

    }
}
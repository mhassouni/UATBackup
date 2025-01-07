/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class ReturnAdminUser {
    global ReturnAdminUser() {

    }
    @InvocableMethod(label='Return Admin User Mail' description='Return Admin User Mail')
    global static List<FSL.ReturnAdminUser.AdminUserDetails> returnAdminUser() {
        return null;
    }
global class AdminUserDetails {
    @InvocableVariable(label='User Email' description='User Email' required=true)
    global String userMail;
    @InvocableVariable(label='User Name' description='User Name' required=true)
    global String userName;
    global AdminUserDetails() {

    }
}
}

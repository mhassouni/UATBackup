global class GeographicFootprint_Batch implements Database.Batchable<sObject> {
    
    // Liste des comptes à mettre à jour
    global List<Account> accountsToUpdate = new List<Account>();
    
    // Taille du lot à traiter à la fois
    private Integer batchSize = 200; // Taille du lot
    
    // Index de départ pour le traitement de chaque lot
    private Integer startIndex = 0;
    
    // Constructeur prenant en paramètre la liste des comptes à mettre à jour
    global GeographicFootprint_Batch(List<Account> accountsToUpdate) {
        this.accountsToUpdate = accountsToUpdate;
    }
    
    // Méthode start pour renvoyer la liste des comptes à mettre à jour
    global Iterable<Account> start(Database.BatchableContext BC) {
        // Retourne la liste des comptes à mettre à jour
        return accountsToUpdate;
    }
    
    // Méthode execute pour mettre à jour les comptes par lots
    global void execute(Database.BatchableContext BC, List<Account> scope) {
        // Mettre à jour les comptes avec la valeur appropriée pour Empreinte_Geographique__c et Last_Flow_Update__c
        update scope;
    }
    
    // Méthode finish
    global void finish(Database.BatchableContext BC) {
        // Déplacer l'index de départ vers le prochain lot
        startIndex += batchSize;
        // Vérifier s'il reste des enregistrements à traiter
        if (startIndex < accountsToUpdate.size()) {
            // Créer un nouveau lot en extrayant les enregistrements suivants de la liste
            List<Account> nextScope = new List<Account>();
            Integer endIndex = Math.min(startIndex + batchSize, accountsToUpdate.size());
            for (Integer i = startIndex; i < endIndex; i++) {
                nextScope.add(accountsToUpdate[i]);
            }
            // Planifier un nouveau lot pour le prochain lot
            GeographicFootprint_Batch nextBatch = new GeographicFootprint_Batch(nextScope);
            Database.executeBatch(nextBatch, batchSize);
        }
    }
    
    // Méthode pour définir la taille du lot
    global Integer getBatchSize() {
        return batchSize;
    }
}
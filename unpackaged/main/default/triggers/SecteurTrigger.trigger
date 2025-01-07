trigger SecteurTrigger on Secteur__c (after update) {
    Set<Id> secteurIdsToProcess = new Set<Id>();

    for (Secteur__c newSecteur : Trigger.new) {
        Secteur__c oldSecteur = Trigger.oldMap.get(newSecteur.Id);
        if (newSecteur.Commercial__c != oldSecteur.Commercial__c ||
            newSecteur.Manager_Commercial__c != oldSecteur.Manager_Commercial__c) {
            secteurIdsToProcess.add(newSecteur.Id);
        }
    }

    if (!secteurIdsToProcess.isEmpty()) {
        // Enqueue the Batch Apex job
        BatchUpdateSalesAreaData batchJob = new BatchUpdateSalesAreaData(secteurIdsToProcess);
        Database.executeBatch(batchJob, 200); // Adjust batch size as needed
    }
}
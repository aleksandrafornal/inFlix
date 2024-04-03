trigger SeasonTrigger on Season__c (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            Set<String> uniqueSeasonNames = new Set<String>();
            Set<Id> seriesIds = new Set<Id>();

            for (Season__c season : Trigger.new) {
                uniqueSeasonNames.add(season.Name);
                seriesIds.add(season.TV_Series__c);
            }

            for (Season__c existingSeason : [SELECT Id, Name FROM Season__c WHERE TV_Series__c IN :seriesIds]) {
                if (uniqueSeasonNames.contains(existingSeason.Name)) {
                    Trigger.new[0].addError('A season named "' + existingSeason.Name + '" already exists in this TV series.');
                }
            }
        } else if (Trigger.isUpdate) {
            Set<String> uniqueSeasonNames = new Set<String>();
            Set<Id> seriesIds = new Set<Id>();
            Map<Id, String> newSeasonNamesBySeries = new Map<Id, String>();
            Map<Id, String> oldSeasonNamesBySeries = new Map<Id, String>();

            for (Season__c season : Trigger.new) {
                uniqueSeasonNames.add(season.Name);
                seriesIds.add(season.TV_Series__c);
                newSeasonNamesBySeries.put(season.TV_Series__c, season.Name);
            }

            for (Season__c season : Trigger.old) {
                oldSeasonNamesBySeries.put(season.TV_Series__c, season.Name);
            }

            for (Season__c existingSeason : [SELECT Id, Name, TV_Series__c FROM Season__c WHERE TV_Series__c IN :seriesIds]) {
                String newSeasonName = newSeasonNamesBySeries.get(existingSeason.TV_Series__c);
                String oldSeasonName = oldSeasonNamesBySeries.get(existingSeason.TV_Series__c);
                if (newSeasonName != oldSeasonName) {
                    if (uniqueSeasonNames.contains(existingSeason.Name)) {
                        Trigger.new[0].addError('A season named "' + existingSeason.Name + '" already exists in this TV series.');
                    }
                }
            }
        }
    }
}
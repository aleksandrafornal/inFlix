trigger EpisodeTrigger on Episode__c (before insert, before update) {
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        if (Trigger.isInsert){
            Set<String> uniqueEpisodeNames = new Set<String>();
            Set<Id> seriesIds = new Set<Id>();
            Map<Id, Id> seasonIdsBySeries = new Map<Id, Id>();
            for (Episode__c episode : Trigger.new) {
                uniqueEpisodeNames.add(episode.Name);
                seriesIds.add(episode.TV_Series__c);
                seasonIdsBySeries.put(episode.TV_Series__c, episode.Season__c);

                Season__c season = [SELECT Id, TV_Series__c FROM Season__c WHERE Id = :episode.Season__c LIMIT 1];

                if (season.TV_Series__c != episode.TV_Series__c) {
                    Trigger.new[0].addError('A season and an episode must belong in the same TV series.');
                }
            }
        
            for (Episode__c existingEpisode : [SELECT Id, Name, TV_Series__c, Season__r.TV_Series__c  FROM Episode__c WHERE TV_Series__c IN :seriesIds]) {
                if (uniqueEpisodeNames.contains(existingEpisode.Name)) {
                    Trigger.new[0].addError('An episode named "' + existingEpisode.Name + '" already exists in this TV series.');
                }
            }
        }else if (Trigger.isUpdate){
            Set<String> uniqueEpisodeNames = new Set<String>();
            Set<Id> seriesIds = new Set<Id>();
            Map<Id, Id> seasonIdsBySeries = new Map<Id, Id>();
            Map<Id, String> newEpisodeNamesBySeries = new Map<Id, String>();
            Map<Id, String> oldEpisodeNamesBySeries = new Map<Id, String>();

            for (Episode__c episode : Trigger.new) {
                uniqueEpisodeNames.add(episode.Name);
                seriesIds.add(episode.TV_Series__c);
                newEpisodeNamesBySeries.put(episode.TV_Series__c, episode.Name);
                seasonIdsBySeries.put(episode.TV_Series__c, episode.Season__c);

                Season__c season = [SELECT Id, TV_Series__c FROM Season__c WHERE Id = :episode.Season__c LIMIT 1];

                if (season.TV_Series__c != episode.TV_Series__c) {
                    Trigger.new[0].addError('A season and an episode must belong in the same TV series.');
                }
            }

            for (Episode__c episode : Trigger.old) {
                oldEpisodeNamesBySeries.put(episode.TV_Series__c, episode.Name);
            }
        
            for (Episode__c existingEpisode : [SELECT Id, Name, TV_Series__c, Season__r.TV_Series__c  FROM Episode__c WHERE TV_Series__c IN :seriesIds]) {
                String newEpisodeName = newEpisodeNamesBySeries.get(existingEpisode.TV_Series__c);
                String oldEpisodeName = oldEpisodeNamesBySeries.get(existingEpisode.TV_Series__c);
                if (newEpisodeName != oldEpisodeName) {
                    if (uniqueEpisodeNames.contains(existingEpisode.Name)) {
                        Trigger.new[0].addError('An episode named "' + existingEpisode.Name + '" already exists in this TV series.');
                    }
                }
            }
        }
    }
}
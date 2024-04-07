/**
 * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
 * @date 07/04/2024
 * @description This class handles the logic related to naming episodes.
 */
public class EpisodeNameHandler {
    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description Error message indicating that a season and episode must belong in the same TV series.
     */
    @TestVisible
    private static final String DIFFERENT_TV_SERIES_ERROR_MESSAGE = 'A season and an episode must belong in the same TV series.';

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description The method handles logic before insertion of Episode__c records.
     * 
     * @param inInsertedEpisodes List of Episode__c objects to be inserted.
     */
    public static void handleBeforeInsert(List<Episode__c> inInsertedEpisodes) {
        if(inInsertedEpisodes == null){
            return;
        }
        validateInsertedEpisodes(inInsertedEpisodes);
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description The method handles logic before updating of Episode__c records.
     * 
     * @param inUpdatedEpisodes List of Episode__c objects to be updated.
     * @param inOldEpisodes List of old Episode__c objects.
     */
    public static void handleBeforeUpdate(List<Episode__c> inUpdatedEpisodes, List<Episode__c> inOldEpisodes) {
        if(inUpdatedEpisodes == null){
            return;
        }
        validateUpdatedEpisodes(inUpdatedEpisodes, inOldEpisodes);
    }
    
    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description The method validates Episode__c name before insertion.
     * 
     * @param inInsertedEpisodes List of Episode__c objects representing inserted episodes.
     */
    @TestVisible
     private static void validateInsertedEpisodes(List<Episode__c> inInsertedEpisodes) {
        Set<String> uniqueEpisodeNames = new Set<String>();
        Set<Id> seriesIds = new Set<Id>();
        Map<Id, Id> seasonIdsBySeries = new Map<Id, Id>();
        for (Episode__c episode : inInsertedEpisodes) {
            uniqueEpisodeNames.add(episode.Name);
            seriesIds.add(episode.TV_Series__c);
            seasonIdsBySeries.put(episode.TV_Series__c, episode.Season__c);

            Season__c season = [SELECT Id, TV_Series__c FROM Season__c WHERE Id = :episode.Season__c LIMIT 1];

            if (season.TV_Series__c != episode.TV_Series__c) {
                inInsertedEpisodes[0].addError(DIFFERENT_TV_SERIES_ERROR_MESSAGE);
            }
        }
        
        for (Episode__c existingEpisode : [SELECT Id, Name, TV_Series__c, Season__r.TV_Series__c  FROM Episode__c WHERE TV_Series__c IN :seriesIds]) {
            if (uniqueEpisodeNames.contains(existingEpisode.Name)) {
                inInsertedEpisodes[0].addError('An episode named "' + existingEpisode.Name + '" already exists in this TV series.');
            }
        }
    }
    
    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description The method validates Episode__c name before updating.
     * 
     * @param inInsertedEpisodes List of Episode__c objects representing updated episodes.
     * @param inOldEpisodes List of old Episode__c objects.
     */
    @TestVisible
     private static void validateUpdatedEpisodes(List<Episode__c> inUpdatedEpisodes, List<Episode__c> inOldEpisodes) {
        Set<String> uniqueEpisodeNames = new Set<String>();
        Set<Id> seriesIds = new Set<Id>();
        Map<Id, Id> seasonIdsBySeries = new Map<Id, Id>();
        Map<Id, String> newEpisodeNamesBySeries = new Map<Id, String>();
        Map<Id, String> oldEpisodeNamesBySeries = new Map<Id, String>();

        for (Episode__c episode : inUpdatedEpisodes) {
            uniqueEpisodeNames.add(episode.Name);
            seriesIds.add(episode.TV_Series__c);
            newEpisodeNamesBySeries.put(episode.TV_Series__c, episode.Name);
            seasonIdsBySeries.put(episode.TV_Series__c, episode.Season__c);

            Season__c season = [SELECT Id, TV_Series__c FROM Season__c WHERE Id = :episode.Season__c LIMIT 1];

            if (season.TV_Series__c != episode.TV_Series__c) {
                inUpdatedEpisodes[0].addError(DIFFERENT_TV_SERIES_ERROR_MESSAGE);
            }
        }

        for (Episode__c episode : inOldEpisodes) {
            oldEpisodeNamesBySeries.put(episode.TV_Series__c, episode.Name);
        }
        
        for (Episode__c existingEpisode : [SELECT Id, Name, TV_Series__c, Season__r.TV_Series__c  FROM Episode__c WHERE TV_Series__c IN :seriesIds]) {
            String newEpisodeName = newEpisodeNamesBySeries.get(existingEpisode.TV_Series__c);
            String oldEpisodeName = oldEpisodeNamesBySeries.get(existingEpisode.TV_Series__c);
            if (newEpisodeName != oldEpisodeName) {
                if (uniqueEpisodeNames.contains(existingEpisode.Name)) {
                    inUpdatedEpisodes[0].addError('An episode named "' + existingEpisode.Name + '" already exists in this TV series.');
                }
            }
        }
    }
}
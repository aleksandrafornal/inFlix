/**
 * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
 * @date 07/04/2024
 * @description This class handles the logic related to naming seasons.
 */
public class SeasonNameHandler {
    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description The method handles logic before insertion of Season__c records.
     * 
     * @param inInsertedSeasons List of Season__c objects to be inserted.
     */
    public static void handleBeforeInsert(List<Season__c> inInsertedSeasons) {
        if(inInsertedSeasons == null){
            return;
        }
        validateInsertedSeasons(inInsertedSeasons);
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description The method handles logic before updating of Season__c records.
     * 
     * @param inUpdatedSeasons List of Season__c objects to be updated.
     * @param inOldSeasons List of old Season__c objects.
     */
    public static void handleBeforeUpdate(List<Season__c> inUpdatedSeasons, List<Season__c> inOldSeasons) {
        if(inUpdatedSeasons == null){
            return;
        }
        validateUpdatedSeasons(inUpdatedSeasons, inOldSeasons);
    }
    
    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description The method validates Season__c name before insertion.
     * 
     * @param inInsertedSeasons List of Season__c objects representing inserted seasons.
     */
    @TestVisible
     private static void validateInsertedSeasons(List<Season__c> inInsertedSeasons) {
        Set<String> uniqueSeasonNames = new Set<String>();
        Set<Id> seriesIds = new Set<Id>();

        for (Season__c season : inInsertedSeasons) {
            uniqueSeasonNames.add(season.Name);
            seriesIds.add(season.TV_Series__c);
        }

        for (Season__c existingSeason : [SELECT Id, Name FROM Season__c WHERE TV_Series__c IN :seriesIds]) {
            if (uniqueSeasonNames.contains(existingSeason.Name)) {
                inInsertedSeasons[0].addError('A season named "' + existingSeason.Name + '" already exists in this TV series.');
            }
        }
    }
    
    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description The method validates Season__c name before updating.
     * 
     * @param inUpdatedSeasons List of Season__c objects representing updated seasons.
     */
    @TestVisible
     private static void validateUpdatedSeasons(List<Season__c> inUpdatedSeasons, List<Season__c> inOldSeasons) {
        Set<String> uniqueSeasonNames = new Set<String>();
        Set<Id> seriesIds = new Set<Id>();
        Map<Id, String> newSeasonNamesBySeries = new Map<Id, String>();
        Map<Id, String> oldSeasonNamesBySeries = new Map<Id, String>();

        for (Season__c season : inUpdatedSeasons) {
            uniqueSeasonNames.add(season.Name);
            seriesIds.add(season.TV_Series__c);
            newSeasonNamesBySeries.put(season.TV_Series__c, season.Name);
        }

        for (Season__c season : inOldSeasons) {
            oldSeasonNamesBySeries.put(season.TV_Series__c, season.Name);
        }

        for (Season__c existingSeason : [SELECT Id, Name, TV_Series__c FROM Season__c WHERE TV_Series__c IN :seriesIds]) {
            String newSeasonName = newSeasonNamesBySeries.get(existingSeason.TV_Series__c);
            String oldSeasonName = oldSeasonNamesBySeries.get(existingSeason.TV_Series__c);
            if (newSeasonName != oldSeasonName) {
                if (uniqueSeasonNames.contains(existingSeason.Name)) {
                    inUpdatedSeasons[0].addError('A season named "' + existingSeason.Name + '" already exists in this TV series.');
                }
            }
        }
    }
}
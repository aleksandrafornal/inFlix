/**
 * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
 * @date 07/04/2024
 * @description This class contains test methods for the EpisodeTrigger trigger.
 */
@isTest
 public class EpisodeTriggerTest {
    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description The method sets up data for tests.
     */
    @testSetup static void setup() {
        TV_Series__c firstTVSeries = new TV_Series__c(Name = 'TestTVSeries');
        insert firstTVSeries;

        Season__c firstSeason = new Season__c(Name = 'TestTVSeries S01', TV_Series__c = firstTVSeries.Id);
        insert firstSeason;

        TV_Series__c secondTVSeries = new TV_Series__c(Name = 'SecondTestTVSeries');
        insert secondTVSeries;

        Season__c secondSeason = new Season__c(Name = 'SecondTestTVSeries S01', TV_Series__c = secondTVSeries.Id);
        insert secondSeason;

        List<Episode__c> episodes = new List<Episode__c>();
        for (Integer i = 0; i < 5; i++) {
            episodes.add(new Episode__c(Name = 'TestTVSeries S01E00' + i, TV_Series__c = firstTVSeries.Id, Season__c = firstSeason.Id));
        }
        insert episodes;
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description Test method to check the behavior when the input list of inserted episodes 
     * is null.
     */
    @isTest
    static void shouldNotPerformAnyActionsWhenInputListOfInsertedEpisodesIsNull() {
        Test.startTest();
        EpisodeNameHandler.handleBeforeInsert(null);
        Test.stopTest();

        System.assertEquals(9, Limits.getDmlRows(), 'Only DML operations from setup should have occurred');
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description Test method to check the behavior when the input list of updated episodes 
     * is null.
     */
    @isTest
    static void shouldNotPerformAnyActionsWhenInputListOfUpdatedEpisodesIsNull() {
        Test.startTest();
        EpisodeNameHandler.handleBeforeUpdate(null, null);
        Test.stopTest();

        System.assertEquals(9, Limits.getDmlRows(), 'Only DML operations from setup should have occurred');
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description Test method to check the behavior when the input list of inserted episodes 
     * is correct.
     */
    @isTest
    static void shouldNotConflictWhenInsertAndTVSeriesIsTheSameAndNameIsCorrect() {
        TV_Series__c tvSeries = [SELECT Id FROM TV_Series__c LIMIT 1];
        Season__c season = [SELECT Id FROM Season__c LIMIT 1];

        List<Episode__c> episodes = new List<Episode__c>();
        for (Integer i = 6; i < 9; i++) {
            episodes.add(new Episode__c(Name = 'TestTVSeries S01E00' + i, TV_Series__c = tvSeries.Id, Season__c = season.Id));
        }

        Test.startTest();
        Database.SaveResult[] results = Database.insert(episodes, false);
        Test.stopTest();

        for (Database.SaveResult result : results) {
            System.assert(result.isSuccess(), 'Inserting episodes should be successful');
        }
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description Test method to check the behavior when the input list of updated episodes 
     * is correct.
     */
    @isTest
    static void shouldNotConflictWhenUpdateAndTVSeriesIsTheSameAndNameIsCorrect() {
        TV_Series__c tvSeries = [SELECT Id FROM TV_Series__c LIMIT 1];
        Season__c season = [SELECT Id FROM Season__c LIMIT 1];

        List<Episode__c> episodes = [SELECT Id, Name FROM Episode__c];
        for (Episode__c episode : episodes) {
            for (Integer i = 10; i < 15; i++) {
                episode.Name = 'TestTVSeries S01E0' + i;
            }
        }

        Test.startTest();
        Database.SaveResult[] results = Database.update(episodes, false);
        Test.stopTest();

        for (Database.SaveResult result : results) {
            System.assert(result.isSuccess(), 'Updating episodes should be successful');
        }
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description Test method to check the behavior when the newly inserted episodes TV Series is different 
     * than the one in season.
     */
    @isTest
    static void shouldConflictWhenInsertedAndTVSeriesIsDifferent() {
        List<TV_Series__c> tvSeries = [SELECT Id FROM TV_Series__c];
        Season__c seasonFromDifferentTVSeries = [
            SELECT Id FROM Season__c WHERE TV_Series__c = :tvSeries[1].Id LIMIT 1
        ];

        List<Episode__c> episodes = new List<Episode__c>();
        for (Integer i = 6; i < 9; i++) {
            episodes.add(new Episode__c(Name = 'SecondTestTVSeries S01E00' + i, TV_Series__c = tvSeries[0].Id, Season__c = seasonFromDifferentTVSeries.Id));
        }

        Test.startTest();
        Database.SaveResult[] results = Database.insert(episodes, false);
        Test.stopTest();

        for (Database.SaveResult result : results) {
            System.assert(!result.isSuccess(), 'Inserting conflicting episodes should fail');
            System.assertEquals(1, result.getErrors().size(), 'There should be one error message');
            System.assertEquals(EpisodeNameHandler.DIFFERENT_TV_SERIES_ERROR_MESSAGE, result.getErrors()[0].getMessage(),
                'Error message should indicate conflict with different TV series');
        }
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description Test method to check the behavior when the newly inserted episodes has name that already exists in TV series.
     */
    @isTest
    static void shouldConflictWhenInsertedAndNameAlreadyExists() {
        TV_Series__c tvSeries = [SELECT Id FROM TV_Series__c LIMIT 1];
        Season__c season = [SELECT Id FROM Season__c LIMIT 1];

        List<Episode__c> episodes = new List<Episode__c>();
        for (Integer i = 0; i < 5; i++) {
            episodes.add(new Episode__c(Name = 'TestTVSeries S01E00' + i, TV_Series__c = tvSeries.Id, Season__c = season.Id));
        }

        Test.startTest();
        Database.SaveResult[] results = Database.insert(episodes, false);
        Test.stopTest();

        for (Database.SaveResult result : results) {
            System.assert(!result.isSuccess(), 'Inserting conflicting episodes should fail');
            System.assertEquals(1, result.getErrors().size(), 'There should be one error message');
        }
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description Test method to check the behavior when the updated episodes has name that already exists in TV series.
     */
    @isTest
    static void shouldConflictWhenUpdateddAndNameAlreadyExists() {
        TV_Series__c tvSeries = [SELECT Id FROM TV_Series__c LIMIT 1];
        Season__c season = [SELECT Id FROM Season__c LIMIT 1];
        List<Episode__c> episodesToUpdate = [SELECT Id, Name FROM Episode__c];

        List<Episode__c> episodes = new List<Episode__c>();
        for (Integer i = 10; i < 15; i++) {
            episodes.add(new Episode__c(Name = 'TestTVSeries S01E0' + i, TV_Series__c = tvSeries.Id, Season__c = season.Id));
        }

        insert episodes;

        for (Episode__c episode : episodesToUpdate) {
            for (Integer i = 10; i < 15; i++) {
                episode.Name = 'TestTVSeries S01E0' + i;
            }
        }

        Test.startTest();
        Database.SaveResult[] results = Database.update(episodesToUpdate, false);
        Test.stopTest();

        for (Database.SaveResult result : results) {
            System.assert(!result.isSuccess(), 'Inserting conflicting episodes should fail');
            System.assertEquals(1, result.getErrors().size(), 'There should be one error message');
        }
    }
}
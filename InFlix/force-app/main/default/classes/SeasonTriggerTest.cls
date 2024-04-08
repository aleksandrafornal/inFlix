/**
 * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
 * @date 07/04/2024
 * @description This class contains test methods for the SeasonTrigger trigger.
 */
@isTest
public class SeasonTriggerTest {
    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description The method sets up data for tests.
     */
    @testSetup static void setup() {
        TV_Series__c tvSeries = new TV_Series__c(Name = 'TestTVSeries', Genres__c='Fantasy');
        insert tvSeries;

        List<Season__c> seasons = new List<Season__c>();
        for (Integer i = 0; i < 5; i++) {
            seasons.add(new Season__c(Name = 'TestTVSeries S0' + i, TV_Series__c = tvSeries.Id));
        }
        insert seasons;
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description Test method to check the behavior when the input list of inserted seasons 
     * is null.
     */
    @isTest
    static void shouldNotPerformAnyActionsWhenInputListOfInsertedSeasonsIsNull() {
        Test.startTest();
        SeasonNameHandler.handleBeforeInsert(null);
        Test.stopTest();

        System.assertEquals(6, Limits.getDmlRows(), 'Only DML operations from setup should have occurred');
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description Test method to check the behavior when the input list of updated seasons 
     * is null.
     */
    @isTest
    static void shouldNotPerformAnyActionsWhenInputListOfUpdatedSeasonsIsNull() {
        Test.startTest();
        SeasonNameHandler.handleBeforeUpdate(null, null);
        Test.stopTest();

        System.assertEquals(6, Limits.getDmlRows(), 'Only DML operations from setup should have occurred');
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description Test method to check the behavior when the input list of inserted seasons 
     * is correct.
     */
    @isTest
    static void shouldNotConflictWhenSeasonIsInsertedAndNameIsCorrect() {
        TV_Series__c tvSeries = [SELECT Id FROM TV_Series__c LIMIT 1];

        List<Season__c> seasons = new List<Season__c>();
        for (Integer i = 6; i < 10; i++) {
            seasons.add(new Season__c(Name = 'TestTVSeries S0' + i, TV_Series__c = tvSeries.Id));
        }

        Test.startTest();
        Database.SaveResult[] results = Database.insert(seasons, false);
        Test.stopTest();

        for (Database.SaveResult result : results) {
            System.assert(result.isSuccess(), 'Inserting episodes should be successful');
        }
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description Test method to check the behavior when the input list of updated seasons 
     * is correct.
     */
    @isTest
    static void shouldNotConflictWhenSeasonIsUpdatedAndNameIsCorrect() {
        TV_Series__c tvSeries = [SELECT Id FROM TV_Series__c LIMIT 1];

        List<Season__c> seasons = [SELECT Id, Name FROM Season__c];
        for (Season__c season : seasons) {
            for (Integer i = 10; i < 15; i++) {
                season.Name = 'TestTVSeries S' + i;
            }
        }

        Test.startTest();
        Database.SaveResult[] results = Database.update(seasons, false);
        Test.stopTest();

        for (Database.SaveResult result : results) {
            System.assert(result.isSuccess(), 'Updating seasons should be successful');
        }
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description Test method to check the behavior when the newly inserted season has name that 
     * already exists in TV series.
     */
    @isTest
    static void shouldConflictWhenInsertedAndNameAlreadyExists() {
        TV_Series__c tvSeries = [SELECT Id FROM TV_Series__c LIMIT 1];

        List<Season__c> seasons = new List<Season__c>();
        for (Integer i = 0; i < 5; i++) {
            seasons.add(new Season__c(Name = 'TestTVSeries S0' + i, TV_Series__c = tvSeries.Id));
        }

        Test.startTest();
        Database.SaveResult[] results = Database.insert(seasons, false);
        Test.stopTest();

        for (Database.SaveResult result : results) {
            System.assert(!result.isSuccess(), 'Inserting conflicting seasons should fail');
            System.assertEquals(1, result.getErrors().size(), 'There should be one error message');
        }
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description Test method to check the behavior when the updated season has name that already 
     * exists in TV series.
     */
    @isTest
    static void shouldConflictWhenUpdateddAndNameAlreadyExists() {
        TV_Series__c tvSeries = [SELECT Id FROM TV_Series__c LIMIT 1];
        List<Season__c> seasonsToUpdate = [SELECT Id, Name FROM Season__c];

        List<Season__c> seasons = new List<Season__c>();
        for (Integer i = 10; i < 15; i++) {
            seasons.add(new Season__c(Name = 'TestTVSeries S' + i, TV_Series__c = tvSeries.Id));
        }

        insert seasons;

        for (Season__c season : seasonsToUpdate) {
            for (Integer i = 10; i < 15; i++) {
                season.Name = 'TestTVSeries S' + i;
            }
        }

        Test.startTest();
        Database.SaveResult[] results = Database.update(seasonsToUpdate, false);
        Test.stopTest();

        for (Database.SaveResult result : results) {
            System.assert(!result.isSuccess(), 'Inserting conflicting seasons should fail');
            System.assertEquals(1, result.getErrors().size(), 'There should be one error message');
        }
    }
}
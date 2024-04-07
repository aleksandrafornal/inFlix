/**
 * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
 * @date 07/04/2024
 * @description This class contains test methods for the TVSeriesController.
 */
@isTest
public with sharing class TVSeriesControllerTest {
    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description The method sets up data for tests.
     */
    @testSetup
    static void setup() {
        List<TV_Series__c> testTVSeries = new List<TV_Series__c>();
        for (Integer i = 0; i < 5; i++) {
            testTVSeries.add(new TV_Series__c(
                Name = 'TestTVSeries' + i,
                Logo__c = 'TestTVSeriesLogo' + i,
                Trailer__c = 'TestTVSeriesTrailer' + i
                )
            );
        }
        insert testTVSeries;

        List<Season__c> testSeasons = new List<Season__c>();
        for (Integer i = 0; i < 5; i++) {
            testSeasons.add(new Season__c(
                Name = testTVSeries[0].Name + ' S0' + i,
                TV_Series__c = testTVSeries[0].Id
                )
            );
        }
        insert testSeasons;

        List<Episode__c> testEpisodes = new List<Episode__c>();
        for (Integer i = 0; i < 5; i++) {
            testEpisodes.add(new Episode__c(
                Name = testSeasons[0].Name + 'E00' + i,
                Length_min__c = 50,
                TV_Series__c = testTVSeries[0].Id,
                Season__c = testSeasons[0].Id,
                Title__c = 'TestEpisodeTitle' + i,
                Description__c = 'TestEpisodeDescription' + i,
                Watched__c = false
                )
            );
        }
        insert testEpisodes;
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description Test method to verify that all TV series are returned alphabetically.
     */
    @isTest
    static void shouldReturnAllMovies() {

        Test.startTest();
        List<TV_Series__c> returnedTVSeries = TVSeriesController.getAllTVSeries();
        Test.stopTest();

        System.assertEquals(5, returnedTVSeries.size(), 'Incorrect number of TV series returned');

        for (Integer i = 0; i < returnedTVSeries.size() - 1; i++) {
            System.assert(
                returnedTVSeries[i].Name <= returnedTVSeries[i + 1].Name,
              'TV series are not sorted alphabetically'
            );
        }
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description Test method to verify that all seasons are returned alphabetically by TV series id.
     */
    @isTest
    static void shouldReturnAllSeasons() {
        List<TV_Series__c> tvSeries = [SELECT Id FROM TV_Series__c];

        Test.startTest();
        List<Season__c> returnedSeasons = TVSeriesController.getAllSeasons(tvSeries[0].Id);
        Test.stopTest();

        System.assertEquals(5, returnedSeasons.size(), 'Incorrect number of seasons returned');

        for (Integer i = 0; i < returnedSeasons.size() - 1; i++) {
            System.assert(
                returnedSeasons[i].Name <= returnedSeasons[i + 1].Name,
              'Seasons are not sorted alphabetically'
            );
        }
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description Test method to verify that all episodes are returned alphabetically by season id.
     */
    @isTest
    static void shouldReturnAllEpisodes() {
        List<Season__c> seasons = [SELECT Id FROM Season__c];

        Test.startTest();
        List<Episode__c> returnedEpisodes = TVSeriesController.getAllEpisodes(seasons[0].Id);
        Test.stopTest();

        System.assertEquals(5, returnedEpisodes.size(), 'Incorrect number of episodes returned');

        for (Integer i = 0; i < returnedEpisodes.size() - 1; i++) {
            System.assert(
                returnedEpisodes[i].Name <= returnedEpisodes[i + 1].Name,
              'Episodes are not sorted alphabetically'
            );
        }
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description Test method to verify that all required data from episode is being returned.
     */
    @isTest
    static void shouldReturnMovieDetails() {
        List<Episode__c> episodes = [SELECT
          Id,
          Name,
          Title__c,
          Length_min__c,
          Description__c,
          Watched__c,
          TV_Series__r.Logo__c, 
          TV_Series__r.Trailer__c
        FROM Episode__c
        ];

        Test.startTest();
        List<Episode__c> returnedEpisodes = new List<Episode__c>();
        for (Episode__c episode : episodes) {
            returnedEpisodes.add(
                TVSeriesController.getEpisodeDetails(episode.Id)
            );
          }
        Test.stopTest();

        for (Integer i = 0; i < episodes.size(); i++) {
            Episode__c expectedEpisode = episodes[i];
            Episode__c returnedEpisode = returnedEpisodes[i];
          
            System.assertEquals(
              expectedEpisode.Id,
              returnedEpisode.Id,
              'Incorrect episode was returned'
            );
            System.assertEquals(
              expectedEpisode.Name,
              returnedEpisode.Name,
              'Incorrect episode name was returned'
            );
            System.assertEquals(
              expectedEpisode.Title__c,
              returnedEpisode.Title__c,
              'Incorrect episode title was returned'
            );
            System.assertEquals(
              expectedEpisode.Length_min__c,
              returnedEpisode.Length_min__c,
              'Incorrect episode length was returned'
            );
            System.assertEquals(
              expectedEpisode.Description__c,
              returnedEpisode.Description__c,
              'Incorrect episode description was returned'
            );
            System.assertEquals(
              expectedEpisode.Watched__c,
              returnedEpisode.Watched__c,
              'Incorrect episode watched field was returned'
            );
            System.assertEquals(
              expectedEpisode.TV_Series__r.Logo__c,
              returnedEpisode.TV_Series__r.Logo__c,
              'Incorrect TV series logo was returned'
            );
            System.assertEquals(
              expectedEpisode.TV_Series__r.Trailer__c,
              returnedEpisode.TV_Series__r.Trailer__c,
              'Incorrect TV series trailer was returned'
            );
        }
    }
}
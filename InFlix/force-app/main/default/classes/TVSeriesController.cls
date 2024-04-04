/**
 * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
 * @date 03/04/2024
 * @description This class provides methods for TV series browser and episode details component.
 */
public with sharing class TVSeriesController {
    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 03/04/2024
     * @description The method returns list of TV series with their title, id and logo.
     *
     * @return List of TV series.
     */
    @AuraEnabled(cacheable=true)
    public static List<TV_Series__c> getAllTVSeries() {
      return [
        SELECT Id, Name, Logo__c
        FROM TV_Series__c
        ORDER BY Name
      ];
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 03/04/2024
     * @description The method returns list of seasons from given TV series with their name, id, number 
     * of episodes.
     *
     * @param inTVSeriesId id of chosen TV series.
     * @return List of seasons.
     */
    @AuraEnabled(cacheable=true)
    public static List<Season__c> getAllSeasons(String inTVSeriesId) {
      return [
        SELECT Id, Name, Number_of_episodes__c
        FROM Season__c
        WHERE TV_Series__c = :inTVSeriesId
        ORDER BY Name
      ];
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 03/04/2024
     * @description The method returns list of episodes with their name, id, length in minutes.
     *
     * @param inSeasonId id of chosen season.
     * @return List of episodes.
     */
    @AuraEnabled(cacheable=true)
    public static List<Episode__c> getAllEpisodes(String inSeasonId) {
      return [
        SELECT Id, Name, Length_min__c
        FROM Episode__c
        WHERE Season__c = :inSeasonId
        ORDER BY Name
      ];
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 03/04/2024
     * @description The method returns episode with its id, name, title, length in minutes, watched,
     * description, TV series logo and trailer.
     *
     * @param inEpisodeId id of chosen episode.
     * @return Episode.
     */
    @AuraEnabled(cacheable=true)
    public static Episode__c getEpisodeDetails(String inEpisodeId) {
      return [
        SELECT
          Id,
          Name,
          Title__c,
          Length_min__c,
          Description__c,
          Watched__c,
          TV_Series__r.Logo__c, 
          TV_Series__r.Trailer__c
        FROM Episode__c
        WHERE Id = :inEpisodeId
      ];
    }
}
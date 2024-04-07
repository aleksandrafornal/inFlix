/**
 * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
 * @date 04/04/2024
 * @description This class provides methods for movies browser and details component.
 */
public class MovieController {
    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 04/04/2024
     * @description The method returns list of movies with their title, id and poster.
     *
     * @return List of movies.
     */
    @AuraEnabled(cacheable=true)
    public static List<Movie__c> getAllMovies() {
      return [
        SELECT Id, Name, Poster__c
        FROM Movie__c
        ORDER BY Name
      ];
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 04/04/2024
     * @description The method returns movie with its id, title, length in minutes, watch, favorite, 
     * poster, genres, trailer and description.
     *
     * @param inMovieId id of chosen movie.
     * @return Movie.
     */
    @AuraEnabled(cacheable=true)
    public static Movie__c getMovieDetails(String inMovieId) {
      return [
        SELECT
          Id,
          Name,
          Length_min__c,
          Description__c,
          Genres__c,
          Favorite__c,
          To_watch__c,
          Poster__c,
          Trailer__c
        FROM Movie__c
        WHERE Id = :inMovieId
      ];
    }
}
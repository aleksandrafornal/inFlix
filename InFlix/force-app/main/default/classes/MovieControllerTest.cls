/**
 * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
 * @date 07/04/2024
 * @description This class contains test methods for the MovieController.
 */
@isTest
public class MovieControllerTest {
    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description The method sets up data for tests.
     */
    @testSetup
    static void setup() {
        List<Movie__c> testMovies = new List<Movie__c>();
        for (Integer i = 0; i < 10; i++) {
            testMovies.add(new Movie__c(
                Name = 'TestMovie' + i,
                Length_min__c = 120 + i,
                Description__c = 'TestDescription' + i,
                Genres__c = 'Action',
                Poster__c = 'TestPoster' + i,
                Trailer__c = 'https://www.youtube.com/embed/' + i
                )
            );
        }
        insert testMovies;
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description Test method to verify that all movies are returned alphabetically.
     */
    @isTest
    static void shouldReturnAllMovies() {

        Test.startTest();
        List<Movie__c> returnedMovies = MovieController.getAllMovies();
        Test.stopTest();

        System.assertEquals(10, returnedMovies.size(), 'Incorrect number of movies returned');

        for (Integer i = 0; i < returnedMovies.size() - 1; i++) {
            System.assert(
                returnedMovies[i].Name <= returnedMovies[i + 1].Name,
              'Movies are not sorted alphabetically'
            );
        }
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description Test method to verify that all required data from movies is being returned.
     */
    @isTest
    static void shouldReturnMovieDetails() {
        List<Movie__c> movies = [SELECT
            Id,
            Name,
            Length_min__c,
            Description__c,
            Genres__c,
            Poster__c,
            Trailer__c
        FROM Movie__c
        ];

        Test.startTest();
        List<Movie__c> returnedMovies = new List<Movie__c>();
        for (Movie__c movie : movies) {
            returnedMovies.add(
                MovieController.getMovieDetails(movie.Id)
            );
          }
        Test.stopTest();

        for (Integer i = 0; i < movies.size(); i++) {
            Movie__c expectedMovie = movies[i];
            Movie__c returnedMovie = returnedMovies[i];
          
            System.assertEquals(
              expectedMovie.Id,
              returnedMovie.Id,
              'Incorrect movie was returned'
            );
            System.assertEquals(
              expectedMovie.Name,
              returnedMovie.Name,
              'Incorrect movie name was returned'
            );
            System.assertEquals(
              expectedMovie.Length_min__c,
              returnedMovie.Length_min__c,
              'Incorrect length of movie was returned'
            );
            System.assertEquals(
              expectedMovie.Description__c,
              returnedMovie.Description__c,
              'Incorrect movie description was returned'
            );
            System.assertEquals(
              expectedMovie.Genres__c,
              returnedMovie.Genres__c,
              'Incorrect movie genres was returned'
            );
            System.assertEquals(
              expectedMovie.Poster__c,
              returnedMovie.Poster__c,
              'Incorrect movie poster was returned'
            );
            System.assertEquals(
              expectedMovie.Trailer__c,
              returnedMovie.Trailer__c,
              'Incorrect movie trailer was returned'
            );
        }
    }
}
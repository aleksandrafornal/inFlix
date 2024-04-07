/**
 * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
 * @date 07/04/2024
 * @description This class contains test methods for the RecipesController.
 */
@isTest
public class RecipesControllerTest {
    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description The method sets up data for tests.
     */
    @testSetup
    static void setup() {
        Movie__c movie = new Movie__c(
            Name = 'TestMovie'
        );
        insert movie;

        TV_Series__c tvSeries = new TV_Series__c(
            Name = 'TestTVSeries'
        );
        insert tvSeries;
 
        List<Recipe__c> testMovieRecipes = new List<Recipe__c>();
        for (Integer i = 0; i < 10; i++) {
            testMovieRecipes.add(new Recipe__c(
                Name = 'TestMovieRecipe' + i,
                Ingredients__c = 'TestMovieRecipeIngredients' + i,
                Diet__c = 'Balanced',
                Preparation__c = 'TestMovieRecipePreparation' + i,
                Movie__c = movie.Id
              )
            );
        }
        insert testMovieRecipes;

        List<Recipe__c> testTVSeriesRecipes = new List<Recipe__c>();
        for (Integer i = 0; i < 10; i++) {
            testTVSeriesRecipes.add(new Recipe__c(
                Name = 'TestTVSeriesRecipe' + i,
                Ingredients__c = 'TestTVSeriesRecipeIngredients' + i,
                Diet__c = 'Balanced',
                Preparation__c = 'TestTVSeriesRecipePreparation' + i,
                TV_Series__c = tvSeries.Id
              )
            );
        }
        insert testTVSeriesRecipes;
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description Test method to verify that all recipes related to TV Series are returned 
     * alphabetically.
     */
    @isTest
    static void shouldReturnAllRecipesRelatedToTVSeries() {
        TV_Series__c tvSeries = [SELECT Id FROM TV_Series__c LIMIT 1];

        Test.startTest();
        List<Recipe__c> returnedRecipes = RecipesController.getAllRecipesRelatedToTVSeries(tvSeries.Id);
        Test.stopTest();

        System.assertEquals(10, returnedRecipes.size(), 'Incorrect number of recipes related to TV series');

        for (Integer i = 0; i < returnedRecipes.size() - 1; i++) {
            System.assert(
                returnedRecipes[i].Name <= returnedRecipes[i + 1].Name,
              'Recipes are not sorted alphabetically'
            );
        }
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description Test method to verify that all recipes related to movies are returned 
     * alphabetically.
     */
    @isTest
    static void shouldReturnAllRecipesRelatedToMovies() {
        Movie__c movie = [SELECT Id FROM Movie__c LIMIT 1];

        Test.startTest();
        List<Recipe__c> returnedRecipes = RecipesController.getAllRecipesRelatedToMovie(movie.Id);
        Test.stopTest();

        System.assertEquals(10, returnedRecipes.size(), 'Incorrect number of recipes related to movies');

        for (Integer i = 0; i < returnedRecipes.size() - 1; i++) {
            System.assert(
                returnedRecipes[i].Name <= returnedRecipes[i + 1].Name,
              'Recipes are not sorted alphabetically'
            );
        }
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description Test method to verify that all required data from recipes is being returned.
     */
    @isTest
    static void shouldReturnRecipeDetails() {
        List<Recipe__c> recipes = [SELECT
            Id,
            Name,
            Ingredients__c,
            Diet__c,
            Preparation__c,
            Photo__c
        FROM Recipe__c
        ];

        Test.startTest();
        List<Recipe__c> returnedRecipes = new List<Recipe__c>();
        for (Recipe__c recipe : recipes) {
            returnedRecipes.add(
                RecipesController.getRecipeDetails(recipe.Id)
            );
          }
        Test.stopTest();

        for (Integer i = 0; i < recipes.size(); i++) {
            Recipe__c expectedRecipe = recipes[i];
            Recipe__c returnedRecipe = returnedRecipes[i];
      
            System.assertEquals(
              expectedRecipe.Id,
              returnedRecipe.Id,
              'Incorrect recipe was returned'
            );
            System.assertEquals(
              expectedRecipe.Name,
              returnedRecipe.Name,
              'Incorrect recipe name was returned'
            );
            System.assertEquals(
              expectedRecipe.Ingredients__c,
              returnedRecipe.Ingredients__c,
              'Incorrect recipe ingredients were returned'
            );
            System.assertEquals(
              expectedRecipe.Diet__c,
              returnedRecipe.Diet__c,
              'Incorrect recipe diet was returned'
            );
            System.assertEquals(
              expectedRecipe.Preparation__c,
              returnedRecipe.Preparation__c,
              'Incorrect recipe preparation was returned'
            );
            System.assertEquals(
              expectedRecipe.Photo__c,
              returnedRecipe.Photo__c,
              'Incorrect recipe photo was returned'
            );
        }
    }
}
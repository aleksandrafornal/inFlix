/**
 * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
 * @date 03/04/2024
 * @description This class provides methods for Recipe browser and details component.
 */
public class RecipesController {
    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 06/04/2024
     * @description The method returns list of recipes related to selected TV series.
     *
     * @param inTVSeriesId id of related TV series.
     * @return List of recipes.
     */
    @AuraEnabled(cacheable=true)
    public static List<Recipe__c> getAllRecipesRelatedToTVSeries(String inTVSeriesId) {
      return [
        SELECT Id, Name, Photo__c
        FROM Recipe__c
        WHERE TV_Series__c = :inTVSeriesId
        ORDER BY Name
      ];
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 06/04/2024
     * @description The method returns list of recipes related to selected movie.
     *
     * @param inMovieId id of related movie.
     * @return List of recipes.
     */
    @AuraEnabled(cacheable=true)
    public static List<Recipe__c> getAllRecipesRelatedToMovie(String inMovieId) {
      return [
        SELECT Id, Name, Photo__c
        FROM Recipe__c
        WHERE Movie__c = :inMovieId
        ORDER BY Name
      ];
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 06/04/2024
     * @description The method returns recipe with its id, name, diet, ingredients and preparation.
     *
     * @param inRecipeId id of chosen recipe.
     * @return Recipe.
     */
    @AuraEnabled(cacheable=true)
    public static Recipe__c getRecipeDetails(String inRecipeId) {
      return [
        SELECT
          Id,
          Name,
          Diet__c,
          Ingredients__c,
          Preparation__c,
          Photo__c
        FROM Recipe__c
        WHERE Id = :inRecipeId
      ];
    }
}
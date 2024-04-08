import { LightningElement, wire, api } from 'lwc';
import getAllRecipesRelatedToTVSeries from "@salesforce/apex/RecipesController.getAllRecipesRelatedToTVSeries";

export default class RecipesFromTVSeriesBrowser extends LightningElement {
  @api recordId;
  step = "recipes";
  recipes;
  selectedRecipeId;

  @wire(getAllRecipesRelatedToTVSeries, { inTVSeriesId: "$recordId"})
  wiredMovies({ error, data }) {
    if (data) {
      this.recipes = data.map((recipe) => ({
        title: recipe.Name,
        id: recipe.Id,
        logo: recipe.Photo__c
      }));
    } else if (error) {
      console.error(error);
    }
  }

  get stepEqualsRecipes() {
    return this.step === "recipes";
  }

  get stepEqualsRecipeDetails() {
    return this.step === "recipeDetails";
  }

  handleRecipeSelection(event) {
    this.selectedRecipeId = event.detail;
    this.step = "recipeDetails";
  }

  handleBackToRecipes() {
    this.step = "recipes";
  }
}
import { LightningElement, wire, api } from 'lwc';
import getAllRecipesRelatedToMovie from "@salesforce/apex/RecipesController.getAllRecipesRelatedToMovie";

export default class RecipesFromMovieBrowser extends LightningElement {
  @api recordId;
  step = "recipes";
  recipes;
  selectedRecipeId;

  @wire(getAllRecipesRelatedToMovie, { inMovieId: "$recordId"})
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